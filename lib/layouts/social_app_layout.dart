import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:manogram/layouts/cubit/cubit.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/modules/new_post/new_post_screen.dart';
import 'package:manogram/shared/component/components.dart';
import 'package:manogram/shared/component/shammer.dart';
import 'package:manogram/shared/style/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, SocialLayoutStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);

        return Conditional.single(
            context: context,
            conditionBuilder: (context) => cubit.userModel != null,
            widgetBuilder: (context) {
              print('isEmailVirified: ${cubit.userModel!.isEmailVirified}');
              if (!cubit.userModel!.isEmailVirified) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'manoGram',
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            IconBroken.Notification,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            IconBroken.Search,
                            color: Colors.black,
                          )),
                    ],
                  ),
                  body: cubit.screens[cubit.currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    items: [
                      BottomNavigationBarItem(
                        label: 'Home',
                        icon: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.amberAccent,
                          child: Icon(
                            IconBroken.Home,
                            size: 25,
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'Chat',
                        icon: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.amberAccent,
                          child: Icon(
                            IconBroken.Chat,
                            size: 25,
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'Post',
                        icon: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.amberAccent,
                          child: Icon(
                            IconBroken.Plus,
                            size: 25,
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'Users',
                        icon: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.amberAccent,
                          child: Icon(
                            IconBroken.User,
                            size: 25,
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'Settings',
                        icon: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.amberAccent,
                          child: Icon(
                            IconBroken.Setting,
                          ),
                        ),
                      ),
                    ],
                    currentIndex: cubit.currentIndex,
                    onTap: (value) {
                      cubit.changeBottomNavBar(value);
                    },
                  ),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    //centerTitle: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Text(
                      'Email Verivication !',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  body: Column(
                    children: [
                      Container(
                        color: Colors.amberAccent.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text('Please verify your email')),
                              SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification()
                                        .then((value) => {
                                              showToast(
                                                  msg: 'check your mail.',
                                                  background: Colors.blue)
                                            })
                                        .catchError((error) {
                                      showToast(
                                          msg: 'Error: ${error.toString()}',
                                          background: Colors.red);
                                    });
                                  },
                                  child: Text(
                                    'Send'.toUpperCase(),
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
            fallbackBuilder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('Loading'),
                  ),
                  body: ShimmerList(),
                ));
      },
    );
  }
}
