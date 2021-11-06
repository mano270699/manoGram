import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/models/post_model.dart';
import 'package:manogram/models/social_user_model.dart';
import 'package:manogram/modules/chat/chat_screen.dart';
import 'package:manogram/modules/home/home_screen.dart';
import 'package:manogram/modules/new_post/new_post_screen.dart';
import 'package:manogram/modules/settings/setting_screen.dart';
import 'package:manogram/modules/users/users_screen.dart';
import 'package:manogram/shared/component/constant.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialLayoutStates> {
  SocialCubit() : super(SocialIntialState());
  static SocialCubit get(context) => BlocProvider.of(context);
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
  File? imageCover;

  Future<void> getCoverImage() async {
    final pickedCoverFile =
        // ignore: deprecated_member_use
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedCoverFile != null) {
      imageCover = File(pickedCoverFile.path);
      emit(SocialGetCoverProfileSucssesState());
    } else {
      print('no selected images');
      emit(SocialGetCoverProfileErrorState());
    }
  }

  File? imageProfile;
  final picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedProfileFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedProfileFile != null) {
      imageProfile = File(pickedProfileFile.path);
      emit(SocialGetImageProfileSucssesState());
    } else {
      print('no selected images');
      emit(SocialGetImageProfileErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(SocialUpdateProfileLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(imageProfile!.path).pathSegments.last}')
        .putFile(imageProfile!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        // emit(SocialUploadImageProfileSucssesState());

        updatUserData(name: name, bio: bio, phone: phone, image: imageUrl);
        imageProfile = null;
      }).catchError((onError) {
        emit(SocialUploadImageProfileErrorState());
        print(onError);
      });
    }).catchError((onError) {
      emit(SocialUploadImageProfileErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(SocialUpdateCoverLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(imageCover!.path).pathSegments.last}')
        .putFile(imageCover!)
        .then((value) {
      value.ref.getDownloadURL().then((coverUrl) {
        updatUserData(
          name: name,
          bio: bio,
          phone: phone,
          cover: coverUrl,
        );
        imageCover = null;
      }).catchError((onError) {
        emit(SocialUploadCoverProfileErrorState());
        print(onError);
      });
    }).catchError((onError) {
      emit(SocialUploadCoverProfileErrorState());
    });
  }

  // void updateUser({
  //   required String name,
  //   required String bio,
  //   required String phone,
  // }) {
  //   emit(SocialUserUpdateLoadingState());
  //   if (imageCover != null) {
  //     uploadCoverImage();
  //   } else if (imageProfile != null) {
  //     uploadProfileImage();
  //   } else if (imageCover != null && imageProfile != null) {
  //   } else {
  //     updatUserData(
  //       name: name,
  //       bio: bio,
  //       phone: phone,
  //     );
  //   }
  // }

  void updatUserData({
    required String name,
    required String bio,
    required String phone,
    String? cover,
    String? image,
  }) {
    SocialUserModel user = SocialUserModel(
        name: name,
        phone: phone,
        isEmailVirified: false,
        bio: bio,
        cover: cover ?? userModel!.cover,
        email: userModel!.email,
        uId: userModel!.uId,
        image: image ?? userModel!.image);
    FirebaseFirestore.instance
        .collection('user')
        .doc(user.uId)
        .update(user.toMap())
        .then((value) {
      getUser();
    }).catchError((onError) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? imagePost;

  Future<void> getPostImage() async {
    final pickedPostFile =
        // ignore: deprecated_member_use
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedPostFile != null) {
      imagePost = File(pickedPostFile.path);
      emit(SocialGetPostImageSucssesState());
    } else {
      print('no selected images');
      emit(SocialGetPostImageErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(imagePost!.path).pathSegments.last}')
        .putFile(imagePost!)
        .then((value) {
      value.ref.getDownloadURL().then((postImageUrl) {
        createNewPost(
          text: text,
          dateTime: dateTime,
          imagePost: postImageUrl,
        );
        // imagePost = null;
      }).catchError((onError) {
        emit(SocialCreatePostErrorState());
        print(onError);
      });
    }).catchError((onError) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createNewPost({
    required String text,
    required String dateTime,
    String? imagePost,
  }) {
    PostModel model = PostModel(
      image: userModel!.image,
      dateTime: dateTime,
      name: userModel!.name,
      postImage: imagePost ?? '',
      text: text,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSucssesState());
    }).catchError((onError) {
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage() {
    imagePost = null;
    emit(SocialRemovePostImageSucssesState());
  }

  List<PostModel> post = [];
  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        post.add(PostModel.fromjson(element.data()));
      });
      emit(SocialGetPostsSucssesState());
    }).catchError((onError) {
      emit(SocialGetPostsErrorState(onError.toString()));
    });
  }
}
