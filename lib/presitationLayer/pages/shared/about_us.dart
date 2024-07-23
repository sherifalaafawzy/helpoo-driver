import 'package:flutter/material.dart';
import '../../../dataLayer/constants/variables.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appWhite,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                '''
هلبو هو تطبيق سهل الاستخدام تم تصميمه لمساعدة مالكي السيارات في مصر على الوصول الفوري إلى أسطولنا من أوناش الإنقاذ للمساعدة على الطريق ، والميني فان ، والسكوترز.

أينما كنت ، استخدم تطبيقنا أو اتصل على الخط الساخن 17000 على مدار الساعة طوال أيام الأسبوع للحصول على إنقاذ فوري لسيارتك
''',
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                '''
helpoo is a user friendly app that is designed to to help car owners in Egypt to have immediate access to our fleet of Road Assist Winch Trucks, Mini Vans, and Scooters.

Wherever you are, use our app or call our 24/7 hotline 17000 to get immediate rescue for your car.
''',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
