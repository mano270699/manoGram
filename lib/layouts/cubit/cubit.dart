import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/models/social_user_model.dart';
import 'package:manogram/modules/chat/chat_screen.dart';
import 'package:manogram/modules/home/home_screen.dart';
import 'package:manogram/modules/new_post/new_post_screen.dart';
import 'package:manogram/modules/settings/setting_screen.dart';
import 'package:manogram/modules/users/users_screen.dart';
import 'package:manogram/shared/component/constant.dart';

class LayoutCubit extends Cubit<SocialLayoutStates> {
  LayoutCubit() : super(SocialIntialState());
  static LayoutCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingScreen(),
  ];
  void changeBottomNavBar(int index) {
    //if (currentIndex == 1) getSports();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialLayoutChangBottomNavState());
    }
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
      emit(SocialLayoutGetUserErrorState(error.toString()));
    });
  }

  // ignore: unused_field
  XFile? imageprofile;

  final ImagePicker _picker = ImagePicker();
  Future<void> getImageProfile() async {
    // ignore: deprecated_member_use

    // Pick an image
    imageprofile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageprofile != null) {
      imageprofile = XFile(imageprofile!.path);
      emit(SocialGetImageProfileSucssesState());
    } else {
      print('no selected images');
      emit(SocialGetImageProfileErrorState());
    }
  }

  // ignore: unused_field
  File? imageCover;
  final pickerImageCover = ImagePicker();
  Future<void> getCoverImage() async {
    final pickedCoverFile =
        // ignore: deprecated_member_use
        await pickerImageCover.getImage(source: ImageSource.gallery);
    if (pickedCoverFile != null) {
      imageCover = File(pickedCoverFile.path);
      emit(SocialGetImageProfileSucssesState());
    } else {
      print('no selected images');
      emit(SocialGetImageProfileErrorState());
    }
  }
}
