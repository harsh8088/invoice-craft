import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';
import 'address_model.dart';

class TodosObjectBox {
  late final Store store;
  late final Box<AddressModel> noteBox;

  TodosObjectBox._create(this.store) {
    noteBox = Box<AddressModel>(store);
    if (noteBox.isEmpty()) {
      _putDemoData();
    }
  }

  static Future<TodosObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return TodosObjectBox._create(store);
  }

  void _putDemoData() {
    final demoNote = AddressModel(
        title: 'User Name', comment: 'HNo. 3012 SecondFloor Sector 10, Gurgoan 122003', date: DateTime.now());
    noteBox.put(demoNote);
  }

  Stream<List<AddressModel>> getNotes() {
    final builder =
        noteBox.query().order(AddressModel_.date, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  void removeNote(int id) {
    noteBox.remove(id);
  }

  Future<void> addNotes(AddressModel data) async {
    noteBox.put(data);
  }
}
