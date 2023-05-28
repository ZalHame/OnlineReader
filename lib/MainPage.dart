import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BookPage.dart';


import 'Book.dart';

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
  Future<String> getPdfUrl(String bookName) async {
    String pdfUrl;
    Reference storageRef = FirebaseStorage.instance.ref().child('Pdf').child('$bookName.pdf');
    pdfUrl = await storageRef.getDownloadURL();
    return pdfUrl;
  }

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
            final bookName = bookData['Name'] as String;
          
            return FutureBuilder<String>(
              future: getPdfUrl(bookName),
              builder: (context, pdfSnapshot) {
                if (pdfSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text(bookName),
                    subtitle: Text('Загрузка PDF...'),
                  );
                }
                if (pdfSnapshot.hasData) {
                  final pdfUrl = pdfSnapshot.data!;
                  final book = Book(
                    Name: bookData['Name'] as String,
                    Description: bookData['Description'] as String,
                    Author: bookData['Author'] as String,
                    Genre: bookData['Genre'] as String,
                    Img: bookData['Img'] as String,
                    Pdf: pdfUrl,
                  );
                  return BookListItem(book: book);
                }
                return ListTile(
                  title: Text(bookName),
                  subtitle: Text('PDF недоступен'),
                );
              },
            );
          },
        );
      },
    );
  }
}

class FavoriteBookListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Вывод избранных книг
    return Container();
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
