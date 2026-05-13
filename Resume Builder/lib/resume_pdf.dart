// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// // import 'package:pdf_google_fonts/pdf_google_fonts.dart';

// PdfColor green = PdfColor.fromInt(0xff9ce5f0);
// PdfColor litegreen = PdfColor.fromInt(0xffcdfe77);

// const sop = 12.0;

// Future<File> generateResume(
//   PdfPageFormat format, {
//   required String name,
//   required String email,
//   required String jobTitle,
//   required String address,
//   required String phone,
//   required String website,
//   required String profileImagePath,
//   required List<Map<String, String>> workExperience,
//   required List<Map<String, String>> educationList,
//   required List<Map<String, dynamic>> skills,
//   required String dateOfBirth,
//   required String gender,
//   required List<String> interests,
// }) async {
//   final doc = pw.Document(title: "My Resume", author: name);

//   final profileImage = pw.MemoryImage(
//     (await rootBundle.load(profileImagePath)).buffer.asUint8List(),
//   );

//   final outputDir=await getApplicationDocumentsDirectory(); //save file
//   final resumeFile=File("${soutputDir.path}/resume.pdf");
//   resumeFile.writeAsBytes(dec.save);
//   await resumeFile.writeAsBytes(await doc.save());
//   android: /data/user/com.example/resumate/
//   final pageTheme = await _myPageTheme(format);

//   doc.addPage(
//     pw.MultiPage(
//       pageTheme: pageTheme,
//       build: (pw.Context context) => [
//         pw.Container(
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: <pw.Widget>[
//               pw.Container(
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       name,
//                       textScaleFactor: 2,
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       jobTitle,
//                       textScaleFactor: 1.2,
//                       style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         color: PdfColors.blueGrey,
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),

//                     pw.Row(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Container(
//                           width: 80,
//                           height: 80,
//                           decoration: pw.BoxDecoration(
//                             shape: pw.BoxShape.circle,
//                             image: pw.DecorationImage(
//                               image: profileImage,
//                               fit: pw.BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         pw.SizedBox(width: 20),
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text("Email: $email"),
//                             pw.Text("Phone: $phone"),
//                             pw.Text("Address: $address"),
//                             pw.Text("Website: $website"),
//                             _URLText("Email Link", "mailto:$email"),
//                             _URLText(
//                               "Website Link",
//                               website.startsWith('http')
//                                   ? website
//                                   : "https://$website",
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     _Category(title: "Intersets"),
//                     for (var interest in interests) pw.Text("- $interest"),
//                     pw.Row(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Expanded(
//                           child: pw.Column(
//                             children: [
//                               _Category(title: "Work Experience"),
//                               for (var work in workExperience)
//                                 _Block(
//                                   title: work["JobTitle"] ?? " ",
//                                   description: work["decription"] ?? "",
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),

//                     _Category(title: "Education"),
//                     for (var interest in interests) pw.Text("- $interest"),
//                     pw.Row(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Expanded(
//                           child: pw.Column(
//                             children: [
//                               _Category(title: "Work Experience"),
//                               for (var education in educationList)
//                                 _Block(
//                                   title: education["work experince"] ?? " ",
//                                   description: "${education["description"]??"}" \n Level:${education["EducationLevel"]} ?? "",

//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),





//                     pw.Partition(width: sop,child: pw.Column(
//                       children: [
//                         pw.Container(
//                           height: pageTheme.pageFormat.availableHeight,
//                           child: pw.Column(
//                             crossAxisAlignment: pw.CrossAxisAlignment.center,
//                             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                             children: [
//                               pw.ClipOval(
//                                 child: pw.Container(
//                                   height: 100,
//                                   width: 100,
//                                   child: pw.Image(profileImage)
//                                 ),
//                                 pw.Column(
//                                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                                   children: [
//                                     _Category(title:"skills"),
//                                     for[var skill in skills]
//                                     _SkillProgress(size: 60, value: skills["proficiency"], title: pw.Text("${skill["skill"]}"))
//                                   ]
//                                 )
//                                 ,
//                                 // qr code
//                                 pw.BarcodeWidget(
//                                   data: " pass any link", 
//                                   height: 60,
//                                   width: 60,
//                                   barcode:
                                
