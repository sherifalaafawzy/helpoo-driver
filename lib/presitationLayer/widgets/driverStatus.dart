import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../dataLayer/models/currentUser.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/driver.dart';

class ToggleStatus extends StatefulWidget {
  const ToggleStatus({
    Key? key,
  }) : super(key: key);

  @override
  State<ToggleStatus> createState() => _ToggleStatusState();
}

class _ToggleStatusState extends State<ToggleStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Card(
        color: CurrentUser.available! ? mainColor : appWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: appGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: () async {
              bool success =
                  await Driver.toggleActiveDriver(CurrentUser.available);
              if (success) {
                if (CurrentUser.available == true) {
                  setState(() {
                    CurrentUser.available = false;
                  });
                } else {
                  setState(() {
                    CurrentUser.available = true;
                  });
                }
              }
            },
            leading: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CurrentUser.available!
                      ? MdiIcons.accountCheckOutline
                      : MdiIcons.accountCancelOutline,
                  color: CurrentUser.available! ? Colors.grey : appWhite,
                ),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  CurrentUser.available! ? "Active".tr : "Inactive".tr,
                  style: TextStyle(
                    color: CurrentUser.available! ? appWhite : Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: SizedBox(),
          ),
        ),
      ),
    );
  }
}
