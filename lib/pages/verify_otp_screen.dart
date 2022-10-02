import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mob_auth/pages/home_screen.dart';


class OtpVerification extends StatefulWidget {
  final String verificationId;
  const OtpVerification({Key? key,required this.verificationId}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _formkey = GlobalKey<FormState>();
  var otp = "";
  TextEditingController otpController = TextEditingController();

  void verify()async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: otp);

    try{
      if(credential != null){
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
    }on FirebaseAuthException catch(ex){
      Fluttertoast.showToast(msg: ex.code.toString(),gravity: ToastGravity.TOP,backgroundColor: Colors.redAccent,fontSize: 18,textColor: Colors.white,);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Verify OTP"),
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
                  style: TextStyle(fontSize: 20,),
                  controller: otpController,
                  decoration: InputDecoration(

                      label: Text("OTP"),
                      hintText: "Enter Otp here",
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
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      otp = otpController.text.trim();
                    });
                    verify();
                  }
                }, child: Text("Verify",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
