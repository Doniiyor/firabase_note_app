import 'package:firabasenoteapp/SERVICES/auth_services.dart';
import 'package:firabasenoteapp/pages/home_page.dart';
import 'package:firabasenoteapp/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static const String id = "/sign_in_page";
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  TextEditingController  _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool loading =  false;

  Future<void> _doSignIn () async {
    String email = _emailController.text.trim().toString();
    String password = _passwordController.text.trim().toString();

    if(email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fields cannot be null or empty')));
      return;
    }
    await AuthServices.signInUser(email, password,context).then((value) => _getFribaseUser(value));

  }

  void _getFribaseUser (User? user) {
    if(user != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: user,)));
    }else{
      /// eror msg
      return;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                textInputAction: TextInputAction.next,
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email"
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: "Password"
                ),
              ),
              SizedBox(height: 10,),
              MaterialButton(
                onPressed: _doSignIn,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 50,
                minWidth: MediaQuery.of(context).size.width - 50,
                color: Colors.blueAccent,
                child: Text("Sign In"),
                textColor: Colors.white,
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Don't have an acaunt  ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                  InkWell(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, SignUpPage.id);
                    },
                      child: Text("Sign Up",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
