class Book {
  String Name;
  String Description;
  String Author;
  String Genre;
  String Img;
  String Pdf;

  Book({
    required this.Name,
    required this.Description,
    required this.Author,
    required this.Genre,
    required this.Img,
    required this.Pdf,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      Name: map['Name'] ?? 'Нет названия',
      Description: map['Description'] ?? 'Нет описания',
      Author: map['Author'] ?? 'Неизвестный автор',
      Genre: map['Genre'] ?? 'Неизвестный жанр',
      Img: map['Img'] ?? 'https://example.com/default-image.jpg',
      Pdf: map['Img'] ?? '?',
    );
  }
}
