import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'package:manogram/layouts/social_app_layout.dart';
import 'package:manogram/modules/Auth/login/login_screen.dart';
import 'package:manogram/modules/Auth/register/cubit/register_cubit.dart';
import 'package:manogram/modules/Auth/register/cubit/register_states.dart';
import 'package:manogram/shared/component/components.dart';

import 'package:manogram/shared/network/local/cache_helper.dart';
import 'package:manogram/shared/style/colors.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();
  var phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, states) {
          if (states is SocialRegisterSuccesStates) {
            CacheHelper.saveUserData(
              key: 'uId',
              value: states.uId,
            ).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register".toUpperCase(),
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "Register now to Communicate with friends",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormText(
                            controller: name,
                            type: TextInputType.name,
                            lable: "Name",
                            prefixIcon: Icons.person,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15.0,
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
                            controller: phone,
                            type: TextInputType.phone,
                            lable: "Phone",
                            prefixIcon: Icons.phone_android,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Phone number';
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
                                SocialRegisterCubit.get(context).isPassword,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                print('email: ${email.text}');
                                print(email.text);
                                print('password: ${password.text}');
                                SocialRegisterCubit.get(context).userRegister(
                                  name: name.text.toString(),
                                  phone: phone.text.toString(),
                                  email: email.text.toString(),
                                  password: password.text.toString(),
                                );
                              }
                            },
                            suffixOnPressed: () {
                              SocialRegisterCubit.get(context)
                                  .changSuffixIcon();
                            },
                            lable: "Password",
                            prefixIcon: Icons.lock,
                            suffixicon: SocialRegisterCubit.get(context).suffix,
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
                              state is! SocialRegisterLoadingStates,
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
                                if (formKey.currentState!.validate()) {
                                  SocialRegisterCubit.get(context).userRegister(
                                    name: name.text.toString(),
                                    phone: phone.text.toString(),
                                    email: email.text.toString(),
                                    password: password.text.toString(),
                                  );
                                  SocialRegisterCubit.get(context).getUser();
                                }
                              },
                              child: Text(
                                'Register'.toUpperCase(),
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
                            Text('Already have account!'),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, LoginScreen());
                                },
                                child: Text(
                                  'Login'.toUpperCase(),
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
      ),
    );
  }
}
