import 'package:flutter/material.dart';
import 'package:online_reader/model.dart';
import 'package:online_reader/service.dart';
TextEditingController  email = TextEditingController();
TextEditingController  password= TextEditingController();

DbConnection dbconnection = DbConnection();

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 0, 140, 255),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('Images/icon.png', height: 120,),
            Text(
              'Добро пожаловать!',
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
                  UserModel? user = await dbconnection.signIn(
                      email.text, password.text);
                      email.clear();
                      password.clear();
                    if (user != null) {
                      
                    }
                    else {
                      // ignore: use_build_context_synchronously
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color.fromARGB(255, 0, 140, 255),
                          title: const Text('Error', style: TextStyle(color: Color.fromARGB(255, 233, 241, 243))),
                          content: const Text('Invalid E-mail or Password', style: TextStyle(color: Color.fromARGB(255, 233, 241, 243))),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }, 
                      );
                      return;
                    }
                    Navigator.pushNamed(context, '/Main');
                },
                child: Text('Войти'),
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
                Navigator.pushNamed(context, '/Reg');
                email.clear();
                password.clear();
              },
              child: Text(
                'Зарегистрироваться',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}