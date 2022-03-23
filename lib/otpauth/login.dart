import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

enum LoginScreen {
  SHOW_MOBILE_ENTER_WIDET,
  SHOW_OTP,
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController  phoneController = TextEditingController();
  TextEditingController  otpController = TextEditingController();

  LoginScreen currentState = LoginScreen.SHOW_MOBILE_ENTER_WIDET;
  FirebaseAuth _auth =FirebaseAuth.instance;
  String verificationID="";



  void signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async
{

  try {
    final authCred = await _auth.signInWithCredential(phoneAuthCredential);

    if(authCred.user != null)
    {

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
    }
  } on FirebaseAuthException catch (e) {

    print(e.message);
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Some Error Occured. Try Again Later')));
  }
}



  showMobileFormWidget(context) {
    return
    Container(
      color: Colors.amber[50],
      child: Column(children: [
        TextField(
          controller: phoneController,
          decoration: InputDecoration(hintText: "Phone Number"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(onPressed: () async {
          await _auth.verifyPhoneNumber(phoneNumber: "+91${phoneController.text}", verificationCompleted: (PhoneAuthCredential) async{

          }, verificationFailed: (VerificationFailed){
            print(VerificationFailed);
          },
           codeSent: (verificationID , resendingToken) async{
             setState(() {
               currentState = LoginScreen.SHOW_OTP;
               this.verificationID = verificationID;
             });

           },
            codeAutoRetrievalTimeout: (varificationID) async{

            }
          );

        }, child: Text("Get Otp")),
      ]),
    );
  }
    showOtpFormWidget(context) { return
    Container(
      color: Colors.amber[50],
      child: Column(children: [
        TextField(
          controller: otpController,
          decoration: InputDecoration(hintText: "Otp"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ], 
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(onPressed: () {
          AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text);
        signInWithPhoneAuthCred(phoneAuthCredential);
        }, child: Text("Verify")),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: currentState == LoginScreen.SHOW_MOBILE_ENTER_WIDET
          ? showMobileFormWidget(context)
          : showOtpFormWidget(context),
    );
  }
}
