import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manogram/layouts/cubit/cubit.dart';
import 'package:manogram/layouts/cubit/state.dart';
import 'package:manogram/layouts/social_app_layout.dart';

import 'package:manogram/modules/Auth/login/login_screen.dart';
import 'package:manogram/shared/bloc_observer.dart';
import 'package:manogram/shared/component/constant.dart';
import 'package:manogram/shared/network/local/cache_helper.dart';

import 'package:manogram/shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  Widget? widget;
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Widget startWidget;
  MyApp({required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LayoutCubit()..getUser(),
        child: BlocConsumer<LayoutCubit, SocialLayoutStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'manoGram',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                appBarTheme: AppBarTheme(
                  titleSpacing: 20.0,
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0.0,
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark),
                  titleTextStyle: TextStyle(
                    fontFamily: 'Jannah',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              home: startWidget,
            );
          },
        ));
  }
}
