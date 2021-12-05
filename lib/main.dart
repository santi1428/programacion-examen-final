import 'dart:convert';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'api/google_signin_api.dart';
import 'package:http/http.dart' as http;
import 'models/token.dart';
import 'survey.dart';
import 'models/survey_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool signingIn = false;

  Future socialLogin(Map<String, dynamic> request) async {
    var url = Uri.parse(
        'https://vehicleszulu.azurewebsites.net/api/Account/SocialLogin');
    var bodyRequest = jsonEncode(request);
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: bodyRequest,
    );

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    getData(token);
  }

  Future<void> getData(token) async {
    var url = Uri.parse('https://vehicleszulu.azurewebsites.net/api/Finals');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer ${token.token}'
      },
    );

    var body = response.body;
    var decodedJson = jsonDecode(body);
    SurveyData surveyData = SurveyData.fromJson(decodedJson);

    setState(() {
      signingIn = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Survey(token: token, surveyData: surveyData)),
    );
  }

  Future signInWithGoogle() async {
    setState(() {
      signingIn = true;
    });
    await GoogleSignInApi.signOut();
    var user = await GoogleSignInApi.login();
    if (user != null) {
      Map<String, dynamic> request = {
        'email': user.email,
        'id': user.id,
        'loginType': 1,
        'fullName': user.displayName,
        'photoURL': user.photoUrl,
      };
      await socialLogin(request);
    } else {
      setState(() {
        signingIn = false;
      });
    }
  }

  Widget signUpWithGoogleButton() {
    return ElevatedButton.icon(
      onPressed: () {
        signInWithGoogle();
      },
      icon: !signingIn
          ? const FaIcon(
              FontAwesomeIcons.google,
              size: 20,
            )
          : const SizedBox(
              child: CircularProgressIndicator(
                color: AppColors.error,
                strokeWidth: 2,
              ),
              height: 20,
              width: 20,
            ),
      label: const Text('Iniciar Sesión con Google'),
      style: ElevatedButton.styleFrom(
          primary: AppColors.green, fixedSize: const Size(250, 50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            signUpWithGoogleButton(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
