import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResumePreviewScreen extends StatefulWidget {
  const ResumePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  Map<String, PdfPageFormat> pageFormats = {
    'A4': PdfPageFormat.a4,
    // 'A5': PdfPageFormat.a5,
    // 'Letter': PdfPageFormat.letter,
    // 'Legal': PdfPageFormat.legal,
  };
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Resume Preview"),
      ),
      body: PdfPreview(
        dynamicLayout: true,
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        pageFormats: pageFormats,
        pdfFileName: 'Purchase Order 001.pdf',
        build: (format) => _generatePdf(format, 'Purchase Order', width),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    String title,
    double width,
  ) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
      title: title,
      author: 'Meheraj',
      creator: 'Meheraj',
      producer: 'Meheraj',
      subject: 'Resume',
      keywords: 'Resume',
      pageMode: PdfPageMode.fullscreen,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: width / 2 - 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Gold Lavender Co. Ltd.',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          pw.Text(
                            '169-0073\nTokyo to shinjuku ku hyakunincho 2-9-2\nOkayama Business Build 101',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Tel - 0368696171',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Fax - 03-5332-5020',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Email: sales@shinjukuhalalfood.com',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      width: width / 2 - 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'PURCHASE ORDER',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.Text(
                            'DATE: ${DateTime.now().toString().split(' ')[0]}',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'P.O. NO: 0001',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.SizedBox(
                // width: width,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: width / 2 - 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: width / 2,
                            color: PdfColors.blue900,
                            child: pw.Text(
                              'VENDOR',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                          // pw.Text(
                          //   widget.supplier.name!,
                          //   style: pw.TextStyle(
                          //     fontWeight: pw.FontWeight.bold,
                          //   ),
                          // ),
                          // pw.Text(
                          //   widget.supplier.address!,
                          //   style: pw.TextStyle(
                          //     fontWeight: pw.FontWeight.bold,
                          //   ),
                          // ),
                          // pw.Text(
                          //   'Phone: ${widget.supplier.phone!}',
                          //   style: pw.TextStyle(
                          //     fontWeight: pw.FontWeight.bold,
                          //   ),
                          // ),
                          // pw.Text(
                          //   'Email: ${widget.supplier.email!}',
                          //   style: pw.TextStyle(
                          //     fontWeight: pw.FontWeight.bold,
                          //   ),
                          // ),
                          pw.Text(
                            'Date Required:',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      width: width / 2 - 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: width / 2,
                            color: PdfColors.blue900,
                            child: pw.Text(
                              'SHIP TO',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Text(
                            '169-0073\nTokyo to shinjuku ku hyakunincho 2-9-2\nOkayama Business Build 101',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Tel - 0368696171',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Fax - 03-5332-5020',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Email: sales@shinjukuhalalfood.com',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              // pw.Table(
              //   children: [
              //     pw.TableRow(
              //       children: [
              //         pw.Container(
              //           width: 20,
              //           color: PdfColors.blue900,
              //           child: pw.Text(
              //             'SL',
              //             style: pw.TextStyle(
              //               color: PdfColors.white,
              //               fontWeight: pw.FontWeight.bold,
              //             ),
              //             textAlign: pw.TextAlign.center,
              //           ),
              //         ),
              //         pw.VerticalDivider(
              //           color: PdfColors.white,
              //           width: 1,
              //           thickness: 3,
              //           indent: 0,
              //           endIndent: 0,
              //         ),
              //         pw.Container(
              //           width: 80,
              //           color: PdfColors.blue900,
              //           child: pw.Text(
              //             'ITEM (JAN)',
              //             style: pw.TextStyle(
              //               color: PdfColors.white,
              //               fontWeight: pw.FontWeight.bold,
              //             ),
              //             textAlign: pw.TextAlign.center,
              //           ),
              //         ),
              //         pw.VerticalDivider(
              //           color: PdfColors.white,
              //           width: 1,
              //           thickness: 3,
              //           indent: 0,
              //           endIndent: 0,
              //         ),
              //         pw.Container(
              //       color: PdfColors.blue900,
              //       child: pw.Text(
              //         'DESCRIPTION (Name)',
              //         style: pw.TextStyle(
              //           color: PdfColors.white,
              //           fontWeight: pw.FontWeight.bold,
              //         ),
              //         textAlign: pw.TextAlign.center,
              //       ),
              //     ),
              //     pw.VerticalDivider(
              //       color: PdfColors.white,
              //       width: 1,
              //       thickness: 3,
              //       indent: 0,
              //       endIndent: 0,
              //     ),
              //     pw.Container(
              //       width: 20,
              //       color: PdfColors.blue900,
              //       child: pw.Text(
              //         'QTY',
              //         style: pw.TextStyle(
              //           color: PdfColors.white,
              //           fontWeight: pw.FontWeight.bold,
              //         ),
              //         textAlign: pw.TextAlign.center,
              //       ),
              //     ),
              //   ],
              // ),
              // for (var item in widget.stockItems)
              //   pw.TableRow(
              //     children: [
              //       pw.Container(
              //         width: 20,
              //         child: pw.Text(
              //           (widget.stockItems.indexOf(item) + 1).toString(),
              //           style: pw.TextStyle(),
              //           textAlign: pw.TextAlign.center,
              //         ),
              //       ),
              //       pw.VerticalDivider(
              //         color: PdfColors.black,
              //         width: 1,
              //         thickness: 3,
              //         indent: 0,
              //         endIndent: 0,
              //       ),
              //       pw.Container(
              //         width: 80,
              //         child: item['offline_product'].toString() == 'null'
              //             ? pw.Text('N/A')
              //             : pw.Text(item['offline_product']
              //                 .toString()
              //                 .substring(
              //                     15,
              //                     item['offline_product']
              //                             .toString()
              //                             .length -
              //                         1)
              //                 .replaceAll(', ', '\n')
              //                 .replaceAll('_', ' ')
              //                 .split('\n')[1]
              //                 .substring(8)),
              //       ),
              //       pw.VerticalDivider(
              //         color: PdfColors.black,
              //         width: 1,
              //         thickness: 3,
              //         indent: 0,
              //         endIndent: 0,
              //       ),
              //       pw.Container(
              //         // width: width / 10,
              //         child: pw.Text(
              //           item['product_name'],
              //           style: pw.TextStyle(),
              //         ),
              //       ),
              //       pw.VerticalDivider(
              //         color: PdfColors.black,
              //         width: 1,
              //         thickness: 3,
              //         indent: 0,
              //         endIndent: 0,
              //       ),
              //       pw.Container(
              //         width: 20,
              //         child: pw.Text(
              //           item['quantity'].toString(),
              //           style: pw.TextStyle(),
              //           textAlign: pw.TextAlign.center,
              //         ),
              //       ),
              //     ],
              //   ),
              // pw.TableRow(
              //   children: [
              //     pw.Container(
              //       width: 20,
              //       child: pw.Text(''),
              //     ),
              //     pw.VerticalDivider(
              //       color: PdfColors.black,
              //       width: 1,
              //       thickness: 3,
              //       indent: 0,
              //       endIndent: 0,
              //     ),
              //     pw.Container(
              //       width: 80,
              //       child: pw.Text(''),
              //     ),
              //     pw.VerticalDivider(
              //       color: PdfColors.black,
              //       width: 1,
              //       thickness: 3,
              //       indent: 0,
              //       endIndent: 0,
              //     ),
              //     pw.Container(
              //       // width: width / 10,
              //       child: pw.Text(
              //         'Total Items:',
              //         style: pw.TextStyle(),
              //         textAlign: pw.TextAlign.right,
              //       ),
              //     ),
              //     pw.VerticalDivider(
              //       color: PdfColors.black,
              //       width: 1,
              //       thickness: 3,
              //       indent: 0,
              //       endIndent: 0,
              //     ),
              //     pw.Container(
              //       width: 20,
              //       child: pw.Text(
              //         widget.stockItems.length.toString(),
              //         style: pw.TextStyle(),
              //         textAlign: pw.TextAlign.center,
              //       ),
              //     ),
              //   ],
              // ),
              // pw.TableRow(
              //   children: [
              //     pw.Container(
              //       width: 20,
              //       child: pw.Text(''),
              //     ),
              //     pw.VerticalDivider(
              //       color: PdfColors.black,
              //       width: 1,
              //       thickness: 3,
              //       indent: 0,
              //       endIndent: 0,
              //     ),
              //     pw.Container(
              //       width: 80,
              //       child: pw.Text(''),
              //     ),
              //     pw.VerticalDivider(
              //       color: PdfColors.black,
              //       width: 1,
              //       thickness: 3,
              //       indent: 0,
              //       endIndent: 0,
              //     ),
              //     pw.Container(
              //       // width: width / 10,
              //       child: pw.Text(
              //         'Total Qty:',
              //         style: pw.TextStyle(),
              //         textAlign: pw.TextAlign.right,
              //       ),
              //     ),
              //     pw.VerticalDivider(
              //       color: PdfColors.black,
              //       width: 1,
              //       thickness: 3,
              //       indent: 0,
              //       endIndent: 0,
              //     ),
              //     pw.Container(
              //       width: 20,
              //       child: pw.Text(
              //         totalQuantity.toString(),
              //         style: pw.TextStyle(),
              //         textAlign: pw.TextAlign.center,
              //       ),
              //     ),
              //   ],
              // ),
              // ],
              // ),
              pw.SizedBox(height: 30),
              pw.Divider(color: PdfColors.black, thickness: 1),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Authorized By:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Name: Rasel',
                        style: pw.TextStyle(),
                      ),
                      pw.Text(
                        'Email: ',
                        style: pw.TextStyle(),
                      ),
                      pw.Text(
                        'Phone: ',
                        style: pw.TextStyle(),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Date:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        DateTime.now().toString().substring(0, 10),
                        style: pw.TextStyle(),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: PdfColors.black, thickness: 1),
              pw.Container(
                width: double.infinity,
                child: pw.Text(
                  'If you have any questions about this purchase order, please contact',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: double.infinity,
                child: pw.Text(
                  'Gold Lavender Co. Ltd\nTel - 0368696171',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