//                                  pw.Barcode.fromType[pw.BarcodeType.QrCode])
//                               ),


//                             ]
//                           ),
//   )
// ]
//                     )),



//                     pw.Container(
//                       margin: const pw.EdgeInsets.only(top: 20, bottom: 10),
//                       padding: const pw.EdgeInsets.fromLTRB(10, 4, 18, 4),
//                       decoration: pw.BoxDecoration(
//                         color: litegreen,
//                         borderRadius: const pw.BorderRadius.all(
//                           pw.Radius.circular(6),
//                         ),
//                       ),
//                       child: pw.Text(
//                         "Interests",
//                         textScaleFactor: 1.5,
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                       ),
//                     ),
//                     pw.Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: interests
//                           .map(
//                             (interest) => pw.Container(
//                               padding: const pw.EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: pw.BoxDecoration(
//                                 borderRadius: pw.BorderRadius.circular(4),
//                                 color: PdfColors.grey300,
//                               ),
//                               child: pw.Text(interest),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );

//   final file = File('resume.pdf');
//   await file.writeAsBytes(await doc.save());
//   return file;
// }

// Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
//   final bgShapeData = (await rootBundle.load(
//     'assets/resume.svg',
//   )).buffer.asUint8List();

//   final pageFormat = format.applyMargin(
//     left: 2.0 * PdfPageFormat.cm,
//     top: 2.0 * PdfPageFormat.cm,
//     right: 2.0 * PdfPageFormat.cm,
//     bottom: 2.0 * PdfPageFormat.cm,
//   );

//   return pw.PageTheme(
//     pageFormat: pageFormat,
//     theme: pw.ThemeData.withFont(
//       base: await PdfGoogleFonts.openSansRegular(),
//       bold: await PdfGoogleFonts.openSansBold(),
//       icons: await PdfGoogleFonts.materialIcons(),
//     ),

//     buildBackground: (pw.Context context) {
//       return pw.FullPage(
//         ignoreMargins: true,
//         child: pw.Stack(
//           children: [
//             pw.Positioned(
//               left: 0,
//               top: 0,
//               child: pw.SvgImage(svg: "assets/resume.svg"),
//             ),
//             pw.Positioned(
//               right: 0,
//               bottom: 0,
//               child: pw.Transform.rotate(
//                 angle: pi,
//                 child: pw.SvgImage(svg: "assets/resume.svg"),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// class _URLText extends pw.StatelessWidget {
//   final String text;
//   final String url;

//   _URLText(this.text, this.url);

//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.UrlLink(
//       destination: url,
//       child: pw.Text(
//         text,
//         style: pw.TextStyle(
//           decoration: pw.TextDecoration.underline,
//           color: PdfColors.blue,
//         ),
//       ),
//     );
//   }
// }

// class _Block extends pw.StatelessWidget {
//   _Block(this.title, this.description);
//   final String title;
//   final String description;
//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Row(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Container(
//               width: 6,
//               height: 6,
//               margin: pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
//               decoration: pw.BoxDecoration(
//                 color: green,
//                 shape: pw.BoxShape.circle,
//               ),
//             ),
//             pw.Text(
//               title,
//               style: pw.Theme.of(
//                 context,
//               ).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
//             ),
//           ],
//         ),

//         pw.Container(
//           width: 6,
//           height: 6,
//           margin: pw.EdgeInsets.only(left: 2),
//           padding: pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
//           decoration: pw.BoxDecoration(
//             border: pw.Border(left: pw.BorderSide(color: green, width: 2)),
//           ),
//         ),
//       ],
//     );
//   }
// }


// class _SkillProgress extends pw.StatelessWidget{
//   _SkillProgress({required this.size,required this.value,required this.title});
//   final double size;
//   final double value;
//   final pw.widget title;
  
//   @override
//   pw.Widget build(pw.Context context){
//     return pw.Column(
//       children: [
//         width:size,
//         height:size,
//         child:pw.Stack(
//           alignment:pw.Alignment.center,
//           fit:pw.StackFit.expand,
//           children:[
//             pw.Center((
//               child: pw.Text("${(value * 100).round()}%")
//             ),
//             pw.CircularProgressIndicator(backgroundColor:PdfColors.grey300,
//             color:green,
//             value:value,
//             strokewidth:5
//             ),
//             )
//           ]
//         )
//       ]
//     );
//   }
  

