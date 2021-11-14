import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:manogram/layouts/cubit/cubit.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/models/post_model.dart';
import 'package:manogram/modules/comments/comment_screen.dart';
import 'package:manogram/shared/component/components.dart';
import 'package:manogram/shared/component/shammer.dart';
import 'package:manogram/shared/style/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //https://image.freepik.com/free-photo/portrait-displeased-dark-skinned-woman-smirks-face-looks-with-dissatisfaction-hears-disgusting-story-dislikes-something-feels-awkward_273609-39214.jpg
      body: BlocConsumer<SocialCubit, SocialLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          print('num of post: ${SocialCubit.get(context).post.length}');
          return Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  SocialCubit.get(context).post.length > 0,
              widgetBuilder: (context) => SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 10.0,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image(
                                image: NetworkImage(
                                    "https://image.freepik.com/free-photo/portrait-beautiful-young-woman-gesticulating_273609-41056.jpg"),
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Communicate with friends',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Jannah',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) => buildPostItem(
                              SocialCubit.get(context).post[index],
                              context,
                              index),
                          itemCount: SocialCubit.get(context).post.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        SizedBox(
                          height: 8.0,
                        )
                      ],
                    ),
                  ),
              fallbackBuilder: (context) {
                print('in Home fallbackBuilder');
                if (SocialCubit.get(context).post.length == 0) print('print 0');
                return ShimmerList();
                // ignore: unrelated_type_equality_checks
                // if (SocialCubit.get(context).post.length == 0) {
                //   return Center(
                //       child: Text(
                //     "no Data :(",
                //     style: TextStyle(color: Colors.black),
                //   ));
                // } else {

                // }
              });
        },
      ),
    );
  }

  Widget buildPostItem(PostModel model, context, index) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('${model.image}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${model.name}',
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
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.done,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${model.dateTime}',
                          style: TextStyle(
                            height: 1.4,
                            fontSize: 14,
                            fontFamily: 'Jannah',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconBroken.More_Circle,
                        color: Colors.grey,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                "${model.text}",
                style: TextStyle(
                    height: 1.4,
                    fontSize: 14,
                    fontFamily: 'Jannah',
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Container(
                  width: double.infinity,
                  child: Wrap(children: [
                    Container(
                      height: 20,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 0.1,
                        child: Text(
                          '#Software',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 0.1,
                        child: Text(
                          '#Dart',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 0.1,
                        child: Text(
                          '#Flutter',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              if (model.postImage != '')
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 15),
                  child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage('${model.postImage}'),
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${SocialCubit.get(context).likes[index]}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              IconBroken.Chat,
                              color: Colors.amberAccent,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '0 comments',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        navigateTo(context, CommentScreen());
                      },
                      child: Text(
                        'Write a comment...',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Jannah',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        SocialCubit.get(context)
                            .likePost(SocialCubit.get(context).postId[index]);

                        SocialCubit.get(context).getPosts();
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Like',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
