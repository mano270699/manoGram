import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manogram/layouts/social_app_layout.dart';
import 'package:manogram/modules/Auth/login/cubit/login_cubit.dart';

import 'package:manogram/modules/Auth/login/cubit/login_states.dart';

import 'package:manogram/modules/Auth/register/social_register_screen.dart';
import 'package:manogram/shared/component/components.dart';
import 'package:manogram/shared/network/local/cache_helper.dart';
import 'package:manogram/shared/style/colors.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  // const LoginScreen();

  var email = TextEditingController();
  var password = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        builder: (context, states) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOGIN",
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "Login now to Communicate with friends",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormText(
                            controller: email,
                            type: TextInputType.emailAddress,
                            lable: "Email Address",
                            prefixIcon: Icons.email,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please enter email address';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormText(
                            controller: password,
                            type: TextInputType.visiblePassword,
                            isPassword:
                                SocialLoginCubit.get(context).isPassword,
                            onSubmit: (value) {
                              if (formkey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                  email: email.text.toString(),
                                  password: password.text.toString(),
                                );
                              }
                            },
                            suffixOnPressed: () {
                              SocialLoginCubit.get(context).changSuffixIcon();
                            },
                            lable: "Password",
                            prefixIcon: Icons.lock,
                            suffixicon: SocialLoginCubit.get(context).suffix,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please enter password text';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        Conditional.single(
                          conditionBuilder: (context) =>
                              states is! SocialLoginLoadingStates,
                          context: context,
                          widgetBuilder: (context) => Container(
                            width: double.infinity,
                            height: 50,
                            //margin: const EdgeInsetsDirectional.only(start: 70, end: 70),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: MaterialButton(
                              color: defaultColor,
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  SocialLoginCubit.get(context).userLogin(
                                    email: email.text,
                                    password: password.text,
                                  );
                                }
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          fallbackBuilder: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                child: Text(
                                  'Register'.toUpperCase(),
                                  style: TextStyle(color: defaultColor),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, states) {
          if (states is SocialLoginErrorStates) {
            Fluttertoast.showToast(
                msg: states.error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (states is SocialLoginSuccesStates) {
            CacheHelper.saveUserData(
              key: 'uId',
              value: states.uId,
            ).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
      ),
    );
  }
}
