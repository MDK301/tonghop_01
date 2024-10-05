import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/component/input_text_field.dart';
import '../../res/component/round_button.dart';
import '../../view_model/forgot_password/forgot_password_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey=GlobalKey<FormState>();
  final emailController =TextEditingController();
  final emailFocusNode=FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailFocusNode.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height*1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height*.01,),
                Text('Forgot password',style: Theme.of(context).textTheme.headlineLarge,),
                SizedBox(height: height*.01,),
                Text('Enter your email address\nto get back what you forgot',textAlign: TextAlign.center,style: Theme.of(context).textTheme.headlineSmall,),
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

                        ],
                      ),
                    )
                ),

                const SizedBox(
                  width: 8,
                  height: 30,
                ),

                ChangeNotifierProvider(create: (_)=>ForgotPasswordController(),
                  child: Consumer<ForgotPasswordController>(
                    builder: (context,provider,child){
                      return RoundButton(
                        title: "Get password",
                        loading: provider.loading,
                        onPress: () {
                          if(_formKey.currentState!.validate()){
                           provider.forgotPassword(context, emailController.text);
                          }
                        },
                      );
                    },
                  ),),
                SizedBox(height: height*.03,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
