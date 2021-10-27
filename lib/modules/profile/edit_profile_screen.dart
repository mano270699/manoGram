import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manogram/layouts/cubit/cubit.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/shared/component/components.dart';
import 'package:manogram/shared/style/icon_broken.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, SocialLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = LayoutCubit.get(context).userModel;
        var profileImage = LayoutCubit.get(context).imageprofile;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            action: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Update'.toUpperCase(),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      userModel.cover.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileImage == null
                                      ? NetworkImage(
                                          userModel.image.toString(),
                                        )
                                      : ,
                                ),
                              ),
                              CircleAvatar(
                                  radius: 18,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        IconBroken.Camera,
                                        size: 16,
                                      ))),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CircleAvatar(
                          radius: 20,
                          child: IconButton(
                              onPressed: () {}, icon: Icon(IconBroken.Camera))),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                defaultFormText(
                    controller: nameController,
                    type: TextInputType.name,
                    lable: 'Name',
                    prefixIcon: IconBroken.User,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 10,
                ),
                defaultFormText(
                    controller: bioController,
                    type: TextInputType.text,
                    lable: 'Bio',
                    prefixIcon: IconBroken.Info_Circle,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your bio';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
