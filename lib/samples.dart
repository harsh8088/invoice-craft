import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'data.dart';
import 'samples/invoice.dart';

const samples = <Sample>[
  // Sample('RESUME', 'resume.dart', generateResume),
  // Sample('DOCUMENT', 'document.dart', generateDocument),
  Sample('INVOICE', 'invoice.dart', generateInvoice,true),
  Sample('INVOICE', 'invoice.dart', generateInvoice,true),
  // Sample('REPORT', 'report.dart', generateReport),
  // Sample('CALENDAR', 'calendar.dart', generateCalendar),
  // Sample('CERTIFICATE', 'certificate.dart', generateCertificate, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Sample {
  const Sample(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
