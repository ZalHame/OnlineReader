import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(),
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
        body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Center(
                child: Text(
                  'reader',
                ),
              ),
              Center(
                child: Text(
                  'zaklad',
                ),
              )
            ]),
      ),
    );
  }
}
