import 'package:firabasenoteapp/SERVICES/hive_db_services.dart';
import 'package:firabasenoteapp/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthServices {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User?> signUpUser(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.updateEmail(email);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')));
        print("The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The account already exists for that email.')));
        print("The account alredy exists for that email.");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> signInUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(userCredential.user.toString());
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
        print("No User found for that email");
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
        print("Wrong password provided for that user.");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future <void> signOut(BuildContext context) async {
    await auth.signOut();
    HiveBase.removeUser();
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  static Future<void> deletUser(BuildContext context) async {
    HiveBase.removeUser();
    try {
      await auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('your account deleted')));
        print("deleted");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Nooooooooooo')));
        print("no deleted");
        return;
      }
    } catch (e) {
      print(e);
    }
    return;
  }
}
