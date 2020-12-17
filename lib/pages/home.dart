import 'package:cv_builder/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyView(),
      // floatingActionButton: FloatingActionButton(
      //   child: IconButton(
      //     icon: Icon(
      //       Feather.plus,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       showAbout();
      //     },
      //   ),
      // ),
    );
  }

  showAbout() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'New Resume',
          ),
          content: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
//              enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.blue),
//            ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
//              border: UnderlineInputBorder(
//                borderSide: BorderSide(color: Colors.blue),
//              ),
              hintText: "Enter a name",
            ),
            keyboardType: TextInputType.text,
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).accentColor,
              // onPressed: () => Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddNewResume(),
              //   ),
              // ),
              child: Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );
  }
}