// }





// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// PdfColor green = PdfColor.fromInt(0xff9ce5f0);
// PdfColor litegreen = PdfColor.fromInt(0xffcdfe77);

// const sop = 12.0;

// Future<File> generateResume(
//   PdfPageFormat format, {
//   required String name,
//   required String email,
//   required String jobTitle,
//   required String address,
//   required String phone,
//   required String website,
//   required String profileImagePath,
//   required List<Map<String, String>> workExperience,
//   required List<Map<String, String>> educationList,
//   required List<Map<String, dynamic>> skills,
//   required String dateOfBirth,
//   required String gender,
//   required List<String> interests,
// }) async {
//   final doc = pw.Document(title: "My Resume", author: name);

//   final profileImage = pw.MemoryImage(
//     (await rootBundle.load(profileImagePath)).buffer.asUint8List(),
//   );

//   final pageTheme = await _myPageTheme(format);

//   doc.addPage(
//     pw.MultiPage(
//       pageTheme: pageTheme,
//       build: (context) => [
//         pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               name,
//               textScaleFactor: 2,
//               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 10),
//             pw.Text(
//               jobTitle,
//               textScaleFactor: 1.2,
//               style: pw.TextStyle(
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.blueGrey,
//               ),
//             ),
//             pw.SizedBox(height: 10),

//             pw.Row(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Container(
//                   width: 80,
//                   height: 80,
//                   decoration: pw.BoxDecoration(
//                     shape: pw.BoxShape.circle,
//                     image: pw.DecorationImage(
//                       image: profileImage,
//                       fit: pw.BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 pw.SizedBox(width: 20),

//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text("Email: $email"),
//                     pw.Text("Phone: $phone"),
//                     pw.Text("Address: $address"),
//                     pw.Text("Website: $website"),
//                     _URLText("Email Link", "mailto:$email"),
//                     _URLText("Website Link",
//                         website.startsWith('http') ? website : "https://$website"),
//                   ],
//                 ),
//               ],
//             ),

//             _Category(title: "Interests"),
//             for (var i in interests) pw.Text("- $i"),

//             _Category(title: "Work Experience"),
//             for (var work in workExperience)
//               _Block(
//                 work["JobTitle"] ?? "",
//                 work["description"] ?? "",
//               ),

//             _Category(title: "Education"),
//             for (var edu in educationList)
//               _Block(
//                 edu["EducationLevel"] ?? "",
//                 edu["description"] ?? "",
//               ),

//             _Category(title: "Skills"),
//             for (var skill in skills)
//               _SkillProgress(
//                 size: 60,
//                 value: (skill["proficiency"] ?? 0) / 100,
//                 title: skill["skill"] ?? "",
//               ),

//             pw.SizedBox(height: 20),
//             pw.BarcodeWidget(
//               height: 80,
//               width: 80,
//               data: "https://example.com",
//               barcode: pw.Barcode.qrCode(),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );

//   final directory = await getApplicationDocumentsDirectory();
//   final file = File("${directory.path}/resume.pdf");
//   await file.writeAsBytes(await doc.save());
//   return file;
// }

// Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
//   final pageFormat = format.applyMargin(
//     left: 2 * PdfPageFormat.cm,
//     top: 2 * PdfPageFormat.cm,
//     right: 2 * PdfPageFormat.cm,
//     bottom: 2 * PdfPageFormat.cm,
//   );

//   return pw.PageTheme(pageFormat: pageFormat);
// }

// class _URLText extends pw.StatelessWidget {
//   final String text;
//   final String url;

//   _URLText(this.text, this.url);

//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.UrlLink(
//       destination: url,
//       child: pw.Text(
//         text,
//         style: pw.TextStyle(
//           decoration: pw.TextDecoration.underline,
//           color: PdfColors.blue,
//         ),
//       ),
//     );
//   }
// }

// class _Category extends pw.StatelessWidget {
//   final String title;
//   _Category({required this.title});

//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.Container(
//       margin: pw.EdgeInsets.symmetric(vertical: 10),
//       padding: pw.EdgeInsets.all(6),
//       decoration: pw.BoxDecoration(
//         color: litegreen,
//         borderRadius: pw.BorderRadius.circular(6),
//       ),
//       child: pw.Text(
//         title,
//         style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
//       ),
//     );
//   }
// }

