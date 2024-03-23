import 'package:flutter/material.dart';
import 'package:gocv/models/contact.dart';

class ContactDataProvider extends ChangeNotifier {
  final Contact _contactData = Contact(
    id: 0,
    email: '',
  );

  Contact get contactData => _contactData;

  void setContactData(Contact contactData) {
    _contactData.id = contactData.id;
    _contactData.resume = contactData.resume;
    _contactData.phoneNumber = contactData.phoneNumber;
    _contactData.email = contactData.email;
    _contactData.address = contactData.address;
    _contactData.zipCode = contactData.zipCode;
    _contactData.facebook = contactData.facebook;
    _contactData.linkedin = contactData.linkedin;
    _contactData.github = contactData.github;
    _contactData.website = contactData.website;
    notifyListeners();
  }
}
