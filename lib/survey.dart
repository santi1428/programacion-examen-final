import 'dart:convert';

import 'package:flutter/material.dart';
import 'models/token.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'models/survey_data.dart';
import 'package:http/http.dart' as http;

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

  int qualification = 0;

  Future<void> saveData() async {
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

    print(response.statusCode);
    print(response.body);
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
              child:
                  // !loadingData  ?
                  Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Email',
                      hintText: 'Ingresa tu email',
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
                      labelText: 'Lo que mas te gustó del curso',
                      hintText: 'Ingresa lo que mas te gustó del curso',
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
                      labelText: 'Lo que menos te gustó del curso',
                      hintText: 'Ingresa lo que menos te gustó del curso',
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
                    icon: const FaIcon(
                      FontAwesomeIcons.shareSquare,
                      size: 20,
                    ),
                    label: const Text('Enviar'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(350, 40)),
                  )
                ],
              )
              // : Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: const <Widget>[
              //       SizedBox(
              //         height: 270,
              //       ),
              //       SizedBox(
              //         child: CircularProgressIndicator(),
              //       )
              //     ],
              //   ),
              ),
        ),
      ),
    );
  }
}
