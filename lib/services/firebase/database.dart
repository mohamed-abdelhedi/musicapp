import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicapp/screen/login/signup.dart';

Timestamp _dateTimeToTimestamp(DateTime dateTime) {
  return Timestamp.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
}

class DatabaseService {
  final String email;
  DatabaseService({required this.email});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  Future<void> updateUser(
    String email,
    String name,
    DateTime date,
    List<dynamic> likedSongs,
    List<dynamic> downloadedSongs,
    List<dynamic> favoritePlaylist,
  ) async {
    return await users.doc(email).set({
      'email': SignupWidget.email,
      'name': SignupWidget.name,
      'BirthDate': _dateTimeToTimestamp(date),
      'likedSongs': likedSongs,
      'downloadedSongs': downloadedSongs,
      'favoritePlaylist': favoritePlaylist,
    });
  }
}
