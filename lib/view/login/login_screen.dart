import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/component/input_text_field.dart';
import '../../res/component/round_button.dart';
import '../../utils/routes/route_name.dart';
import '../../view_model/login/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey=GlobalKey<FormState>();
  final emailController =TextEditingController();
  final emailFocusNode=FocusNode();
  final passwordController =TextEditingController();
  final passwordFocusNode=FocusNode();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height*1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height*.01,),
                Text('Wellcome to the App',style: Theme.of(context).textTheme.headlineLarge,),
                SizedBox(height: height*.01,),
                Text('Enter your email address\nto connect to your account',textAlign: TextAlign.center,style: Theme.of(context).textTheme.headlineSmall,),
                SizedBox(height: height*.01,),
                Form(key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(top:height *.06 ,bottom: height*0.01),
                      child: Column(
                        children: [
                          InputTextField(
                              myController: emailController,
                              focusNode: emailFocusNode,
                              onFiledSubmittedValue: (value){

                              },
                              onValidator: (value){
                                return value.isEmpty ? 'enter email ': null;
                              },
                              enable: true,
                              keyBoardType: TextInputType.emailAddress,
                              hint: "Email",
                              obscureText: false
                          ),
                          SizedBox(height: height*0.01,),
                          InputTextField(
                              myController: passwordController,
                              focusNode: passwordFocusNode,
                              onFiledSubmittedValue: (value){

                              },
                              onValidator: (value){
                                return value.isEmpty ? 'enter password ': null;
                              },
                              enable: true,
                              keyBoardType: TextInputType.visiblePassword,
                              hint: "password",
                              obscureText: true
                          ),

                        ],
                      ),
                    )
                ),
                Align(

                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(context, RouteName.forgotPassword);

                    },
                    child: Text(

                         "Forgot password",
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15,decoration: TextDecoration.underline)
                    ),
                  ),
                ),

               const SizedBox(
                  width: 8,
                  height: 30,
                ),
                ChangeNotifierProvider(create: (_)=>LoginController(),
                child: Consumer<LoginController>(
                  builder: (context,provider,child){
                    return RoundButton(
                      title: "login",
                      loading: provider.loading,
                      onPress: () {
                        if(_formKey.currentState!.validate()){
                          provider.login(context, emailController.text, passwordController.text);
                        }
                      },
                    );
                  },
                ),),
                SizedBox(height: height*.03,),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, RouteName.signUpScreen);
                  },
                  child: Text.rich(TextSpan(
                    text: "Don't have an account?",
                    style:Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 15) ,
                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15,decoration: TextDecoration.underline)
                      ),
                    ]
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
