library api;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

String hash(String input){
  List<int> bytes = utf8.encode(input);
  return sha256.convert(bytes).toString();
}

class BGApiClient{


  void createAccount(String username, String password, String email){
    String postUrl = 'https://prod-06.northeurope.logic.azure.com:443/workflows/165d7c3c2d404427bd1f8fe192769d7e/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=mmiNGNR2yrwdDq0h-ukrb1AsYTZP0IIlmN7ShpnebuA';
    password = hash(password);
    print('PW: $password');
    print(jsonEncode({
          'username':username,
          'password':password,
          'email':email
        }));
    http.post(
      Uri.parse(postUrl),
      headers: {
        "Content-Type":"application/json; charset=UTF-8"
      },
      body: 
        jsonEncode({
          'username':username,
          'password':password,
          'email':email
        })
      
    ).then(
      (response) => {
        print(response)
      }
      );
  }

  Future<bool> tryLogin(String username, String password) async{
    String candidatePassword = hash(password);
    String postUrl = 'https://prod-27.northeurope.logic.azure.com:443/workflows/de7ee0a06ca746b0a5716b818000be5b/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=Ppd293q9mpEcs-PwIt5XrksK7Z4dehjxjJNHkapp8Fw';

    http.Response resp = await http.post(
      Uri.parse(postUrl),
      headers: {
        "Content-Type":"application/json; charset=UTF-8"
      },
      body: 
        jsonEncode({
          'username':username,
        })
    );
    
    var data = jsonDecode(resp.body);
    return data['password'] == candidatePassword;


  }


}