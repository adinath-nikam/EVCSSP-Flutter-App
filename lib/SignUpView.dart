
import 'package:evcssp/FirebaseService.dart';
import 'package:evcssp/SignInView.dart';
import 'package:evcssp/homeView.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'CommonComponentWidgets.dart';
import 'ModelProfileData.dart';
import 'TabView.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController upiController = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey();
  bool _obscureText = true;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Widget CustomText(
      {required String text, required double textSize, required Color color, bool? softwrap}) {
    return Text(
      text,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      softWrap: softwrap,
      style: TextStyle(
        fontSize: textSize,
        fontFamily: "ProductSans-Bold",
        color: color,
      ),
    );
  }

  Widget CustomButton(
      {required String text,
        required double buttonSize,
        required BuildContext context,
        required Function function,
        Widget? activity}) {
    return SizedBox(
      height: buttonSize,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            function();
          },
          child: CustomText(text: text, textSize: 14, color: Colors.white)),
    );
  }


  //Header Image
  Widget HeaderImage() {
    return Container(
      padding: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: const Align(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage("assets/images/templogo.png"),
          height: 250,
          width: 500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderImage(),
              Container(

                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Center(
                      child: CustomText(
                          text: "CREATE AN ACCOUNT HERE", textSize: 22, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: CustomText(
                          text: "Verify your Email Get Started",
                          textSize: 18,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: signUpFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Enter Email...",
                                  prefixIcon: const Icon(Icons.mail_outline),
                                  contentPadding: const EdgeInsets.all(25.0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.1),
                                ),
                                validator: (value) {

                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  contentPadding: const EdgeInsets.all(25.0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.1),
                                  hintText: 'Enter your Name...',
                                  // Here is key idea

                                ),
                                controller: nameController,
                                validator: (value) {

                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.attach_money_outlined),
                                  contentPadding: const EdgeInsets.all(25.0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.1),
                                  hintText: 'Enter your UPI ID...',
                                  // Here is key idea

                                ),
                                controller: upiController,
                                validator: (value) {

                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.password),
                                  contentPadding: const EdgeInsets.all(25.0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.1),
                                  hintText: 'Enter your Password...',
                                  // Here is key idea

                                ),
                                controller: passwordController,
                                obscureText: _obscureText,
                                validator: (value) {

                                },
                              ),
                            ],
                          )),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CustomButton(text: 'SIGN UP', buttonSize: 55, context: context, function: (){

                            if (signUpFormKey.currentState!.validate()) {
                              showLoaderDialog(context, "Signing Up..");

                              firebaseAuthServices.signUpWithEmail(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  context: context).whenComplete(() {

                                    FirebaseDatabase.instance.ref('EVCSSP/USERS_DATA')
                                        .child(FirebaseAuthServices().firebaseUser!.uid)
                                        .set({
                                      "userName": nameController.text.toString(),
                                      "userID": FirebaseAuthServices().firebaseUser!.uid,
                                      "upiID": upiController.text.toString(),
                                    });

                              });
                            }

                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Divider(
                                    color: Colors.black,
                                  )),
                              CustomText(
                                  text: "Already Have an Account ?",
                                  textSize: 14,
                                  color: Colors.black),
                              Expanded(
                                  child: Divider(
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(text: 'SIGN IN', buttonSize: 55, context: context, function: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>SignInView()));
                          }),
                          const SizedBox(
                            height: 20,
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
