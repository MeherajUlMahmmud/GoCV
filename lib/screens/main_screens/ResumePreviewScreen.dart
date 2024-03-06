import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocv/models/award.dart';
import 'package:gocv/models/certificate.dart';
import 'package:gocv/models/contact.dart';
import 'package:gocv/models/education.dart';
import 'package:gocv/models/experience.dart';
import 'package:gocv/models/language.dart';
import 'package:gocv/models/personal.dart';
import 'package:gocv/models/reference.dart';
import 'package:gocv/models/resume.dart';
import 'package:gocv/models/skill.dart';
import 'package:gocv/providers/CurrentResumeProvider.dart';
import 'package:gocv/repositories/contact.dart';
import 'package:gocv/repositories/education.dart';
import 'package:gocv/repositories/experience.dart';
import 'package:gocv/repositories/personal.dart';
import 'package:gocv/repositories/resume.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResumePreviewScreen extends StatefulWidget {
  static const String routeName = '/resume-preview';

  const ResumePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  ResumeRepository resumeRepository = ResumeRepository();
  PersonalRepository personalRepository = PersonalRepository();
  ContactRepository contactRepository = ContactRepository();
  EducationRepository educationRepository = EducationRepository();
  ExperienceRepository experienceRepository = ExperienceRepository();

  late CurrentResumeProvider currentResumeProvider;
  late String resumeId;

  Resume resume = Resume(name: '');
  Personal personal = Personal();
  Contact contact = Contact(
    id: 0,
    email: '',
  );
  List<Education> educationList = [];
  List<Experience> experienceList = [];
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
    'A5': PdfPageFormat.a5,
    'Letter': PdfPageFormat.letter,
    'Legal': PdfPageFormat.legal,
  };

  late ByteData image;
  late Uint8List imageData;

  @override
  void initState() {
    super.initState();

    currentResumeProvider = Provider.of<CurrentResumeProvider>(
      context,
      listen: false,
    );

    setState(() {
      resumeId = currentResumeProvider.currentResume.id.toString();
    });

    loadImage();
    fetchResumeDetails();
  }

  loadImage() async {
    image = await rootBundle.load('assets/avatars/rdj.png');
    imageData = (image).buffer.asUint8List();
  }

  fetchResumeDetails() async {
    try {
      final response = await resumeRepository.getResumeDetails(resumeId);

      if (response['status'] == Constants.httpOkCode) {
        final Resume fetchedResume = Resume.fromJson(response['data']['data']);
        currentResumeProvider.setCurrentResume(fetchedResume);

        setState(() {
          resume = fetchedResume;
        });

        fetchPersonalDetails();
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.genericErrorMsg,
            Colors.red,
          );
        }
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching resume details: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        'Error fetching resume details',
        Colors.red,
      );
    }
  }

  fetchPersonalDetails() async {
    try {
      final response = await personalRepository.getPersonalDetails(resumeId);

      if (response['status'] == Constants.httpOkCode) {
        Personal fetchedPersonalDetails = Personal.fromJson(response['data']);

        setState(() {
          personal = fetchedPersonalDetails;
        });

        fetchContactDetails();
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['error'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            'Failed to fetch personal data',
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching personal details: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        'Error fetching personal details',
        Colors.red,
      );
    }
  }

  fetchContactDetails() async {
    try {
      final response = await contactRepository.getContactDetails(resumeId);
      print(response);

      if (response['status'] == Constants.httpOkCode) {
        Contact fetchedContact = Contact.fromJson(response['data']);

        setState(() {
          contact = fetchedContact;
        });

        fetchEducations();
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.genericErrorMsg,
            Colors.red,
          );
        }
      }
    } catch (error) {
      print('Error fetching contact details: $error');
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching contact details';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  fetchEducations() async {
    try {
      final response = await educationRepository.getEducations(resumeId);

      if (response['status'] == Constants.httpOkCode) {
        final List<Education> fetchedEducationList =
            (response['data']['data'] as List).map<Education>((education) {
          return Education.fromJson(education);
        }).toList();
        setState(() {
          educationList = fetchedEducationList;
        });

        fetchWorkExperiences();
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.genericErrorMsg,
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching education list: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        'Error fetching education listr',
        Colors.red,
      );
    }
  }

  fetchWorkExperiences() async {
    try {
      final response = await experienceRepository.getExperiences(resumeId);

      if (response['status'] == Constants.httpOkCode) {
        final List<Experience> fetchedExperiences = (response['data']['data']
                as List)
            .map<Experience>((experience) => Experience.fromJson(experience))
            .toList();
        setState(() {
          experienceList = fetchedExperiences;
          isLoading = false;
          isError = false;
          errorText = '';
        });

        // fetchSkills();
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['error'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            'Failed to fetch work experiences',
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching work experiences: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        'Failed to fetch work experiences',
        Colors.red,
      );
    }
  }

  // fetchSkills() {
  //   final String url = '${URLS.kSkillUrl}$resumeId/list/';

  //   APIService().sendGetRequest(accessToken, url).then((data) async {
  //     if (data['status'] == Constants.HTTP_OK) {
  //       setState(() {
  //         skillList = data['data'];
  //       });

  //       fetchInterests();
  //     } else {
  //       if (Helper().isUnauthorizedAccess(data['status'])) {
  //         Helper().showSnackBar(
  //           context,
  //           Constants.SESSION_EXPIRED_MSG,
  //           Colors.red,
  //         );
  //         Helper().logoutUser(context);
  //       } else {
  //         print(data['error']);
  //         setState(() {
  //           isLoading = false;
  //           isError = true;
  //           errorText = data['error'];
  //         });
  //         Helper().showSnackBar(
  //           context,
  //           'Failed to fetch skills',
  //           Colors.red,
  //         );
  //       }
  //     }
  //   });
  // }

  // fetchInterests() {
  //   final String url = '${URLS.kInterestUrl}$resumeId/list/';

  //   APIService().sendGetRequest(accessToken, url).then((data) async {
  //     if (data['status'] == Constants.HTTP_OK) {
  //       setState(() {
  //         interestList = data['data'];
  //       });

  //       fetchLanguages();
  //     } else {
  //       if (Helper().isUnauthorizedAccess(data['status'])) {
  //         Helper().showSnackBar(
  //           context,
  //           Constants.SESSION_EXPIRED_MSG,
  //           Colors.red,
  //         );
  //         Helper().logoutUser(context);
  //       } else {
  //         print(data['error']);
  //         setState(() {
  //           isLoading = false;
  //           isError = true;
  //           errorText = data['error'];
  //         });
  //         Helper().showSnackBar(
  //           context,
  //           'Failed to fetch interests',
  //           Colors.red,
  //         );
  //       }
  //     }
  //   });
  // }

  // fetchLanguages() {
  //   final String url = '${URLS.kLanguageUrl}$resumeId/list/';

  //   APIService().sendGetRequest(accessToken, url).then((data) async {
  //     if (data['status'] == Constants.HTTP_OK) {
  //       setState(() {
  //         languageList = data['data'];
  //       });

  //       fetchReferences();
  //     } else {
  //       if (Helper().isUnauthorizedAccess(data['status'])) {
  //         Helper().showSnackBar(
  //           context,
  //           Constants.SESSION_EXPIRED_MSG,
  //           Colors.red,
  //         );
  //         Helper().logoutUser(context);
  //       } else {
  //         print(data['error']);
  //         setState(() {
  //           isLoading = false;
  //           isError = true;
  //           errorText = data['error'];
  //         });
  //         Helper().showSnackBar(
  //           context,
  //           'Failed to fetch languages',
  //           Colors.red,
  //         );
  //       }
  //     }
  //   });
  // }

  // fetchReferences() {
  //   final String url = '${URLS.kReferenceUrl}$resumeId/list/';

  //   APIService().sendGetRequest(accessToken, url).then((data) async {
  //     print(data);
  //     if (data['status'] == Constants.HTTP_OK) {
  //       setState(() {
  //         referenceList = data['data'];
  //         isLoading = false;
  //         isError = false;
  //         errorText = '';
  //       });
  //     } else {
  //       if (Helper().isUnauthorizedAccess(data['status'])) {
  //         Helper().showSnackBar(
  //           context,
  //           Constants.SESSION_EXPIRED_MSG,
  //           Colors.red,
  //         );
  //         Helper().logoutUser(context);
  //       } else {
  //         print(data['error']);
  //         setState(() {
  //           isLoading = false;
  //           isError = true;
  //           errorText = data['error'];
  //         });
  //         Helper().showSnackBar(
  //           context,
  //           'Failed to fetch references',
  //           Colors.red,
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        centerTitle: true,
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
              pdfFileName: '${resume.name}.pdf',
              build: (format) => _generatePdf(
                format,
                resume.name,
                width,
              ),
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
                '${personal.firstName} ${personal.lastName}',
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
                pw.Container(
                  color: PdfColors.grey300,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              '${personal.firstName} ${personal.lastName}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              contact.address ?? '',
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Row(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      contact.phoneNumber ?? '',
                                    ),
                                  ),
                                  // Put this inside hyperlink
                                  // 'https: //www.linkedin.com/in/${contact.linkedin}'
                                  pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      contact.linkedin != null ||
                                              contact.linkedin != ''
                                          ? 'LinkedIn'
                                          : '',
                                      style: contact.linkedin != null ||
                                              contact.linkedin != ''
                                          ? const pw.TextStyle(
                                              decoration:
                                                  pw.TextDecoration.underline,
                                              color: PdfColors.blue900,
                                            )
                                          : const pw.TextStyle(
                                              color: PdfColors.black,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(width: 30),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(contact.email,
                                        style: const pw.TextStyle(
                                          decoration:
                                              pw.TextDecoration.underline,
                                          color: PdfColors.blue900,
                                        )),
                                  ),
                                  pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      contact.github != null ||
                                              contact.github != ''
                                          ? 'GitHub'
                                          : '',
                                      style: contact.github != null ||
                                              contact.github != ''
                                          ? const pw.TextStyle(
                                              decoration:
                                                  pw.TextDecoration.underline,
                                              color: PdfColors.blue900,
                                            )
                                          : const pw.TextStyle(
                                              color: PdfColors.black,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(width: 30),
                            ],
                          ),
                        ],
                      ),
                      pw.Image(
                        pw.MemoryImage(imageData),
                        height: 70,
                        width: 70,
                      ),
                    ],
                  ),
                ),
                sectionHeader('OBJECTIVE'),
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(
                    personal.aboutMe ?? '',
                    textAlign: pw.TextAlign.justify,
                  ),
                ),

                educationList.isNotEmpty
                    ? sectionHeader('EDUCATION')
                    : pw.SizedBox(),
                for (var education in educationList) educationItem(education),

                experienceList.isNotEmpty
                    ? sectionHeader('EXPERIENCE')
                    : pw.SizedBox(),
                for (var experience in experienceList)
                  experienceItem(experience),

                skillList.isNotEmpty ? sectionHeader('SKILLS') : pw.SizedBox(),
                // for (var item in skillList) skillItem(item),

                awardList.isNotEmpty ? sectionHeader('AWARDS') : pw.SizedBox(),
                // for (var item in awardList) skillItem(item),

                certificationList.isNotEmpty
                    ? sectionHeader('CERTIFICATIONS')
                    : pw.SizedBox(),
                // for (var item in certificationList) skillItem(item),

                interestList.isNotEmpty
                    ? sectionHeader('INTERESTS')
                    : pw.SizedBox(),
                // for (var item in interestList) interestItem(item),

                languageList.isNotEmpty
                    ? sectionHeader('LANGUAGES')
                    : pw.SizedBox(),
                // for (var item in languageList) languageItem(item),
                referenceList.isNotEmpty
                    ? sectionHeader('REFERENCES')
                    : pw.SizedBox(),
                // for (var item in referenceList) referenceItem(item),
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
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      color: PdfColors.grey200,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          // decoration: pw.TextDecoration.underline,
        ),
      ),
    );
  }

  pw.Container educationItem(Education education) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${education.degree}, ${education.schoolName}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                education.endDate == null
                    ? '${Helper().formatMonthYear(education.startDate)} - Present'
                    : '${Helper().formatMonthYear(education.startDate)} - ${Helper().formatMonthYear(education.endDate ?? '')}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Department: ${education.department}'),
                pw.Text(
                    'CGPA: ${education.grade} out of ${education.gradeScale}'),
                pw.Text(
                  education.description ?? '',
                  textAlign: pw.TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Container experienceItem(Experience experience) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${experience.position}, ${experience.companyName}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                experience.endDate == null
                    ? '${Helper().formatMonthYear(experience.startDate)} - Present'
                    : '${Helper().formatMonthYear(experience.startDate)} - ${Helper().formatMonthYear(experience.endDate ?? '')}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 20),
            child: pw.Text(
              experience.description ?? '',
              textAlign: pw.TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  // pw.Container skillItem(Map<String, dynamic> skill) {
  //   return pw.Container(
  //     margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
  //     child: pw.Column(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Text(
  //           skill['proficiency'] != null && skill['proficiency'] != ''
  //               ? skill['skill'] + ' (${skill['proficiency']})'
  //               : skill['skill'],
  //           style: pw.TextStyle(
  //             fontWeight: pw.FontWeight.bold,
  //           ),
  //         ),
  //         pw.Text(
  //           skill['description'] == null || skill['description'] == ''
  //               ? ''
  //               : skill['description'],
  //           textAlign: pw.TextAlign.justify,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // pw.Container interestItem(Map<String, dynamic> interest) {
  //   return pw.Container(
  //     margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
  //     child: pw.Column(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Text(
  //           interest['interest'],
  //           style: pw.TextStyle(
  //             fontWeight: pw.FontWeight.bold,
  //           ),
  //         ),
  //         pw.Text(
  //           interest['description'] == null || interest['description'] == ''
  //               ? ''
  //               : interest['description'],
  //           textAlign: pw.TextAlign.justify,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  pw.Container languageItem(Map<String, dynamic> language) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(language['language'] + ' (${language['proficiency']})'),
        ],
      ),
    );
  }

  // pw.Container referenceItem(Map<String, dynamic> reference) {
  //   return pw.Container(
  //     margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
  //     child: pw.Column(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Text(
  //           reference['name'],
  //           style: pw.TextStyle(
  //             fontWeight: pw.FontWeight.bold,
  //           ),
  //         ),
  //         pw.Text(reference['position']),
  //         pw.Text(reference['company_name']),
  //         pw.RichText(
  //           text: pw.TextSpan(
  //             children: [
  //               pw.TextSpan(
  //                 text: 'Email: ',
  //                 style: const pw.TextStyle(color: PdfColors.black),
  //                 children: [
  //                   pw.TextSpan(
  //                     text: reference['email'],
  //                     style: const pw.TextStyle(color: PdfColors.blue),
  //                     annotation: pw.AnnotationUrl(
  //                       'mailto:${reference['email']}',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const pw.TextSpan(text: '.'),
  //             ],
  //           ),
  //         ),
  //         pw.RichText(
  //           text: pw.TextSpan(
  //             children: [
  //               pw.TextSpan(
  //                 text: 'Phone: ',
  //                 style: const pw.TextStyle(color: PdfColors.black),
  //                 children: [
  //                   pw.TextSpan(
  //                     text: reference['phone'],
  //                     style: const pw.TextStyle(color: PdfColors.blue),
  //                     annotation: pw.AnnotationUrl(
  //                       'tel:${reference['phone']}',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const pw.TextSpan(text: '.'),
  //             ],
  //           ),
  //         ),
  //         // pw.Text('Email: mailto:${reference['email']}'),
  //         // pw.Text('Phone: tel:${reference['phone']}'),
  //         pw.Text(
  //           reference['description'] == null || reference['description'] == ''
  //               ? ''
  //               : reference['description'],
  //           textAlign: pw.TextAlign.justify,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
