import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manogram/shared/style/colors.dart';
import 'package:manogram/shared/style/icon_broken.dart';

PreferredSizeWidget defaultAppBar(
        {String? title, List<Widget>? action, required BuildContext context}) =>
    AppBar(
      title: Text(title!),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(IconBroken.Arrow___Left_2),
      ),
      actions: action,
    );
Widget myDiver() => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    );
Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  @required String? text,
  @required Function()? function,
}) =>
    Container(
      width: width,
      height: 40,

      //margin: const EdgeInsetsDirectional.only(start: 70, end: 70),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text!.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

Widget defaultFormText({
  @required TextEditingController? controller,
  IconData? suffixicon,
  @required TextInputType? type,
  @required String? lable,
  bool isPassword = false,
  Function()? onTap,
  Function()? onChange,
  Function()? suffixOnPressed,
  @required IconData? prefixIcon,
  @required FormFieldValidator? validate,
  ValueChanged? onSubmit,
}) =>
    TextFormField(
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      controller: controller,
      validator: validate,
      cursorColor: defaultColor,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          labelText: lable,
          suffixIcon: IconButton(
            onPressed: suffixOnPressed,
            icon: Icon(suffixicon),
          ),
          prefixIcon: Icon(prefixIcon)),
      onTap: onTap,
    );

void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

showToast({
  @required String? msg,
  Toast toastLength = Toast.LENGTH_SHORT,
  ToastGravity gravity = ToastGravity.BOTTOM,
  @required Color? background,
  Color textColor = Colors.white,
  fontsize = 16.0,
  timeInSecForIosWeb = 1,
}) =>
    Fluttertoast.showToast(
        msg: msg!,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: background,
        textColor: textColor,
        fontSize: fontsize);
