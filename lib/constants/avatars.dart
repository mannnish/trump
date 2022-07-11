class Avatars {
  static const bucket = "https://firebasestorage.googleapis.com/v0/b/tr-ump.appspot.com/o/avatars%2F";
  static const query = "?alt=media&token=915dbef4-f3c2-4c9f-be8b-264da619c07e";
  static const List<String> list = [
    "avataaars%20(1).png",
    "avataaars%20(2).png",
    "avataaars%20(3).png",
    "avataaars%20(4).png",
    "avataaars%20(5).png",
    "avataaars.png",
  ];

  static String get getRandom {
    DateTime now = DateTime.now();
    int i = now.second % Avatars.list.length;
    return bucket + list[i] + query;
  }
}
