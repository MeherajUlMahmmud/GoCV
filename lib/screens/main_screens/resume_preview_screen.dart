import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocv/models/award.dart';
import 'package:gocv/models/certificate.dart';
import 'package:gocv/models/contact.dart';
import 'package:gocv/models/education.dart';
import 'package:gocv/models/experience.dart';
import 'package:gocv/models/interest.dart';
import 'package:gocv/models/language.dart';
import 'package:gocv/models/personal.dart';
import 'package:gocv/models/reference.dart';
import 'package:gocv/models/resume_preview.dart';
import 'package:gocv/models/skill.dart';
import 'package:gocv/models/user.dart';
import 'package:gocv/providers/current_resume_provider.dart';
import 'package:gocv/repositories/resume.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResumePreviewScreen extends StatefulWidget {
  static const String routeName = Constants.resumePreviewScreenRouteName;

  const ResumePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  ResumeRepository resumeRepository = ResumeRepository();

  late CurrentResumeProvider currentResumeProvider;
  late String resumeId;

  ResumePreview resume = ResumePreview(
    id: 0,
    name: '',
    user: UserBase(),
    personal: Personal(),
    contact: Contact(id: 0, resume: 0, email: ''),
    education: [],
    experience: [],
    skill: [],
    language: [],
    interest: [],
    reference: [],
    award: [],
    certification: [],
  );

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  Map<String, PdfPageFormat> pageFormats = {
    'A4': PdfPageFormat.a4,
    'A5': PdfPageFormat.a5,
    'Letter': PdfPageFormat.letter,
    'Legal': PdfPageFormat.legal,
  };

  late String imageUri;
  dynamic netImage;

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

    fetchResumePreview();
  }

  loadImage() async {
    image = await rootBundle.load(Constants.defaultAvatarPath);
    imageData = (image).buffer.asUint8List();
  }

  fetchResumePreview() async {
    try {
      final response = await resumeRepository.getResumePreview(resumeId);

      if (response['status'] == Constants.httpOkCode) {
        final ResumePreview fetchedResume = ResumePreview.fromJson(
          response['data'],
        );

        imageUri = fetchedResume.personal.resumePicture ?? '';
        if (imageUri != '') {
          try {
            final loadedImage = await networkImage(imageUri);
            setState(() {
              netImage = loadedImage;
            });
          } catch (error) {
            print('Error loading image: $error');
            if (!mounted) return;
            Helper().showSnackBar(
              context,
              'Error loading image: $error',
              Colors.red,
            );
          }
        } else {
          loadImage();
        }

        setState(() {
          resume = fetchedResume;
          isLoading = false;
          isError = false;
          errorText = '';
        });
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
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

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
                '${resume.personal.firstName} ${resume.personal.lastName}',
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
            // pw.Wrap(
            //   children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                personalAndContactInfo(resume),

                // sectionHeader('OBJECTIVE'),
                // pw.Container(
                //   alignment: pw.Alignment.centerLeft,
                //   child: pw.Text(
                //     personal.aboutMe ?? '',
                //     textAlign: pw.TextAlign.justify,
                //   ),
                // ),

                resume.experience.isNotEmpty
                    ? sectionHeader('EXPERIENCE')
                    : pw.SizedBox(),
                for (var experience in resume.experience)
                  experienceItem(experience),

                resume.education.isNotEmpty
                    ? sectionHeader('EDUCATION')
                    : pw.SizedBox(),
                for (var education in resume.education)
                  educationItem(education),

                resume.skill.isNotEmpty
                    ? sectionHeader('SKILLS')
                    : pw.SizedBox(),
                skillListView(resume.skill),

                // skillListGrid(skillList),

                resume.award.isNotEmpty
                    ? sectionHeader('AWARDS')
                    : pw.SizedBox(),
                for (var award in resume.award) awardItem(award),

                resume.certification.isNotEmpty
                    ? sectionHeader('CERTIFICATIONS')
                    : pw.SizedBox(),
                for (var certification in resume.certification)
                  certificationItem(certification),

                resume.interest.isNotEmpty
                    ? sectionHeader('INTERESTS')
                    : pw.SizedBox(),
                for (var interest in resume.interest) interestItem(interest),

                resume.language.isNotEmpty
                    ? sectionHeader('LANGUAGES')
                    : pw.SizedBox(),
                for (var language in resume.language) languageItem(language),

                resume.reference.isNotEmpty
                    ? sectionHeader('REFERENCES')
                    : pw.SizedBox(),
                for (var reference in resume.reference)
                  referenceItem(reference),
              ],
            )
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Container personalAndContactInfo(ResumePreview resume) {
    return pw.Container(
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
                  '${resume.personal.firstName} ${resume.personal.lastName}',
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
                  resume.contact.address ?? '',
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
                          resume.contact.phoneNumber ?? '',
                        ),
                      ),
                      // Put this inside hyperlink
                      // 'https: //www.linkedin.com/in/${contact.linkedin}'
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          resume.contact.linkedin != null ||
                                  resume.contact.linkedin != ''
                              ? 'LinkedIn'
                              : '',
                          style: resume.contact.linkedin != null ||
                                  resume.contact.linkedin != ''
                              ? const pw.TextStyle(
                                  decoration: pw.TextDecoration.underline,
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
                        child: pw.Text(
                          resume.contact.email,
                          style: const pw.TextStyle(
                            decoration: pw.TextDecoration.underline,
                            color: PdfColors.blue900,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          resume.contact.github != null ||
                                  resume.contact.github != ''
                              ? 'GitHub'
                              : '',
                          style: resume.contact.github != null ||
                                  resume.contact.github != ''
                              ? const pw.TextStyle(
                                  decoration: pw.TextDecoration.underline,
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
            netImage ?? pw.MemoryImage(imageData),
            height: 70,
            width: 70,
          ),
        ],
      ),
    );
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

  pw.Container skillListView(List<Skill> skillList) {
    return pw.Container(
      child: pw.Wrap(
        spacing: 30, // Adjust the spacing between columns as needed
        runSpacing: 15, // Adjust the spacing between rows as needed
        crossAxisAlignment: pw.WrapCrossAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var skill in skillList)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 2),
                  child: pw.Text(
                    skill.name,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var skill in skillList)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 2),
                  child: pw.Text(
                    skill.description ?? '',
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Container skillListGrid(List<Skill> skillList) {
    // Calculate the number of rows needed based on the number of skills and 4 items per row
    int numRows = (skillList.length / 6).ceil();

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      height: numRows * 50.0, // Set a fixed height for the grid
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionHeader('SKILLS'),
          pw.Wrap(
            spacing: 3, // Adjust the spacing between items as needed
            runSpacing: 2,
            children: List.generate(numRows, (rowIndex) {
              // Generate widgets for each row
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: List.generate(4, (columnIndex) {
                  // Calculate the index of the skill in the flat list
                  int index = rowIndex * 4 + columnIndex;
                  if (index < skillList.length) {
                    return skillGridItem(skillList[index]);
                  } else {
                    // Return an empty container if there are no more skills to display
                    return pw.Container();
                  }
                }),
              );
            }),
          ),
        ],
      ),
    );
  }

  pw.Container skillGridItem(Skill skill) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(3),
      child: pw.Row(
        children: [
          pw.Text(
            skill.name,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(width: 5),
          pw.Text(
            skill.proficiency != null && skill.proficiency != ''
                ? skill.proficiency == 'Beginner'
                    ? '(⭐)'
                    : skill.proficiency == 'Intermediate'
                        ? '(⭐ ⭐)'
                        : skill.proficiency == 'Advanced'
                            ? '(⭐ ⭐ ⭐)'
                            : skill.proficiency == 'Expert'
                                ? '(⭐ ⭐ ⭐ ⭐)'
                                : '' // if proficiency is not set, do not show any stars
                : '',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Container awardItem(Award award) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            award.title ?? '',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            award.description ?? '',
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  pw.Container certificationItem(Certificate certification) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            certification.title ?? '',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            certification.description ?? '',
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  pw.Container interestItem(Interest interest) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            interest.name,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            interest.description ?? '',
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  pw.Container languageItem(Language language) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('${language.name} (${language.proficiency})'),
        ],
      ),
    );
  }

  pw.Container referenceItem(Reference reference) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            reference.name,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(reference.position ?? ''),
          pw.Text(reference.companyName ?? ''),
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(
                  text: 'Email: ',
                  style: const pw.TextStyle(color: PdfColors.black),
                  children: [
                    pw.TextSpan(
                      text: reference.email,
                      style: const pw.TextStyle(color: PdfColors.blue),
                      annotation: pw.AnnotationUrl(
                        'mailto:${reference.email}',
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
                      text: reference.phone ?? '',
                      style: const pw.TextStyle(color: PdfColors.blue),
                      annotation: pw.AnnotationUrl(
                        'tel:${reference.phone}',
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
            reference.description ?? '',
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
