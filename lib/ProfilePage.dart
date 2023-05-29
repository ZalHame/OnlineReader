import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_reader/Book.dart';
import 'package:online_reader/BookPage.dart';

var user = FirebaseAuth.instance;
String books = 'Мои книги';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Личный кабинет'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: 600,
        color: Colors.blue[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              user.currentUser!.email.toString(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              books,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(user.currentUser!.email.toString()).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final books = snapshot.data!.docs;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> book = books[index].data() as Map<String, dynamic>;
                        final mybook = Book(
                        Name: book['Name'] as String,
                        Description: book['Description'] as String,
                        Author: book['Author'] as String,
                        Genre: book['Genre'] as String,
                        Img: book['Img'] as String,
                  );
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookPage(book: mybook),
                                ),
                              );
                            },
                            child: Column(
                            children: [
                              Container(
                                width: 120,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(book['Img'] ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: Text(
                                book['Name'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ),
                              
                              SizedBox(height: 4),
                              Text(
                                book['Author'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          )
                          
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Ошибка при загрузке данных');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
