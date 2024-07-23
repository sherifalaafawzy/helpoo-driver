import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class fNOLCarCard extends StatelessWidget {
  final bool isClickable;
  const fNOLCarCard(
    this.isClickable, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: mainColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: !isClickable
                ? null
                : bloc.fnol.selectedCar?.id == bloc.fnol.selectedCar!.id
                    ? null
                    : () {
                        bloc.fnol.selectedCar = bloc.fnol.selectedCar!;
                        Get.back();
                      },
            isThreeLine: true,
            leading: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  MdiIcons.car,
                  color: appBlack,
                ),
              ],
            ),
            title: Text(
              bloc.fnol.selectedCar!.manufacture!.name +
                  " - " +
                  bloc.fnol.selectedCar!.model!.name,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bloc.fnol.selectedCar!.year.toString() +
                      " - " +
                      bloc.fnol.selectedCar!.color!,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Text(
                  bloc.fnol.selectedCar!.plateNo ?? "",
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
