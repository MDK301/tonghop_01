import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/component/input_text_field.dart';
import '../../res/component/round_button.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';
import '../../view_model/sign_up/sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final userNameFocusNode = FocusNode();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

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
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ChangeNotifierProvider(
            create: (_) => SignUpController(),
            child: Consumer<SignUpController>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * .01,
                      ),
                      Text(
                        'Wellcome to the App',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Text(
                        'Enter your email address\nto register your account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * .06, bottom: height * 0.01),
                            child: Column(
                              children: [
                                InputTextField(
                                    myController: userNameController,
                                    focusNode: userNameFocusNode,
                                    onFiledSubmittedValue: (value) {},
                                    onValidator: (value) {
                                      return value.isEmpty
                                          ? 'enter username '
                                          : null;
                                    },
                                    enable: true,
                                    keyBoardType: TextInputType.emailAddress,
                                    hint: "UseName",
                                    obscureText: false),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                InputTextField(
                                    myController: emailController,
                                    focusNode: emailFocusNode,
                                    onFiledSubmittedValue: (value) {
                                      Utils.fieldFocus(context, emailFocusNode,
                                          passwordFocusNode);
                                    },
                                    onValidator: (value) {
                                      return value.isEmpty
                                          ? 'enter email '
                                          : null;
                                    },
                                    enable: true,
                                    keyBoardType: TextInputType.emailAddress,
                                    hint: "Email",
                                    obscureText: false),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                InputTextField(
                                    myController: passwordController,
                                    focusNode: passwordFocusNode,
                                    onFiledSubmittedValue: (value) {},
                                    onValidator: (value) {
                                      return value.isEmpty
                                          ? 'enter password '
                                          : null;
                                    },
                                    enable: true,
                                    keyBoardType: TextInputType.visiblePassword,
                                    hint: "password",
                                    obscureText: true),
                              ],
                            ),
                          )),
                      const SizedBox(
                        width: 8,
                        height: 30,
                      ),
                      RoundButton(
                        title: "Sign Up",
                        loading: provider.loading,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            provider.signUp(context,userNameController.text,
                                emailController.text, passwordController.text);
                          }
                        },
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.loginView);
                        },
                        child: Text.rich(TextSpan(
                            text: "Already have an account?  ",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(fontSize: 15),
                            children: [
                              TextSpan(
                                  text: "Login",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontSize: 15,
                                          decoration:
                                              TextDecoration.underline)),
                            ])),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
