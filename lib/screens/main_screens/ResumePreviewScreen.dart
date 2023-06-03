import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocv/apis/education.dart';
import 'package:gocv/apis/experience.dart';
import 'package:gocv/apis/language.dart';
import 'package:gocv/apis/reference.dart';
import 'package:gocv/apis/resume.dart';
import 'package:gocv/apis/skill.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResumePreviewScreen extends StatefulWidget {
  final String resumeId;
  const ResumePreviewScreen({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  late Map<String, dynamic> resumeDetails = {};
  List<dynamic> educationList = [];
  List<dynamic> experienceList = [];
  List<dynamic> skillList = [];
  List<dynamic> awardList = [];
  List<dynamic> certificationList = [];
  List<dynamic> interestList = [];
  List<dynamic> languageList = [];
  List<dynamic> referenceList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  Map<String, PdfPageFormat> pageFormats = {
    'A4': PdfPageFormat.a4,
    // 'A5': PdfPageFormat.a5,
    // 'Letter': PdfPageFormat.letter,
    // 'Legal': PdfPageFormat.legal,
  };

  late ByteData image;
  late Uint8List imageData;

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    image = await rootBundle.load('assets/avatars/rdj.png');
    imageData = (image).buffer.asUint8List();

    fetchResumeDetails(tokens['access'], widget.resumeId);
  }

  fetchResumeDetails(String accessToken, String resumeId) {
    ResumeService().getResumeDetails(accessToken, resumeId).then((data) async {
      if (data['status'] == 200) {
        setState(() {
          resumeDetails = data['data'];
        });

        fetchEducations(tokens['access'], resumeDetails['uuid']);
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(context, 'Session expired', Colors.red);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
        setState(() {
          isLoading = false;
          isError = true;
          errorText = data['error'];
        });
        Helper().showSnackBar(context, 'Failed to fetch resumes', Colors.red);
      }
    });
  }

  fetchEducations(String accessToken, String resumeId) {
    EducationService()
        .getEducationList(accessToken, resumeId)
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          educationList = data['data'];
        });

        fetchWorkExperiences(tokens['access'], resumeDetails['uuid']);
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(
            context,
            'Session expired',
            Colors.red,
          );
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          print(data['error']);
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch educations',
            Colors.red,
          );
        }
      }
    });
  }

  fetchWorkExperiences(String accessToken, String resumeId) {
    ExpreienceService()
        .getExperienceList(accessToken, resumeId)
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          experienceList = data['data'];
        });

        fetchSkills(tokens['access'], resumeDetails['uuid']);
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(
            context,
            'Session expired',
            Colors.red,
          );
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          print(data['error']);
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch work experiences',
            Colors.red,
          );
        }
      }
    });
  }

  fetchSkills(String accessToken, String resumeId) {
    SkillService().getSkillList(accessToken, resumeId).then((data) async {
      if (data['status'] == 200) {
        setState(() {
          skillList = data['data'];
        });

        fetchLanguages(tokens['access'], resumeDetails['uuid']);
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(
            context,
            'Session expired',
            Colors.red,
          );
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          print(data['error']);
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch skills',
            Colors.red,
          );
        }
      }
    });
  }

  fetchLanguages(String accessToken, String resumeId) {
    LanguageService().getLanguageList(accessToken, resumeId).then((data) async {
      if (data['status'] == 200) {
        setState(() {
          languageList = data['data'];
        });

        fetchReferences(tokens['access'], resumeDetails['uuid']);
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(
            context,
            'Session expired',
            Colors.red,
          );
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          print(data['error']);
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch languages',
            Colors.red,
          );
        }
      }
    });
  }

  fetchReferences(String accessToken, String resumeId) {
    ReferenceService()
        .getReferenceList(accessToken, resumeId)
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          referenceList = data['data'];
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(
            context,
            'Session expired',
            Colors.red,
          );
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          print(data['error']);
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch work experiences',
            Colors.red,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Preview"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PdfPreview(
              dynamicLayout: true,
              allowPrinting: true,
              allowSharing: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
              pageFormats: pageFormats,
              pdfFileName: resumeDetails['name'] + '.pdf',
              build: (format) => _generatePdf(format, 'Purchase Order', width),
            ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    String title,
    double width,
  ) {
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
      pw.MultiPage(
        pageFormat: format,
        footer: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                resumeDetails['personal']['first_name'] +
                    ' ' +
                    resumeDetails['personal']['last_name'],
                style: const pw.TextStyle(
                  fontSize: 10,
                ),
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          );
        },
        build: (context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            resumeDetails['personal']['first_name'] +
                                ' ' +
                                resumeDetails['personal']['last_name'],
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            resumeDetails['contact']['address'] ?? '',
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            resumeDetails['contact']['phone_number'] ?? '',
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            resumeDetails['contact']['email'] ?? '',
                          ),
                        ),
                      ],
                    ),
                    pw.Image(
                      pw.MemoryImage(imageData),
                      height: 80,
                      width: 80,
                    ),
                  ],
                ),
                sectionHeader('OBJECTIVE'),
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(
                    resumeDetails['personal']['about_me'] ?? '',
                    textAlign: pw.TextAlign.justify,
                  ),
                ),
                educationList.isNotEmpty
                    ? sectionHeader('EDUCATION')
                    : pw.SizedBox(),
                for (var item in educationList) educationItem(item),
                experienceList.isNotEmpty
                    ? sectionHeader('EXPERIENCE')
                    : pw.SizedBox(),
                for (var item in experienceList) experienceItem(item),
                skillList.isNotEmpty ? sectionHeader('SKILLS') : pw.SizedBox(),
                for (var item in skillList) skillItem(item),
                awardList.isNotEmpty ? sectionHeader('AWARDS') : pw.SizedBox(),
                for (var item in awardList) skillItem(item),
                certificationList.isNotEmpty
                    ? sectionHeader('CERTIFICATIONS')
                    : pw.SizedBox(),
                for (var item in certificationList) skillItem(item),
                interestList.isNotEmpty
                    ? sectionHeader('INTERESTS')
                    : pw.SizedBox(),
                for (var item in interestList) skillItem(item),
                languageList.isNotEmpty
                    ? sectionHeader('LANGUAGES')
                    : pw.SizedBox(),
                for (var item in languageList) languageItem(item),
                referenceList.isNotEmpty
                    ? sectionHeader('REFERENCES')
                    : pw.SizedBox(),
                for (var item in referenceList) referenceItem(item),
              ],
            )
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Container sectionHeader(String text) {
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      margin: const pw.EdgeInsets.only(top: 10, bottom: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          decoration: pw.TextDecoration.underline,
        ),
      ),
    );
  }

  pw.Container educationItem(Map<String, dynamic> education) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                education['degree'] + ', ' + education['school_name'],
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              education['start_date'] != null && education['end_date'] == null
                  ? pw.Text(
                      '${Helper().formatMonthYear(education['start_date'])} - Present',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    )
                  : education['start_date'] == null &&
                          education['end_date'] != null
                      ? pw.Text(
                          Helper().formatMonthYear(education['end_date']),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        )
                      : pw.SizedBox(),
            ],
          ),
          pw.Text('Department: ${education['department']}'),
          pw.Text(
              'CGPA: ${education['grade']} out of ${education['grade_scale']}'),
          pw.Text(
            education['description'] ?? '',
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  pw.Container experienceItem(Map<String, dynamic> experience) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                experience['position'] + ', ' + experience['company_name'],
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                experience['end_date'] == null
                    ? '${Helper().formatMonthYear(experience['start_date'])} - Present'
                    : '${Helper().formatMonthYear(experience['start_date'])} - ${Helper().formatMonthYear(experience['end_date'])}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 20),
            child: pw.Text(
              experience['description'] ?? '',
              textAlign: pw.TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  pw.Container skillItem(Map<String, dynamic> skill) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            skill['proficiency'] != null && skill['proficiency'] != ''
                ? skill['skill'] + ' (${skill['proficiency']})'
                : skill['skill'],
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            skill['description'] ?? '',
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  pw.Container languageItem(Map<String, dynamic> language) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(language['language'] + ' (${language['proficiency']})'),
          // pw.Text(
          //   language['description'] ?? '',
          //   textAlign: pw.TextAlign.justify,
          // ),
        ],
      ),
    );
  }

  pw.Container referenceItem(Map<String, dynamic> reference) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            reference['name'],
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(reference['position']),
          pw.Text(reference['company_name']),
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(
                  text: 'Email: ',
                  style: const pw.TextStyle(color: PdfColors.black),
                  children: [
                    pw.TextSpan(
                      text: reference['email'],
                      style: const pw.TextStyle(color: PdfColors.blue),
                      annotation: pw.AnnotationUrl(
                        'mailto:${reference['email']}',
                        // width: 50,
                        // height: 50,
                      ),
                    ),
                  ],
                ),
                const pw.TextSpan(text: '.'),
              ],
            ),
          ),
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(
                  text: 'Phone: ',
                  style: const pw.TextStyle(color: PdfColors.black),
                  children: [
                    pw.TextSpan(
                      text: reference['phone'],
                      style: const pw.TextStyle(color: PdfColors.blue),
                      annotation: pw.AnnotationUrl(
                        'tel:${reference['phone']}',
                        // width: 50,
                        // height: 50,
                      ),
                    ),
                  ],
                ),
                const pw.TextSpan(text: '.'),
              ],
            ),
          ),
          // pw.Text('Email: mailto:${reference['email']}'),
          // pw.Text('Phone: tel:${reference['phone']}'),
          pw.Text(
            reference['description'] ?? '',
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
