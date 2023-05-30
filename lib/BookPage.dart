import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'Book.dart';

var user = FirebaseAuth.instance;
TextEditingController reviewController = TextEditingController();

class BookPage extends StatefulWidget {
  final Book book;

  BookPage({required this.book});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  
  Future<bool> isBookInFavorites(String userEmail, String bookName) async {
  CollectionReference userCollection = FirebaseFirestore.instance.collection(userEmail);
  DocumentSnapshot bookSnapshot = await userCollection.doc(bookName).get();

  return bookSnapshot.exists;
}

Future<void> addReview(String review) async {
    final bookName = widget.book.Name;
    final userName = user.currentUser!.email.toString();

    final reviewsCollection = FirebaseFirestore.instance.collection(bookName);

    await reviewsCollection.add({
      'userName': userName,
      'bookName': bookName,
      'review': review,
    });
  }

Future<void> checkIfBookIsFavorite() async {
    bool favorite = await isBookInFavorites(user.currentUser!.email.toString(), widget.book.Name);
    setState(() {
      isFavorite = favorite;
    });
  }

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfBookIsFavorite();
  }


  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    
    if (isFavorite) {
      FirebaseFirestore.instance
                          .collection(user.currentUser!.email.toString())
                          .doc(widget.book.Name)
                          .set({
                        'Name': widget.book.Name,
                        'Description': widget.book.Description,
                        'Author': widget.book.Author,
                        'Genre': widget.book.Genre,
                        'Img': widget.book.Img,
                      });
    } else {
      FirebaseFirestore.instance.collection(user.currentUser!.email.toString()).doc(widget.book.Name).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.Name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.book.Img,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              'Автор: ${widget.book.Author}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Жанр: ${widget.book.Genre}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Описание:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.book.Description,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookPdfPage(book: widget.book),
                      ),
                    );
                  },
                  child: Text(
                    'Читать',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
             Center(
              child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Написать отзыв'),
                          content: TextField(
                            controller: reviewController,
                            decoration: InputDecoration(
                              hintText: 'Введите отзыв',
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                addReview(reviewController.text);
                                reviewController.clear();
                                Navigator.pop(context);
                              },
                              child: Text('Отправить'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Написать отзыв',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: toggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                    
                  ),
                ),
              ),
            ),
            
           SingleChildScrollView(
  padding: EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ...Остальной код...

      SizedBox(height: 16),

      Text(
        'Отзывы:',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),

      SizedBox(height: 8.0),

      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(widget.book.Name).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reviews = snapshot.data!.docs;

            if (reviews.isEmpty) {
              return Text('Нет отзывов');
            }

            return ListView.builder(
              shrinkWrap: true, // Добавлено свойство shrinkWrap
              physics: NeverScrollableScrollPhysics(), // Добавлено свойство physics
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final reviewDoc = reviews[index];
                final reviewData = reviewDoc.data() as Map<String, dynamic>;
                final userName = reviewData['userName'] as String;
                final reviewText = reviewData['review'] as String;

                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Пользователь: $userName',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Отзыв: $reviewText',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Ошибка при загрузке отзывов');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),

      SizedBox(height: 16),
    ],
  ),
),
          ],
        ),
      ),
    );
  }
}

class BookPdfPage extends StatelessWidget {
  final Book book;

  BookPdfPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.Name),
        backgroundColor: Colors.blue,
      ),
      body: SfPdfViewer.asset("pdf/" + book.Name + ".pdf"),
    );
  }
}
