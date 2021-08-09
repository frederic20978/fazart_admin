import 'package:flutter/material.dart';

class ServiceQuestions extends StatefulWidget {
  @override
  _ServiceQuestionsState createState() => _ServiceQuestionsState();
}

class _ServiceQuestionsState extends State<ServiceQuestions> {
  final _formkey = GlobalKey<FormState>();
  String question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question for customer'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Container(
                height: 80,
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? "Enter a valid Description" : null,
                  onChanged: (value) {
                    setState(() {
                      question = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "Description",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .5,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
