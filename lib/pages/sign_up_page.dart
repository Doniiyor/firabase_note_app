import 'package:firabasenoteapp/SERVICES/auth_services.dart';
import 'package:firabasenoteapp/SERVICES/hive_db_services.dart';
import 'package:firabasenoteapp/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "/sign_up_page";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

 Future <void>  _doSingUp()  async {
    String firstName = firstNameController.text.trim().toString();
    String phoneNumber = phoneNumberController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if(email.isEmpty || password.isEmpty || firstName.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fields cannot be null or empty')));
      return;
    }

    await AuthServices.signUpUser(firstName +"\n"+ phoneNumber, email, password,context).then((value) => _getFirebaseUser(value));



  }

  void _getFirebaseUser (User? user) {
   if(user != null) {
     HiveBase.storeUser(user.uid);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (c){
       return SignInPage();
     }));
   }else {
     print("No data -------------");
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

              // #firstname
              TextField(
                textInputAction: TextInputAction.next,
                controller: firstNameController,
                decoration: InputDecoration(
                    hintText: "Firstname"
                ),
              ),
              SizedBox(height: 10,),

              // #lastname
              TextField(
                textInputAction: TextInputAction.next,
                controller: phoneNumberController,
                decoration: InputDecoration(
                    hintText: "Phone Number"
                ),
              ),
              SizedBox(height: 10,),

              // #email
              TextField(
                textInputAction: TextInputAction.next,
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Email"
                ),
              ),
              SizedBox(height: 10,),

              // #password
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Password"
                ),
              ),
              SizedBox(height: 10,),

              // #sign_in
              MaterialButton(
                onPressed: (){
                  _doSingUp();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                height: 50,
                minWidth: MediaQuery.of(context).size.width - 50,
                color: Colors.blueAccent,
                child: Text("Sign Up"),
                textColor: Colors.white,
              ),
              SizedBox(height: 20,),

              // #don't_have_account
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, SignInPage.id);
                    },
                    child: Text("Sign In", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
