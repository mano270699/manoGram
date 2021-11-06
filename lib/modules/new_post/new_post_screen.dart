import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manogram/layouts/cubit/cubit.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/shared/component/components.dart';
import 'package:manogram/shared/style/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);
  var textPostController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Create Posts',
                action: [
                  TextButton(
                    onPressed: () {
                      var now = DateTime.now();
                      if (SocialCubit.get(context).imagePost == null) {
                        SocialCubit.get(context).createNewPost(
                            text: textPostController.text,
                            dateTime: now.toString());
                      } else {
                        SocialCubit.get(context).uploadPostImage(
                            text: textPostController.text,
                            dateTime: now.toString());
                      }
                    },
                    child: Text(
                      'Post',
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    if (state is SocialCreatePostLoadingState)
                      LinearProgressIndicator(),
                    if (state is SocialCreatePostLoadingState)
                      SizedBox(
                        height: 10,
                      ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            'https://image.freepik.com/free-photo/pretty-curly-woman-holds-modern-mobile-phone-types-messages-smartphone-device-enjoys-online-communication-downloads-special-app-chatting-smiles-tenderly-isolated-purple-wall_273609-42737.jpg',
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ahmed Mamdouh',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.4,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Jannah',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        scrollPhysics: BouncingScrollPhysics(),
                        minLines: 2,
                        maxLines: 20,
                        controller: textPostController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "What is on your mind...",
                          hintStyle: TextStyle(fontFamily: 'Jannah'),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (SocialCubit.get(context).imagePost != null)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: FileImage(
                                      SocialCubit.get(context).imagePost!),
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircleAvatar(
                                radius: 18,
                                child: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).removePostImage();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 17,
                                  ),
                                )),
                          )
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                SocialCubit.get(context).getPostImage();
                              },
                              child: Row(
                                children: [
                                  Icon(IconBroken.Image_2),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('add photo'),
                                ],
                              )),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {}, child: Text('# tags')),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
