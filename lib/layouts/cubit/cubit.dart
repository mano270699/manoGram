import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/models/post_model.dart';
import 'package:manogram/models/social_message_model.dart';
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
    // if (index == 0) getPosts();
    if (index == 1) getUsers();

    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialLayoutChangBottomNavState());
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  SocialUserModel? userModel;
  void getUser() {
    emit(SocialLayoutGetUserLoadingState());
    FirebaseFirestore.instance.collection('user').doc(uId).get().then((value) {
      print(value.data());
      userModel = SocialUserModel.fromjson(value.data()!);
      print(userModel!.email);
      print(userModel!.uId);
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
    if (text == '' && imagePost == null) {
      print('u can\'t create impty post:)');
      Fluttertoast.showToast(
          msg: 'can\'t create empty post:(',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
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
  }

  void removePostImage() {
    imagePost = null;
    emit(SocialRemovePostImageSucssesState());
  }

  List<PostModel> post = [];
  List<String> postId = [];
  List<int> likes = [];
  void getPosts() {
    post = [];
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postId.add(element.id);
          post.add(PostModel.fromjson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostsSucssesState());
    }).catchError((onError) {
      emit(SocialGetPostsErrorState(onError.toString()));
    });
  }

  void likePost(String idPost) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(idPost)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSucssesState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> socialUserModel = [];
  void getUsers() {
    if (socialUserModel.length == 0)
      FirebaseFirestore.instance.collection('user').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId)
            socialUserModel.add(SocialUserModel.fromjson(element.data()));
        });
        emit(SocialGetAllUsersSucssesState());
      }).catchError((onError) {
        print(onError.toString());
        emit(SocialGetAllUsersErrorState(onError.toString()));
      });
  }

  void sendMessage({
    required String reciverId,
    required String dateTime,
    required String text,
  }) {
    SocialMessageModel messageModel = SocialMessageModel(
      reciverId: reciverId,
      senderId: userModel!.uId,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSucssesState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('user')
        .doc(reciverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSucssesState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<SocialMessageModel> messages = [];
  void getMessages({
    required String reciverId,
  }) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(SocialMessageModel.fromjson(element.data()));
      });
      emit(SocialGetMessageSucssesState());
    });
  }
}
