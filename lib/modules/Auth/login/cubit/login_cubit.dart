import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manogram/models/login_model.dart';
import 'package:manogram/modules/Auth/login/cubit/login_states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitalStates());
  static SocialLoginCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changSuffixIcon() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility;
    emit(SocialChangePasswordVisabilityStates());
  }

  SocialLoginModel? socialLoginModel;
  void userLogin({required String email, required String password}) {
    emit(SocialLoginLoadingStates());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(SocialLoginSuccesStates(value.user!.uid));
    }).catchError((error) {
      emit(SocialLoginErrorStates(error.toString()));
    });
  }
}
