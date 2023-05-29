import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_reader/model.dart';
import 'package:online_reader/service.dart';

TextEditingController  email = TextEditingController();
TextEditingController  password = TextEditingController();
var userinfo = FirebaseAuth.instance;
DbConnection dbconnection = DbConnection();

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 810,
        color: Color.fromARGB(255, 0, 140, 255),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Image.asset('Images/icon.png', height: 120,),
            Text(
              'Регистрация',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Пароль',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () async {
                  UserModel? user = await dbconnection.signUp(email.text, password.text);
                      if (user != null)
                      {} 
                      else {
                        return;
                      }     
                      email.clear();
                      password.clear();             
                      Navigator.pushNamed(context, '/');
                },
                child: Text('Зарегистрироваться'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
                email.clear();
                password.clear();
              },
              child: Text(
                'Войти',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
      )
      
    );
  }
}