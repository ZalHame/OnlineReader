import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Онлайн читалка",
          textAlign: TextAlign.center,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Colors.blue,
            height: 50,
            child: Row(
              children: [
                Image.asset("Images/bookshelf.png"),
                Text("Каталог"),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            height: 50,
            child: Row(
              children: [
                Image.asset("Images/glass.png"),
                Text("Поиск"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
