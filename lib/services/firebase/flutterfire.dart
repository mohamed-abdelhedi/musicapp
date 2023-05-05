import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screen/login/signup.dart';
import 'database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

// final storage = new FlutterSecureStorage();

// Future<void> storeTokenAndData(UserCredential userCredential) async {
//   await storage.write(
//       key: "token", value: userCredential.credential?.token.toString());
//   await storage.write(key: "userCredential", value: userCredential.toString());
// }

// Future<String?> getToken() async {
//   return await storage.read(key: "token");
// }

Future<String> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    // storeTokenAndData(userCredential);

    bool verify = FirebaseAuth.instance.currentUser!.emailVerified;

    return "success";
  } catch (e) {
    print(e);
    return e.toString();
  }
}

Future<String?> register(String email, String password) async {
  try {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    await DatabaseService(email: email)
        .updateUser(email, SignupWidget.name, SignupWidget.date, [], [], []);
    await user!.updateDisplayName(email);
    await user!.updateEmail(email);
    return "success";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return 'The account already exists for that email.';
    }
    //return false;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}

String getUid() {
  return FirebaseAuth.instance.currentUser!.email.toString();
}

void verify() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
  }
}



/*Future<bool> addCoin(String id, String amount) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var value = double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Coins')
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({'Amount': value});
        return true;
      }
      double newAmount = snapshot.data()['Amount'] + value;
      transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> removeCoin(String id) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Coins')
      .doc(id)
      .delete();
  return true;
}*/

