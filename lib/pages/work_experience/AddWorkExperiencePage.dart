import 'package:cv_builder/utils/local_storage.dart';
import 'package:cv_builder/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddWorkExperiencePage extends StatefulWidget {
  final String resumeId;
  const AddWorkExperiencePage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<AddWorkExperiencePage> createState() => _AddWorkExperiencePageState();
}

class _AddWorkExperiencePageState extends State<AddWorkExperiencePage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  late Map<String, dynamic> contactDetails = {};

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int id = 0;
  String companyName = "";
  String position = "";
  String type = "";
  String startDate = "";
  String endDate = "";
  String description = "";
  bool isCurrentlyWorking = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Work Experience'),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                width: width,
                controller: companyNameController,
                labelText: "Company Name",
                hintText: "Company Name",
                prefixIcon: Icons.phone,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    companyName = value;
                  });
                },
              ),
              CustomTextFormField(
                width: width,
                controller: positionController,
                labelText: "Position",
                hintText: "Position",
                prefixIcon: Icons.phone,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    position = value;
                  });
                },
              ),
              CustomTextFormField(
                width: width,
                controller: typeController,
                labelText: "Type",
                hintText: "Type",
                prefixIcon: Icons.phone,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: width,
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990, 1),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != DateTime.now()) {
                      setState(() {
                        startDate = picked.toString().substring(0, 10);
                        startDateController.text = startDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: "Start Date",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: width,
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990, 1),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != DateTime.now()) {
                      setState(() {
                        endDate = picked.toString().substring(0, 10);
                        endDateController.text = endDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: endDateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: "End Date",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              CustomTextFormField(
                width: width,
                controller: descriptionController,
                labelText: "Description",
                hintText: "Description",
                prefixIcon: Icons.phone,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
