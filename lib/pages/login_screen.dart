import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mob_auth/pages/verify_otp_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  var mobileNumber = "";
  TextEditingController mobileController = TextEditingController();

  void sendOtp()async{
    try{
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        codeSent: (verificationId, resendingToken) {
          Fluttertoast.showToast(msg: "Otp Send Successfully",gravity: ToastGravity.TOP,backgroundColor: Colors.redAccent,fontSize: 18,textColor: Colors.white,);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerification(verificationId: verificationId)));
        },
        verificationCompleted: (phoneAuthCredential) {},
        codeAutoRetrievalTimeout: (verificationId) {},
        verificationFailed: (ex){
          Fluttertoast.showToast(msg: ex.code.toString(),gravity: ToastGravity.TOP,backgroundColor: Colors.redAccent,fontSize: 18,textColor: Colors.white,);
        },
        timeout: Duration(seconds: 30),
      );
    }on FirebaseAuthException catch(ex){
      Fluttertoast.showToast(msg: ex.code.toString(),gravity: ToastGravity.TOP,backgroundColor: Colors.redAccent,fontSize: 18,textColor: Colors.white,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login Screen"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 25,),
                TextFormField(
                  autofocus: false,
                  maxLength: 10,

                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  controller: mobileController,
                  decoration: InputDecoration(
                      prefix: Text("+91"),
                      label: Text("Mobile Number"),
                      counterText: "",
                      errorStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.redAccent),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Empty Filled";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15,),
                ElevatedButton(onPressed: (){
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      mobileNumber = "+91"+mobileController.text.trim();
                    });
                    sendOtp();
                  }
                }, child: Text("Send Otp",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
