import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:manogram/layouts/cubit/cubit.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/models/social_message_model.dart';
import 'package:manogram/models/social_user_model.dart';

import 'package:manogram/shared/style/colors.dart';
import 'package:manogram/shared/style/icon_broken.dart';

// ignore: must_be_immutable
class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;
  ChatDetailsScreen({Key? key, required this.userModel}) : super(key: key);
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(reciverId: userModel.uId!);
        return BlocConsumer<SocialCubit, SocialLayoutStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userModel.image!),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(userModel.name!),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];
                            if (SocialCubit.get(context).userModel!.uId ==
                                message.senderId)
                              return buildMyMessage(message);
                            return buildMessage(message);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: SocialCubit.get(context).messages.length),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          )),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 10),
                              child: TextFormField(
                                controller: textController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here..',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Jannah',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: defaultColor,
                            child: MaterialButton(
                              minWidth: 1,
                              onPressed: () {
                                var now = DateTime.now();
                                SocialCubit.get(context).sendMessage(
                                    reciverId: userModel.uId!,
                                    dateTime: '${now.toString().split('.')}',
                                    text: textController.text);
                                textController.text = '';
                              },
                              child: Icon(
                                IconBroken.Send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(SocialMessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(10),
                  bottomEnd: Radius.circular(10),
                  topEnd: Radius.circular(10),
                )),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              model.text!,
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: 'Jannah'),
            )),
      );
  Widget buildMyMessage(SocialMessageModel messageModel) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            decoration: BoxDecoration(
                color: defaultColor.withOpacity(0.2),
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(10),
                  bottomStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                )),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              messageModel.text!,
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: 'Jannah'),
            )),
      );
}
