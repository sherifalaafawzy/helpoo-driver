
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class cameraWaitinginit extends StatelessWidget {
  final Function init;
  const cameraWaitinginit({
    Key? key,
    required this.init,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.height * .5,
        child: Column(
          children: [
            Text(
              "Please wait".tr,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            TextButton(
                child: Text(
                  "init".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  init();
                })
          ],
        ),
      ),
    );
  }
}
