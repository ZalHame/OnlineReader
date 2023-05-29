
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_reader/service.dart';
import 'BookPage.dart';
import 'Book.dart';

DbConnection dbconnection = DbConnection();
var user = FirebaseAuth.instance;

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Онлайн читалка',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    )),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Мой профиль'),
                onTap: () {
                  // Действия при нажатии на "Мой профиль"
                  Navigator.pushNamed(context, '/Profile'); // Закрываем drawer
                  // Дополнительные действия, например, переход на экран просмотра профиля
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Выйти'),
                onTap: () {
                  // Действия при нажатии на "Мой профиль"
                  dbconnection.logOut();
                  Navigator.pushNamed(context, '/'); // Закрываем drawer
                  // Дополнительные действия, например, переход на экран просмотра профиля
                },
              ),
              // Добавьте другие пункты меню здесь
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Онлайн читалка",
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(indicatorColor: Colors.white, tabs: <Widget>[
            Tab(
              text: 'Каталог',
              icon: Icon(
                Icons.my_library_books_outlined,
                color: Colors.white,
              ),
            ),
            Tab(
                text: 'Закладки',
                icon: Icon(
                  Icons.bookmark,
                  color: Colors.white,
                )),
          ]),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          Builder(builder: (BuildContext context) {
            return BookListView();
          }),
          Builder(builder: (BuildContext context) {
            return FavoriteBookListView();
          })
        ]),
      ),
    );
  }
}



class BookListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Book').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final books = snapshot.data?.docs;
        return ListView.builder(
          itemCount: books?.length,
          itemBuilder: (context, index) {
            final bookData = (books?[index].data() as Map<String, dynamic>);
                if (snapshot.hasData) {
                  final book = Book(
                    Name: bookData['Name'] as String,
                    Description: bookData['Description'] as String,
                    Author: bookData['Author'] as String,
                    Genre: bookData['Genre'] as String,
                    Img: bookData['Img'] as String,
                  );
                  return BookListItem(book: book);
                }
              },
        );
      },
    );
  }
}

class FavoriteBookListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(user.currentUser!.email.toString()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final books = snapshot.data?.docs;
        return ListView.builder(
          itemCount: books?.length,
          itemBuilder: (context, index) {
            final bookData = (books?[index].data() as Map<String, dynamic>);
                if (snapshot.hasData) {
                  final book = Book(
                    Name: bookData['Name'] as String,
                    Description: bookData['Description'] as String,
                    Author: bookData['Author'] as String,
                    Genre: bookData['Genre'] as String,
                    Img: bookData['Img'] as String,
                  );
                  return BookListItem(book: book);
                }
              },
        );
      },
    );
  }
}

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        book.Img,
        fit: BoxFit.fill,
      ),
      title: Text(book.Name),
      subtitle: Text(book.Author),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookPage(book: book),
          ),
        );
      },
    );
  }
}
