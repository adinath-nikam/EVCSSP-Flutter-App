
import 'package:flutter/material.dart';

import 'ShowSnackBar.dart';

// Custom Text Widget
Widget CustomText(
    {required String text, required double textSize, required Color color, bool? softwrap}) {
  return Text(
    text,
    textAlign: TextAlign.left,
    overflow: TextOverflow.fade,
    softWrap: softwrap,
    style: TextStyle(
      fontSize: textSize,
      fontFamily: "ProductSans-Bold",
      color: color,
    ),
  );
}

Widget CustomButton2(
    {required String text,
      required double buttonSize,
      required BuildContext context,
      required Function function,
      Widget? activity}) {
  return SizedBox(
    height: buttonSize,
    width: double.infinity,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          function();
        },
        child: CustomText(text: text, textSize: 12, color: Colors.white)),
  );
}


// // Terms and Conditions
// Widget TermsAndConditionsText() {
//   void launchTermsConditionsTab() async {
//     try {
//       launch('https://github.com');
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
//
//   return GestureDetector(
//     onTap: () => launchTermsConditionsTab(),
//     child: CustomText(
//         text: "By Singing Up You Agree to our Terms and Conditions",
//         textSize: 12,
//         color: PrimaryDarkColor),
//   );
// }


// Circular Progress Indicator
showLoaderDialog(BuildContext context, String progressIndicatorText) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: CustomText(text: progressIndicatorText, textSize: 14, color: Colors.black)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
