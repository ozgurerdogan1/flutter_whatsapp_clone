import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../common_widget/social_login_button.dart';
import '../../../view_model/user_view_model.dart';
import 'email_sifre_kayit_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  _pressSignInAnonymous(context, userVm) async {
    await userVm.signInAnonymously();
    debugPrint("misafir girişi istek yapıldı");
  }

  _pressSignInWithGoole(context, userVm) async {
    await userVm.signInWithGoogle();
    debugPrint("google ile giriş isteği yapıldı");
  }

  _pressSignInWithFacebook(context, userVm) async {
    await userVm.signInWithFacebook();
    debugPrint("facebook ile girişi isteği yapıldı");
  }

  _emailVeSifreKayit(context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const EmailSifreKayitLogin(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("sign_in page build");
    UserViewModel userVm = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp Clone"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: EdgeInsets.all(30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 8),
            oturumAcText(),
            //SizedBox(height: 100.h),
            const Spacer(),
            googleGirisButton(context, userVm),
            const Spacer(),
            facebookGirisButton(context, userVm),
            const Spacer(),
            emailVeSifreGirisButton(context),
            const Spacer(),
            anonymousGirisButton(context, userVm),
            const Spacer(flex: 10),
            //Flexible(child: SizedBox(height: 300.sp))
          ],
        ),
      ),
    );
  }

  Widget googleGirisButton(context, userVm) {
    return SocialLoginButton(
        //buttonHeight: 60.sp,
        //titleSize: 30.sp,
        //iconSize:40.sp
        // radius: 40.r,
        buttonIcon: Image.asset(
          "assets/images/google.png",
          fit: BoxFit.contain,
        ),
        buttonColor: Colors.white,
        buttonText: "Google ile Oturum Aç",
        textColor: Colors.black,
        onPressed: () {
          _pressSignInWithGoole(context, userVm);
        });
  }

  Widget facebookGirisButton(context, userVm) {
    return SocialLoginButton(
      buttonIcon: Image.asset(
        "assets/images/facebook.png",
        fit: BoxFit.contain,
      ),
      buttonColor: const Color(0xFF334D92),
      buttonText: "Facebook ile Oturum Aç",
      textColor: Colors.white,
      onPressed: () {
        _pressSignInWithFacebook(context, userVm);
      },
    );
  }

  Widget emailVeSifreGirisButton(context) {
    return SocialLoginButton(
      buttonIcon: Image.asset(
        "assets/images/gmail.png",
        fit: BoxFit.contain,
      ),
      buttonColor: Colors.red,
      buttonText: "Email ve Şifre ile Giriş Yap",
      textColor: Colors.white,
      onPressed: () {
        _emailVeSifreKayit(context);
      },
    );
  }

  Widget anonymousGirisButton(context, userVm) {
    return SocialLoginButton(
      buttonIcon: const Icon(
        Icons.supervised_user_circle,
      ),
      buttonColor: Colors.teal,
      buttonText: "Misafir Olarak Giriş Yap",
      textColor: Colors.white,
      onPressed: () {
        _pressSignInAnonymous(context, userVm);
      },
    );
  }

  Widget oturumAcText() {
    return Text(
      "Oturum Açın",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 90.sp),
    );
  }
}
