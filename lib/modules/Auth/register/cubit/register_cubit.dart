import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manogram/models/social_user_model.dart';
import 'package:manogram/modules/Auth/register/cubit/register_states.dart';
import 'package:manogram/shared/component/constant.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitalStates());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  // SocialLoginModel loginModel;
  void userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    //print('hello');
    emit(SocialRegisterLoadingStates());
    // SocialRegisterModel RegisterModel;
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        emit(SocialRegisterSuccesStates(value.user!.uid));
        // print(value.user!.email);
        userCreate(
          name: name,
          phone: phone,
          email: email,
          uId: value.user!.uid,
        );
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      emit(SocialRegisterErrorStates(e.toString()));
    }
    // FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(email: email, password: password)
    //     .then((value) {
    //   print(value.user!.email);
    //   print(value.user!.uid);
    //   emit(SocialRegisterSuccesStates());
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(SocialRegisterErrorStates(error.toString()));
    // });
  }

  SocialUserModel? userModel;
  void getUser() {
    emit(SocialLayoutGetUserLoadingState());
    FirebaseFirestore.instance.collection('user').doc(uId).get().then((value) {
      print(value.data());
      userModel = SocialUserModel.fromjson(value.data()!);
      emit(SocialLayoutGetUserSucssesState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialLayoutGetUserErrorState());
    });
  }

  void userCreate({
    required String name,
    required String phone,
    required String email,
    required String uId,
  }) {
    SocialUserModel socialUserModel = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVirified: false,
      bio: 'Write ur bio..',
      cover:
          'https://image.freepik.com/free-photo/i-like-what-i-see-handsome-man-with-stubble-raises-both-index-fingers-points-up_273609-44087.jpg',
      image:
          'https://image.freepik.com/free-photo/i-like-what-i-see-handsome-man-with-stubble-raises-both-index-fingers-points-up_273609-44087.jpg',
    );
    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .set(socialUserModel.toMap())
        .then((value) {
      emit(SocialCreateUserSuccesStates());
    }).catchError((error) {
      emit(SocialCreateUserErrorStates(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  var isPassword = true;
  void changSuffixIcon() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility;
    emit(SocialRegisterfChangePasswordVisabilityStates());
  }
}
