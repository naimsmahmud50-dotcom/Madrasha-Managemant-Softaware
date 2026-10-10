import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generateAndPrintMarksheet({
    required String studentName,
    required String studentRoll,
    required String className,
    required String examName,
    required Map<String, dynamic> subjects,
    required String totalScore,
    required String grade,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'AL JAMIATUL ISLAMIA',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.indigo900,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text('Academic Progress Report', style: pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 4),
                      pw.Text(examName, style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 32),
                pw.Divider(),
                pw.SizedBox(height: 16),

                // Student Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Student Name: $studentName', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 8),
                        pw.Text('Class/Jamaat: $className', style: const pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Roll / ID: $studentRoll', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 8),
                        pw.Text('Final Grade: $grade', style: const pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),

                // Marks Table
                pw.TableHelper.fromTextArray(
                  headers: ['Subject', 'Marks', 'Grade', 'Full Marks'],
                  data: subjects.entries.map((e) {
                    final subjData = e.value as Map<String, dynamic>;
                    return [
                      e.key, 
                      subjData['marks'].toString(),
                      subjData['grade'].toString(),
                      '100'
                    ];
                  }).toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
                  cellHeight: 30,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                  },
                ),
                pw.SizedBox(height: 16),

                // Total Row
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Total Score: ', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(width: 8),
                    pw.Text(totalScore, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Signatures
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(width: 100, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 8),
                        pw.Text('Class Teacher'),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(width: 100, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 8),
                        pw.Text('Principal / Muhtamim'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Marksheet_${studentRoll}_$examName.pdf',
    );
  }

  static Future<void> generateAndPrintIdCard({
    required String studentName,
    required String studentRoll,
    required String className,
    required String phone,
    required String bloodGroup,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(54 * PdfPageFormat.mm, 86 * PdfPageFormat.mm), // Standard ID Card size
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.indigo900, width: 2),
            ),
            child: pw.Column(
              children: [
                // Header
                pw.Container(
                  color: PdfColors.indigo900,
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Column(
                    children: [
                      pw.Text('AL JAMIATUL ISLAMIA', style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text('STUDENT ID CARD', style: pw.TextStyle(color: PdfColors.white, fontSize: 8)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                
                // Photo Placeholder
                pw.Container(
                  width: 50,
                  height: 50,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.indigo900),
                  ),
                  child: pw.Center(child: pw.Text('PHOTO', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey))),
                ),
                pw.SizedBox(height: 10),

                // Details
                pw.Text(studentName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                pw.SizedBox(height: 4),
                pw.Text('Class: $className', style: const pw.TextStyle(fontSize: 9)),
                pw.Text('Roll: $studentRoll', style: const pw.TextStyle(fontSize: 9)),
                pw.SizedBox(height: 8),
                
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Phone: $phone', style: const pw.TextStyle(fontSize: 8)),
                      pw.Text('Blood Group: $bloodGroup', style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                ),
                
                pw.Spacer(),
                
                // Footer
                pw.Container(
                  width: double.infinity,
                  color: PdfColors.indigo900,
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Principal Signature', style: const pw.TextStyle(color: PdfColors.white, fontSize: 6), textAlign: pw.TextAlign.center),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'IDCard_$studentRoll.pdf',
    );
  }
}

