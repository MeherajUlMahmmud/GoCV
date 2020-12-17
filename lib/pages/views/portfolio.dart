import 'package:cv_builder/models/person.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatefulWidget {
  final int type;
  final Person person;

  Portfolio({this.type, this.person});

  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