// class _Block extends pw.StatelessWidget {
//   final String title;
//   final String description;

//   _Block(this.title, this.description);

//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Row(
//           children: [
//             pw.Container(
//               width: 6,
//               height: 6,
//               decoration:
//                   pw.BoxDecoration(color: green, shape: pw.BoxShape.circle),
//               margin: pw.EdgeInsets.only(right: 5),
//             ),
//             pw.Text(
//               title,
//               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             ),
//           ],
//         ),
//         pw.Padding(
//           padding: pw.EdgeInsets.only(left: 15, top: 4, bottom: 6),
//           child: pw.Text(description),
//         ),
//       ],
//     );
//   }
// }




// class _SkillProgress extends pw.StatelessWidget {
//   _SkillProgress({required this.size, required this.value, required this.title});
//   final double size;
//   final double value;
//   final String title;

//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.Column(
//       children: [
//         pw.Container(
//           width: size,
//           height: size,
//           child: pw.Stack(
//             alignment: pw.Alignment.center,
//             fit: pw.StackFit.expand,
//             children: [
//               pw.CircularProgressIndicator(
//                 backgroundColor: PdfColors.grey300,
//                 color: green,
//                 value: value,
//                 strokeWidth: 5,
//               ),
//               pw.Center(
//                 child: pw.Text("${(value * 100).round()}%"),
//               ),
//             ],
//           ),
//         ),
//         pw.SizedBox(height: 6),
//         pw.Text(title),
//       ],
//     );
//   }
// }





// lib/resume_pdf.dart
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final PdfColor _green = PdfColor.fromInt(0xff9ce5f0);
final PdfColor _liteGreen = PdfColor.fromInt(0xffcdfe77);

