import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dataLayer/bloc/app/app_bloc.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/model.dart';
import '../../dataLayer/models/vehicle.dart';

class modelInput extends StatefulWidget {
  final Model? value;
  final bool? enable;
  final Function(Model) callbackfun;

  modelInput({
    Key? key,
    this.value,
    required this.callbackfun,
    required this.enable,
  }) : super(key: key);

  @override
  State<modelInput> createState() => modelInputstate();
}

class modelInputstate extends State<modelInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppBlocState>(builder: (context, state) {
      return Theme(
        data: ThemeData(canvasColor: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              text: TextSpan(
                text: 'model'.tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: " *",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                  color: mainColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Vehicle.returnedSelectedModel
                    ? ConditionalBuilder(
                        condition: Vehicle.modelList.length != 0,
                        builder: (context) => DropdownButtonFormField(
                        
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                            border: InputBorder.none,
                          ),
                          hint: Text(
                            widget.value != null ? widget.value!.name : "",
                            style: TextStyle(fontSize: 14),
                          ),
                       
                          isExpanded: true,
                          items: Vehicle.modelList
                              .map((item) => DropdownMenuItem<Model>(
                                    value: item,
                                    child: Text(
                                      item.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: widget.enable!
                              ? (Model? v) => widget.callbackfun(v!)
                              : null,
                        ),
                        fallback: (context) => CupertinoActivityIndicator(
                          color: mainColor,
                        ),
                      )
                    : DropdownButtonFormField(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'please select model'.tr;
                          }
                          return null;
                        },
                        hint: Text(
                          widget.value != null ? widget.value!.name : "",
                          style: TextStyle(fontSize: 14),
                        ),
                        // icon: Icon(
                        //   Icons.arrow_drop_down,
                        //   color: Colors.black45,
                        // ),
                        // iconSize: 30,
                        // buttonHeight: 60,
                        // buttonPadding: EdgeInsets.only(left: 20, right: 10),
                        // dropdownDecoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(15),
                        // ),
                        // value: widget.value,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        items: null,
                        // Vehicle.modelList
                        //     .map((item) => DropdownMenuItem<Model>(
                        //           value: item,
                        //           child: Text(
                        //             item.name,
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //             ),
                        //           ),
                        //         ))
                        // .toList(),
                        onChanged: null,
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
