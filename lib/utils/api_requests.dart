import 'dart:convert';
import 'dart:io';
import 'package:chat_up/main.dart';
import 'package:http/http.dart' as http;

String httpBaseUrl = "chatup-node-deploy.herokuapp.com";

Future<dynamic> signUpUser({required fullname, required email,required password}) async {
  // try {
  http.Client client = http.Client();
  http.Response response = await client.post(
    Uri.https(httpBaseUrl, "/auth/signup"),
    body: json.encode({
      "fullname": fullname,
      "email": email,
      "password": password//subscriber, publisher
    }),
    headers: {
      "Content-Type": "application/json"
    },
  );
  dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  return decodedResponse;
  
}

Future<dynamic> LoginUser({required email, required password}) async {
  // try {
  http.Client client = http.Client();
  http.Response response = await client.post(
    Uri.https(httpBaseUrl, "/auth/login"),
    body: json.encode({
      "email": email,
      "password": password//subscriber, publisher
    }),
    headers: {
      "Content-Type": "application/json"
    },
  );
  dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  return decodedResponse;
  
}

Future<dynamic> viewAllUsers() async {
  // try {
  http.Client client = http.Client();
  http.Response response = await client.post(
    Uri.https(httpBaseUrl, "/viewUsers/allUsers"),
    body: json.encode({
      "token": getX.read(constants.GETX_TOKEN),
      //subscriber, publisher
    }),
    headers: {
      "Content-Type": "application/json"
    },
  );
  dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  return decodedResponse;
  
}