// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../../dataLayer/constants/variables.dart';

class locationName extends StatefulWidget {
  String fnolType;

  locationName({
    super.key,
    required,
    required this.fnolType,
  });

  @override
  State<locationName> createState() => locationNameState();
}

class locationNameState extends State<locationName> {
  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Stack(
      children: [
        TextFormField(
          validator: (v) {
            if (v == null) {
              return "Required".tr;
            }

            return null;
          },
          onChanged: (v) {
            setState(() {
              if (widget.fnolType == "supplement") {
                bloc.fnol.supplementLocation = v;
              } else if (widget.fnolType == "resurvey") {
                bloc.fnol.resurveyLocation = v;
              } else if (widget.fnolType == "aRepair") {
                bloc.fnol.aRepairLocation = v;
              } else if (widget.fnolType == "rightSave") {
                bloc.fnol.rightSaveLocation = v;
              } else {
                bloc.fnol.bRepairLocation = v;
              }
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsetsDirectional.only(
              start: 110.0,
            ),
            filled: true,
            fillColor: Colors.white,
            hintMaxLines: 3,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: InputBorder.none,
          ),
        ),
        Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xffc8ddd0),
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(10.0),
              bottomStart: Radius.circular(10.0),
            ),
          ),
          // width: 100,
          child: Center(
            child: Text(
              "repair location name".tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 13.0,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );

    // return ListTile(
    //   contentPadding: const EdgeInsets.all(0),
    //   leading: Container(
    //     decoration: BoxDecoration(
    //       color: Color(0xffc8ddd0),
    //       borderRadius: CurrentUser.isArabic
    //           ? BorderRadius.only(
    //               topRight: Radius.circular(10.0),
    //               bottomRight: Radius.circular(10.0),
    //             )
    //           : BorderRadius.only(
    //               topLeft: Radius.circular(10.0),
    //               bottomLeft: Radius.circular(10.0),
    //             ),
    //     ),
    //     width: 100,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.max,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(2.0),
    //           child: Text(
    //             "Repair Location Name".tr,
    //             style: GoogleFonts.tajawal(
    //               textStyle: const TextStyle(
    //                 color: appBlack,
    //                 fontWeight: FontWeight.w700,
    //                 fontStyle: FontStyle.normal,
    //                 fontSize: 13.0,
    //               ),
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   title:Container(
    //           color: white,
    //           child: TextFormField(
    //             textAlign: TextAlign.center,
    //             validator: (v) {
    //               if (v == null) {
    //                 return "Required".tr;
    //               }
    //
    //               return null;
    //             },
    //             onChanged: (v) {
    //               setState(() {
    //                 if (widget.fnolType == "supplement") {
    //                   bloc.fnol.supplementLocation = v;
    //                 } else if (widget.fnolType == "resurvey") {
    //                   bloc.fnol.resurveyLocation = v;
    //                 } else if (widget.fnolType == "aRepair") {
    //                   bloc.fnol.aRepairLocation = v;
    //                 } else if (widget.fnolType == "rightSave") {
    //                   bloc.fnol.rightSaveLocation = v;
    //                 } else {
    //                   bloc.fnol.bRepairLocation = v;
    //                 }
    //               });
    //             },
    //             decoration: const InputDecoration(
    //               counterText: '',
    //               enabledBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(12),
    //                 ),
    //                 borderSide: BorderSide(
    //                   color: Colors.grey,
    //                   width: 1,
    //                 ),
    //               ),
    //               contentPadding: EdgeInsets.all(8),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(12),
    //                 ),
    //                 borderSide: BorderSide(
    //                   color: Colors.grey,
    //                   width: 1,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         )
    // );
  }
}
