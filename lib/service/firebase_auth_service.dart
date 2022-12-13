import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService extends AuthBase {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = await _fireAuth.currentUser;
      return _userFromFirebase(user);
    } on Exception catch (e) {
      debugPrint("currentUser error: $e");
      return null;
    }
  }

  UserModel? _userFromFirebase(User? user) {
    if (user != null) {
      return UserModel(userId: user.uid);
    }
    return null;
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      var credential = await _fireAuth.signInAnonymously();
      return _userFromFirebase(credential.user);
    } on Exception catch (e) {
      print("sign in error: $e");
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _fireAuth.signOut();

      await FacebookLogin().logOut();
      await _fireAuth.signOut();

      return true;
    } on Exception catch (e) {
      debugPrint("sign out error: $e");
      return false;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    GoogleSignInAccount? _googleAccount = await GoogleSignIn().signIn();

    if (_googleAccount != null) {
      GoogleSignInAuthentication _googleAuth =
          await _googleAccount.authentication;
      debugPrint(_googleAuth.accessToken);
      debugPrint("_googleAuth.idToken  ${_googleAuth.idToken}");

      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential _googleCredential = await _fireAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));

        print(_googleCredential.credential);
        return _userFromFirebase(_googleCredential.user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    final fb = FacebookLogin();

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
      FacebookPermission.userBirthday
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = res.accessToken;
        print("acces token: $accessToken");

        if (accessToken != null) {
          final _facebookCredential = await _fireAuth.signInWithCredential(
              FacebookAuthProvider.credential(accessToken.token));
          debugPrint("facebook credential: ${_facebookCredential.credential}");

          final profile = await fb.getUserProfile();
          debugPrint("hello ${profile?.name}  You Id ${profile?.userId}");

          final imageUrl = await fb.getProfileImageUrl(width: 100);
          print('Your profile image: $imageUrl');

          final email = await fb.getUserEmail();
          print('And your email is $email');

          

          return _userFromFirebase(_facebookCredential.user);
        }

        break;

      case FacebookLoginStatus.cancel:
        debugPrint("Kullanıcı facebook girişi iptal edildi ");
        break;

      case FacebookLoginStatus.error:
        print('Error while log in: ${res.error}');
        break;
    }
    return null;
  }
  
  @override
  Future<UserModel?> signInWithEmail() {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel?> signUpEmailPass() {
    // TODO: implement signUpEmailPass
    throw UnimplementedError();
  }
}
