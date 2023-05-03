import 'package:flutter/material.dart';

class AddReference extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text("Add Reference"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 3),
              content: Text('Data Updated')));
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            Heading(title: "Add Education"),
//            Divider(),
            SizedBox(height: 10.0),
            // CustomTextField(
            //   labelText: "Full Name",
            //   hintText: "",
            //   iconText: Icon(Icons.person_outline),
            //   ratio: 1.0,
            // ),
            // SizedBox(height: 10.0),
            // CustomTextField(
            //   labelText: "Work Place",
            //   hintText: "",
            //   iconText: Icon(Icons.person_outline),
            //   ratio: 1.0,
            // ),
            // SizedBox(height: 10.0),
            // CustomTextField(
            //   labelText: "Designation",
            //   hintText: "",
            //   iconText: Icon(Icons.person_outline),
            //   ratio: 1.0,
            // ),
            // SizedBox(height: 10.0),
            // CustomTextField(
            //   labelText: "E-Mail",
            //   hintText: "",
            //   iconText: Icon(Icons.person_outline),
            //   ratio: 1.0,
            // ),
            // SizedBox(height: 10.0),
            // CustomTextField(
            //   labelText: "Phone Number",
            //   hintText: "",
            //   iconText: Icon(Icons.person_outline),
            //   ratio: 1.0,
            // ),
            // SizedBox(height: 10.0),
            // Button(btnText: "Save Changes"),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
