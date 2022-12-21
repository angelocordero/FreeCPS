class Utils {
  static List<int?> verseListFromVerseString(String? verse) {
    if (verse == null) return [];

    if (verse.isEmpty) return [];

    List<String> num = verse.split('-');

    if (num.length == 2) {
      return [int.tryParse(num[0]), int.tryParse(num[1])];
    }

    return [int.tryParse(num[0]), null];
  }
}
