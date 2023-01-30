import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'constants.dart';

class BibleParser {
  BibleParser(this.filePath) {
    parse();
  }

  Map<String, int> booksData = {};
  String filePath;
  JsonEncoder jsonEncoder = const JsonEncoder.withIndent(' ');
  late Map inputMap;

  void parse() async {
    inputMap = jsonDecode(File(filePath).readAsStringSync());

    String translationName = inputMap['translationName'];
    String translation = inputMap['translation'];

    String biblesDirPath = await biblesDirectory();

    Directory(join(biblesDirPath, translation, 'books')).createSync(recursive: true);

    _parseBooks(
      translation: translation,
      biblesDirPath: biblesDirPath,
    );

    _setTranslationData(
      translation: translation,
      name: translationName,
      biblesDirPath: biblesDirPath,
    );
  }

  void _parseBooks({
    required String translation,
    required String biblesDirPath,
  }) {
    List<Map> books = List.from(inputMap['books']);

    for (var book in books) {
      String bookName = book['name'];

      String outputPath = join(biblesDirPath, translation, 'books', '$translation.$bookName.json');

      File(outputPath).writeAsStringSync(jsonEncoder.convert(book));

      List chapters = book['chapters'];

      booksData[bookName] = chapters.length;
    }
  }

  void _setTranslationData({
    required String name,
    required String translation,
    required String biblesDirPath,
  }) {
    Map translationData = {};

    translationData['translation'] = translation;
    translationData['translationName'] = name;
    translationData['books'] = booksData;

    String outputPath = join(biblesDirPath, translation, '$translation.metadata.json');

    File(outputPath).writeAsStringSync(jsonEncoder.convert(translationData));
  }
}
