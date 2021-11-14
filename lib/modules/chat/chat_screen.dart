import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:manogram/layouts/cubit/cubit.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/models/social_user_model.dart';
import 'package:manogram/modules/chat_details/chat_details_screen.dart';
import 'package:manogram/shared/component/components.dart';
import 'package:manogram/shared/component/shammer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).socialUserModel;
        return Conditional.single(
            context: context,
            conditionBuilder: (context) => model.length > 0,
            widgetBuilder: (context) => ListView.separated(
                itemBuilder: (context, index) =>
                    buiildChatItem(model[index], context),
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: model.length),
            fallbackBuilder: (context) => ShimmerList());
      },
    );
  }

  Widget buiildChatItem(SocialUserModel model, context) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(userModel: model));
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${model.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jannah',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
}
