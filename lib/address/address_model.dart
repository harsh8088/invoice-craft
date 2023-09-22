import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AddressModel {
  int id;
  String title;
  String comment;
  DateTime? date;

  AddressModel(
      {this.id = 0, required this.title, required this.comment, this.date});

  String get dateFormat => DateFormat.MMMd().format(date!);

  String get timeFormat => DateFormat.Hm().format(date!);
}
