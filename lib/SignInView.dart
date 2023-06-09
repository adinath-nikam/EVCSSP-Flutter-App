
import 'package:evcssp/homeView.dart';
import 'package:flutter/material.dart';

import 'CommonComponentWidgets.dart';
import 'ModelProfileData.dart';
import 'SignUpView.dart';
import 'TabView.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  // final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  bool _obscureText = true;




  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Custom Text Widget
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
      padding: EdgeInsets.all(00),
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: const Align(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage("assets/images/logo2.png"),
          height: 250,
          width: 400,
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
                          text: "LOGIN", textSize: 28, color: Colors.black),
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
                          key: signInFormKey,
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
                                  hintText: 'Enter your Password',
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>TabView()));
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomText(
                            text: "Forgot Password ?",
                            textSize: 12,
                            color: Colors.black),
                      ),
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
                          CustomButton(text: 'SIGN IN', buttonSize: 55, context: context, function: (){

                            if (signInFormKey.currentState!.validate()) {
                              showLoaderDialog(context, "Signing In..");

                              firebaseAuthServices.signInWithEmail(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  context: context);


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
                                  text: "Don't have an Account ?",
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
                          GestureDetector(
                            onTap: (){

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (Builder) => SignUpView()));

                            },

                            child: CustomButton(text: 'SIGN UP', buttonSize: 55, context: context, function: (){

                              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>SignUpView()));

                            }
                            ,),
                          ),
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