Future<File> generateResume(
  PdfPageFormat format, {
  required String name,
  required String email,
  required String jobTitle,
  required String address,
  required String phone,
  required String website,
  required String profileImagePath, // asset path like 'assets/images/me.png' (optional)
  required List<Map<String, String>> workExperience,
  required List<Map<String, String>> educationList,
  required List<Map<String, dynamic>> skills,
  required String dateOfBirth,
  required String gender,
  required List<String> interests,
}) async {
  final doc = pw.Document(title: "Resume - $name", author: name);

  pw.Widget profileImageWidget = pw.Container(); // default empty

  if (profileImagePath.isNotEmpty) {
    try {
      final bytes = (await rootBundle.load(profileImagePath)).buffer.asUint8List();
      final image = pw.MemoryImage(bytes);
      profileImageWidget = pw.Container(
        width: 80,
        height: 80,
        decoration: pw.BoxDecoration(
          shape: pw.BoxShape.circle,
          image: pw.DecorationImage(image: image, fit: pw.BoxFit.cover),
        ),
      );
    } catch (e) {
      // If image load fails, we simply show an empty circle placeholder
      profileImageWidget = pw.Container(
        width: 80,
        height: 80,
        decoration: pw.BoxDecoration(
          shape: pw.BoxShape.circle,
          color: PdfColors.grey300,
        ),
      );
    }
  } else {
    profileImageWidget = pw.Container(
      width: 80,
      height: 80,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: PdfColors.grey300,
      ),
    );
  }

  final pageTheme = await _myPageTheme(format);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      build: (context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(name,
                textScaleFactor: 2,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text(jobTitle,
                textScaleFactor: 1.1,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey)),
            pw.SizedBox(height: 12),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                profileImageWidget,
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Email: $email"),
                      pw.Text("Phone: $phone"),
                      pw.Text("Address: $address"),
                      pw.Text("Website: ${website.isEmpty ? 'N/A' : website}"),
                      pw.SizedBox(height: 6),
                      pw.Row(children: [
                        pw.UrlLink(
                            destination: "mailto:$email",
                            child: pw.Text("Send Email",
                                style: pw.TextStyle(
                                    decoration: pw.TextDecoration.underline,
                                    color: PdfColors.blue))),
                        pw.SizedBox(width: 12),
                        pw.UrlLink(
                            destination: website.startsWith('http')
                                ? website
                                : "https://$website",
                            child: pw.Text("Open Website",
                                style: pw.TextStyle(
                                    decoration: pw.TextDecoration.underline,
                                    color: PdfColors.blue))),
                      ]),
                    ],
                  ),
                )
              ],
            ),
            pw.SizedBox(height: 12),

            _category("Interests"),
            if (interests.isEmpty) pw.Text("- Not specified"),
            for (var i in interests) pw.Text("- $i"),
            pw.SizedBox(height: 8),

            _category("Work Experience"),
            if (workExperience.isEmpty) pw.Text("No work experience provided."),
            for (var work in workExperience)
              _block(
                work['jobTitle'] ?? work['JobTitle'] ?? '',
                work['description'] ?? '',
                meta: work['company'] ?? '',
              ),
            pw.SizedBox(height: 8),

            _category("Education"),
            if (educationList.isEmpty) pw.Text("No education provided."),
            for (var edu in educationList)
              _block(
                edu['degree'] ?? edu['EducationLevel'] ?? '',
                edu['description'] ?? '',
                meta: edu['institution'] ?? edu['school'] ?? edu['EducationBoard'] ?? '',
              ),
            pw.SizedBox(height: 8),

            _category("Skills"),
            pw.Wrap(
              spacing: 12,
              runSpacing: 12,
              children: skills.map((s) {
                final skillTitle = (s['skill'] ?? s['name'] ?? '').toString();
                dynamic rawProf = s['proficiency'] ?? s['procent'] ?? 0;
                double value = 0;
                if (rawProf is double) {
                  value = rawProf;
                } else if (rawProf is int) {
                  // if 0..100 scale -> convert; if 0..1 -> keep
                  value = (rawProf > 1) ? (rawProf / 100.0) : rawProf.toDouble();
                } else if (rawProf is String) {
                  final parsed = double.tryParse(rawProf) ?? 0.0;
                  value = (parsed > 1) ? (parsed / 100.0) : parsed;
                } else {
                  value = 0;
                }
                value = value.clamp(0.0, 1.0);
                return _skillProgress(size: 70, value: value, title: skillTitle);
              }).toList(),
            ),
            pw.SizedBox(height: 12),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("DOB: $dateOfBirth"),
                      pw.Text("Gender: ${gender.isEmpty ? 'N/A' : gender}"),
                    ]),
                pw.Container(
                  width: 80,
                  height: 80,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: "https://example.com",
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf");
  await file.writeAsBytes(await doc.save());
  return file;
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final pageFormat = format.applyMargin(
    left: 2 * PdfPageFormat.cm,
    top: 2 * PdfPageFormat.cm,
    right: 2 * PdfPageFormat.cm,
    bottom: 2 * PdfPageFormat.cm,
  );
  return pw.PageTheme(pageFormat: pageFormat);
}

pw.Widget _category(String title) {
  return pw.Container(
    margin: pw.EdgeInsets.symmetric(vertical: 8),
    padding: pw.EdgeInsets.all(6),
    decoration: pw.BoxDecoration(
      color: _liteGreen,
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
    ),
  );
}

pw.Widget _block(String title, String description, {String meta = ""}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 6,
            height: 6,
            margin: pw.EdgeInsets.only(top: 6, right: 6),
            decoration: pw.BoxDecoration(color: _green, shape: pw.BoxShape.circle),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              if (meta.isNotEmpty) pw.Text(meta, style: pw.TextStyle(fontSize: 9)),
            ],
          ),
        ],
      ),
      pw.Padding(
        padding: pw.EdgeInsets.only(left: 14, top: 4, bottom: 6),
        child: pw.Text(description),
      ),
    ],
  );
}

pw.Widget _skillProgress({required double size, required double value, required String title}) {
  return pw.Column(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      pw.Container(
        width: size,
        height: size,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          fit: pw.StackFit.expand,
          children: [
            pw.CircularProgressIndicator(
              backgroundColor: PdfColors.grey300,
              color: _green,
              value: value,
              strokeWidth: 5,
            ),
            pw.Center(child: pw.Text("${(value * 100).round()}%")),
          ],
        ),
      ),
      pw.SizedBox(height: 6),
      pw.Text(title, style: pw.TextStyle(fontSize: 10)),
    ],
  );
}
