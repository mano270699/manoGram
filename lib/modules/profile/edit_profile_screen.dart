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
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, SocialLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = LayoutCubit.get(context).userModel;
        var profileImage = LayoutCubit.get(context).imageProfile;
        var imageCover = LayoutCubit.get(context).imageCover;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            action: [
              TextButton(
                onPressed: () {
                  LayoutCubit.get(context).updatUserData(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                child: Text(
                  'Update'.toUpperCase(),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
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
                                      image: imageCover == null
                                          ? NetworkImage(
                                              userModel.cover.toString(),
                                            )
                                          : FileImage(imageCover)
                                              as ImageProvider,
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
                                        : FileImage(profileImage)
                                            as ImageProvider,
                                  ),
                                ),
                                CircleAvatar(
                                    radius: 18,
                                    child: IconButton(
                                        onPressed: () {
                                          LayoutCubit.get(context)
                                              .getProfileImage();
                                        },
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
                            radius: 18,
                            child: IconButton(
                                onPressed: () {
                                  LayoutCubit.get(context).getCoverImage();
                                },
                                icon: Icon(
                                  IconBroken.Camera,
                                ))),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (LayoutCubit.get(context).imageProfile != null ||
                      LayoutCubit.get(context).imageCover != null)
                    Row(
                      children: [
                        if (LayoutCubit.get(context).imageProfile != null)
                          Expanded(
                              child: Column(
                            children: [
                              defaultButton(
                                  text: 'upload profile',
                                  function: () {
                                    LayoutCubit.get(context).uploadProfileImage(
                                        name: nameController.text,
                                        bio: bioController.text,
                                        phone: phoneController.text);
                                  }),
                              if (state is SocialUpdateProfileLoadingState)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: LinearProgressIndicator(),
                                ),
                            ],
                          )),
                        SizedBox(
                          width: 5,
                        ),
                        if (LayoutCubit.get(context).imageCover != null)
                          Expanded(
                              child: Column(
                            children: [
                              defaultButton(
                                  text: 'upload cover',
                                  function: () {
                                    LayoutCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        bio: bioController.text,
                                        phone: phoneController.text);
                                  }),
                              if (state is SocialUpdateCoverLoadingState)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: LinearProgressIndicator(),
                                ),
                            ],
                          )),
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
                  defaultFormText(
                      controller: phoneController,
                      type: TextInputType.phone,
                      lable: 'Phone',
                      prefixIcon: IconBroken.Call,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
