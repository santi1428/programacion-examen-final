import 'dart:convert';

import 'package:flutter/material.dart';
import 'models/token.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'models/survey_data.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum SaveDataButtonState { init, loading }

class Survey extends StatefulWidget {
  final Token token;
  final SurveyData surveyData;
  const Survey({Key? key, required this.token, required this.surveyData})
      : super(key: key);

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  var emailController = TextEditingController();

  var theBestController = TextEditingController();

  var theWorstController = TextEditingController();

  var remarksController = TextEditingController();

  String invalidEmailErrorMessage = '';

  String invalidTheBestErrorMessage = '';

  String invalidTheWorstErrorMessage = '';

  String invalidRemarksErrorMessage = '';

  int qualification = 0;

  SaveDataButtonState saveDataButtonState = SaveDataButtonState.init;

  Future<void> saveData() async {
    if (!validateFields()) return;
    setState(() {
      saveDataButtonState = SaveDataButtonState.loading;
    });
    Map<String, dynamic> data = {
      'email': emailController.text,
      'theBest': theBestController.text,
      'theWorst': theWorstController.text,
      'remarks': remarksController.text,
      'qualification': qualification
    };

    var url = Uri.parse('https://vehicleszulu.azurewebsites.net/api/Finals');
    var response = await http.post(url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer ${widget.token.token}'
        },
        body: jsonEncode(data));

    Fluttertoast.showToast(
        msg: "Datos guardados",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    setState(() {
      saveDataButtonState = SaveDataButtonState.init;
    });
  }

  bool validateFields() {
    final String email = emailController.text.trim();
    final String theBest = theBestController.text.trim();
    final bool invalidEmail = !EmailValidator.validate(email);
    final String theWorst = theWorstController.text.trim();
    final String remarks = remarksController.text.trim();

    setState(() {
      invalidEmailErrorMessage =
          invalidEmail ? 'You must enter a valid email' : '';
      invalidEmailErrorMessage = email.contains('correo.itm.edu.co')
          ? invalidEmailErrorMessage
          : 'Debes de ingresar un correo con el dominio del ITM';
      invalidRemarksErrorMessage =
          remarks.isEmpty ? 'Debes de ingresar los comentarios generales' : '';
      invalidTheBestErrorMessage = theBest.isEmpty
          ? 'Debes de ingresar lo que mas te gusto del curso'
          : '';
      invalidTheWorstErrorMessage = theWorst.isEmpty
          ? 'Debes de ingresar lo que menos te gusto del curso'
          : '';
    });

    if (invalidEmailErrorMessage.isEmpty &&
        invalidRemarksErrorMessage.isEmpty &&
        invalidTheBestErrorMessage.isEmpty &&
        invalidTheWorstErrorMessage.isEmpty) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    emailController.text = widget.surveyData.email ?? '';
    theBestController.text = widget.surveyData.theBest ?? '';
    theWorstController.text = widget.surveyData.theWorst ?? '';
    remarksController.text = widget.surveyData.remarks ?? '';
    qualification = widget.surveyData.qualification ?? 0;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuesta'),
        backgroundColor: const Color(0xff212529),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Email',
                      hintText: 'Ingresa tu email',
                      labelStyle: const TextStyle(fontSize: 19),
                      errorText: invalidEmailErrorMessage.isNotEmpty
                          ? invalidEmailErrorMessage
                          : null,
                      // errorText: invalidEmailErrorMessage.isNotEmpty
                      //     ? invalidEmailErrorMessage
                      //     : null,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // prefixIcon: Icon(
                      //   Icons.alternate_email,
                      //   color: invalidEmailErrorMessage.isNotEmpty
                      //       ? AppColors.error
                      //       : Colors.blue.shade400,
                      // ),
                    ),
                    controller: emailController,

                    // controller: emailController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Lo que mas te gust?? del curso',
                      hintText: 'Ingresa lo que mas te gust?? del curso',
                      labelStyle: const TextStyle(fontSize: 19),
                      // errorText: invalidEmailErrorMessage.isNotEmpty
                      //     ? invalidEmailErrorMessage
                      //     : null,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // prefixIcon: Icon(
                      //   Icons.alternate_email,
                      //   color: invalidEmailErrorMessage.isNotEmpty
                      //       ? AppColors.error
                      //       : Colors.blue.shade400,
                      // ),
                      errorText: invalidTheBestErrorMessage.isNotEmpty
                          ? invalidTheBestErrorMessage
                          : null,
                    ),
                    controller: theBestController,
                    maxLines: 2,

                    // controller: emailController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Lo que menos te gust?? del curso',
                      hintText: 'Ingresa lo que menos te gust?? del curso',
                      labelStyle: const TextStyle(fontSize: 19),
                      // errorText: invalidEmailErrorMessage.isNotEmpty
                      //     ? invalidEmailErrorMessage
                      //     : null,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // prefixIcon: Icon(
                      //   Icons.alternate_email,
                      //   color: invalidEmailErrorMessage.isNotEmpty
                      //       ? AppColors.error
                      //       : Colors.blue.shade400,
                      // ),
                      errorText: invalidTheWorstErrorMessage.isNotEmpty
                          ? invalidTheWorstErrorMessage
                          : null,
                    ),
                    maxLines: 2,
                    controller: theWorstController,

                    // controller: emailController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Comentarios generales',
                      hintText: 'Ingresa los comentarios generales',
                      labelStyle: const TextStyle(fontSize: 19),
                      // errorText: invalidEmailErrorMessage.isNotEmpty
                      //     ? invalidEmailErrorMessage
                      //     : null,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // prefixIcon: Icon(
                      //   Icons.alternate_email,
                      //   color: invalidEmailErrorMessage.isNotEmpty
                      //       ? AppColors.error
                      //       : Colors.blue.shade400,
                      // ),
                      errorText: invalidRemarksErrorMessage.isNotEmpty
                          ? invalidRemarksErrorMessage
                          : null,
                    ),
                    maxLines: 2,
                    controller: remarksController,

                    // controller: emailController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                      'Selecciona la calificacion del curso (entre 1 a 5 estrellas)'),
                  const SizedBox(
                    height: 15,
                  ),
                  RatingBar.builder(
                    initialRating: qualification.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      qualification = rating.toInt();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      saveData();
                    },
                    icon: saveDataButtonState == SaveDataButtonState.init
                        ? const FaIcon(
                            FontAwesomeIcons.shareSquare,
                            size: 20,
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                    label: saveDataButtonState == SaveDataButtonState.init
                        ? const Text('Enviar')
                        : const Text('Enviando'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(350, 40)),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
