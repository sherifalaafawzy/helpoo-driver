// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpoo/service_request/core/di/injection.dart';
import 'package:helpoo/service_request/core/network/repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../../dataLayer/constants/variables.dart';

class inspectionAddressSearch extends StatefulWidget {
  final String fnolType;
  final TextEditingController currentLocCntl;
  inspectionAddressSearch(
      {super.key, required this.currentLocCntl, required this.fnolType});

  @override
  State<inspectionAddressSearch> createState() =>
      _inspectionAddressSearchState();
}

class _inspectionAddressSearchState extends State<inspectionAddressSearch> {
  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var fnolBloc = BlocProvider.of<FnolBloc>(context);

    saveLatLng(type) async {
      if (type == "supplement") {
        LatLng x = await fnolBloc.getLatLang(fnolBloc.fnol.supplementAddress!);
        fnolBloc.fnol.supplementAddressLatLng = x;
      } else if (type == "resurvey") {
        LatLng x = await fnolBloc.getLatLang(fnolBloc.fnol.resurveyAddress!);
        fnolBloc.fnol.resurveyAddressLatLng = x;
      } else if (type == "aRepair") {
        LatLng x = await fnolBloc.getLatLang(fnolBloc.fnol.aRepairAddress!);
        fnolBloc.fnol.aRepairAddressLatLng = x;
      } else if (type == "rightSave") {
        LatLng x = await fnolBloc.getLatLang(fnolBloc.fnol.rightSaveAddress!);
        fnolBloc.fnol.rightSaveAddressLatLng = x;
      } else {
        LatLng x =
            await fnolBloc.getLatLang(fnolBloc.fnol.beforeRepairAddress!);
        fnolBloc.fnol.beforeRepairAddressLatLng = x;
      }
    }

    bool isLoading = false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: Get.height * .05,
          child: Autocomplete<Prediction>(
            displayStringForOption: (x) => x.description ?? '',
            fieldViewBuilder: (BuildContext context, fieldTextEditingController,
                searchFocusNode, VoidCallback onFieldSubmitted) {
              fieldTextEditingController.text = fnolBloc.address;

              if (widget.fnolType == "supplement") {
                fnolBloc.fnol.supplementAddress =
                    fieldTextEditingController.text;
                saveLatLng(widget.fnolType);
              } else if (widget.fnolType == "resurvey") {
                fnolBloc.fnol.resurveyAddress = fieldTextEditingController.text;
                saveLatLng(widget.fnolType);
              } else if (widget.fnolType == "aRepair") {
                fnolBloc.fnol.aRepairAddress = fieldTextEditingController.text;
                saveLatLng(widget.fnolType);
              } else if (widget.fnolType == "rightSave") {
                fnolBloc.fnol.rightSaveAddress =
                    fieldTextEditingController.text;
                saveLatLng(widget.fnolType);
              } else {
                fnolBloc.fnol.beforeRepairAddress =
                    fieldTextEditingController.text;
                saveLatLng(widget.fnolType);
              }
              return Stack(
                children: [
                  TextField(
                    controller: fieldTextEditingController,
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsetsDirectional.only(
                        start: 110.0,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintMaxLines: 3,
                      suffixIcon: IconButton(
                        onPressed: () {
                          fieldTextEditingController.clear();
                        },
                        icon: Icon(
                          MdiIcons.close,
                          color: appBlack,
                        ),
                      ),
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
                        "Repair Location".tr,
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
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<Prediction> onSelected,
              Iterable<Prediction> options,
            ) {
              return SizedBox(
                width: Get.width,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    child: Container(
                      width: Get.width,
                      color: appWhite,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(30.0),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final Prediction option =
                                    options.elementAt(index);

                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    debugPrint('yarb --- $isLoading');

                                    searchFocusNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(searchFocusNode);
                                    // debugPrint(
                                    //     'clients is = ${fnolBloc.request.clientLongitude}');
                                    onSelected(option);

                                    debugPrint('yarb ---');

                                    final result =
                                        await sl<Repository>().getPlaceDetails(
                                      placeId: option.placeId!,
                                    );

                                    result.fold(
                                      (failure) {
                                        debugPrint(failure.toString());
                                      },
                                      (data) {
                                        fnolBloc.mapController!.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                              target: LatLng(
                                                data.result.latitude.toDouble(),
                                                data.result.longitude
                                                    .toDouble(),
                                              ),
                                              zoom: 15.0,
                                            ),
                                          ),
                                        );

                                        setState(() {
                                          isLoading = false;
                                        });

                                        debugPrint('yarb --- $isLoading');

                                        // fnolBloc.googleMapsModel.markers.add(
                                        //   Marker(
                                        //     markerId: MarkerId(
                                        //       option.placeId!,
                                        //     ),
                                        //     position: LatLng(
                                        //       data.result.latitude.toDouble(),
                                        //       data.result.longitude.toDouble(),
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    );

                                    // if (beforeRepair) {
                                    if (widget.fnolType == "supplement") {
                                      fnolBloc.fnol.supplementAddress =
                                          '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                                      LatLng x = await fnolBloc.getLatLang(
                                          fnolBloc.fnol.supplementAddress!);
                                      fnolBloc.fnol.supplementAddressLatLng = x;
                                    } else if (widget.fnolType == "resurvey") {
                                      fnolBloc.fnol.resurveyAddress =
                                          '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                                      LatLng x = await fnolBloc.getLatLang(
                                          fnolBloc.fnol.resurveyAddress!);
                                      fnolBloc.fnol.resurveyAddressLatLng = x;
                                    } else if (widget.fnolType == "aRepair") {
                                      fnolBloc.fnol.aRepairAddress =
                                          '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                                      LatLng x = await fnolBloc.getLatLang(
                                          fnolBloc.fnol.aRepairAddress!);
                                      fnolBloc.fnol.aRepairAddressLatLng = x;
                                    } else if (widget.fnolType == "rightSave") {
                                      fnolBloc.fnol.rightSaveAddress =
                                          '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                                      LatLng x = await fnolBloc.getLatLang(
                                          fnolBloc.fnol.rightSaveAddress!);
                                      fnolBloc.fnol.rightSaveAddressLatLng = x;
                                    } else {
                                      fnolBloc.fnol.beforeRepairAddress =
                                          '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                                      LatLng x = await fnolBloc.getLatLang(
                                          fnolBloc.fnol.beforeRepairAddress!);
                                      fnolBloc.fnol.beforeRepairAddressLatLng =
                                          x;
                                    }
                                    //   } else {
                                    //     fnolBloc.fnol.billingAddress =
                                    //         '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                                    //     LatLng x = await fnolBloc.getLatLang(
                                    //         fnolBloc.fnol.billingAddress);
                                    //     fnolBloc.fnol.billingAddressLatLng = x;
                                    // }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 50,
                                            child: Column(children: [
                                              const Icon(
                                                MdiIcons.mapMarker,
                                                color: mainColor,
                                              ),
                                              Text(
                                                option.distanceMeters != null
                                                    ? (option.distanceMeters! /
                                                            1000)
                                                        .toStringAsFixed(1)
                                                    : "",
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: appBlack,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                option.structuredFormatting!
                                                    .mainText
                                                    .toString(),
                                                style: GoogleFonts.tajawal(
                                                  textStyle: const TextStyle(
                                                    color: appBlack,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ),
                                              option.structuredFormatting!
                                                          .secondaryText !=
                                                      null
                                                  ? SizedBox(
                                                      child: Text(
                                                        option
                                                            .structuredFormatting!
                                                            .secondaryText
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.tajawal(
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ))
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.grey[300],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            optionsBuilder: (textEditingValue) async {
              if (textEditingValue.text == '') {
                return [];
              }
              if (textEditingValue.text.length > 2) {
                var res = await fnolBloc.searchPlace(textEditingValue.text);
                return res.predictions;
              }
              return [];
            },
          ),
        ),
      
      
        if (isLoading) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: LinearProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ],
    );

    // ListTile(
    //   contentPadding: const EdgeInsets.all(0),
    //   leading: Container(
    //     decoration: BoxDecoration(
    //       color: Color(0xffc8ddd0),
    //       borderRadius: CurrentUser.isArabic
    //           ? BorderRadius.only(
    //               topRight: Radius.circular(12.0),
    //               bottomRight: Radius.circular(12.0),
    //             )
    //           : BorderRadius.only(
    //               topLeft: Radius.circular(12.0),
    //               bottomLeft: Radius.circular(12.0),
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
    //             "Repair Location".tr,
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
    //   title: Autocomplete<Prediction>(
    //     displayStringForOption: (x) => x.description ?? '',
    //     fieldViewBuilder: (BuildContext context, fieldTextEditingController,
    //         searchFocusNode, VoidCallback onFieldSubmitted) {
    //       fieldTextEditingController.text = fnolBloc.address;

    //       if (fnolType == "supplement") {
    //         fnolBloc.fnol.supplementAddress = fieldTextEditingController.text;
    //         saveLatLng(fnolType);
    //       } else if (fnolType == "resurvey") {
    //         fnolBloc.fnol.resurveyAddress = fieldTextEditingController.text;
    //         saveLatLng(fnolType);
    //       } else if (fnolType == "aRepair") {
    //         fnolBloc.fnol.aRepairAddress = fieldTextEditingController.text;
    //         saveLatLng(fnolType);
    //       } else if (fnolType == "rightSave") {
    //         fnolBloc.fnol.rightSaveAddress = fieldTextEditingController.text;
    //         saveLatLng(fnolType);
    //       } else {
    //         fnolBloc.fnol.beforeRepairAddress = fieldTextEditingController.text;
    //         saveLatLng(fnolType);
    //       }
    //       return TextField(
    //         controller: fieldTextEditingController,
    //         focusNode: searchFocusNode,
    //         decoration: appInput.copyWith(
    //           filled: true,
    //           fillColor: Colors.white,
    //           hintMaxLines: 3,
    //           border: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(10.0),
    //           ),
    //           errorBorder: InputBorder.none,
    //         ),
    //       );
    //     },
    //     optionsViewBuilder: (BuildContext context,
    //         AutocompleteOnSelected<Prediction> onSelected,
    //         Iterable<Prediction> options) {
    //       return SizedBox(
    //         width: Get.width,
    //         child: Align(
    //           alignment: Alignment.topCenter,
    //           child: Material(
    //             child: Container(
    //               width: Get.width,
    //               color: appWhite,
    //               child: Column(
    //                 children: [
    //                   Expanded(
    //                     child: ListView.builder(
    //                       padding: const EdgeInsets.all(30.0),
    //                       itemCount: options.length,
    //                       itemBuilder: (context, index) {
    //                         final Prediction option = options.elementAt(index);
    //                         return GestureDetector(
    //                           onTap: () async {
    //                             searchFocusNode.unfocus();
    //                             FocusScope.of(context)
    //                                 .requestFocus(searchFocusNode);
    //                             // debugPrint(
    //                             //     'clients is = ${fnolBloc.request.clientLongitude}');
    //                             onSelected(option);

    //                             // if (beforeRepair) {
    //                             if (fnolType == "supplement") {
    //                               fnolBloc.fnol.supplementAddress =
    //                                   '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
    //                               LatLng x = await fnolBloc.getLatLang(
    //                                   fnolBloc.fnol.supplementAddress!);
    //                               fnolBloc.fnol.supplementAddressLatLng = x;
    //                             } else if (fnolType == "resurvey") {
    //                               fnolBloc.fnol.resurveyAddress =
    //                                   '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
    //                               LatLng x = await fnolBloc.getLatLang(
    //                                   fnolBloc.fnol.resurveyAddress!);
    //                               fnolBloc.fnol.resurveyAddressLatLng = x;
    //                             } else if (fnolType == "aRepair") {
    //                               fnolBloc.fnol.aRepairAddress =
    //                                   '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
    //                               LatLng x = await fnolBloc.getLatLang(
    //                                   fnolBloc.fnol.aRepairAddress!);
    //                               fnolBloc.fnol.aRepairAddressLatLng = x;
    //                             } else if (fnolType == "rightSave") {
    //                               fnolBloc.fnol.rightSaveAddress =
    //                                   '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
    //                               LatLng x = await fnolBloc.getLatLang(
    //                                   fnolBloc.fnol.rightSaveAddress!);
    //                               fnolBloc.fnol.rightSaveAddressLatLng = x;
    //                             } else {
    //                               fnolBloc.fnol.beforeRepairAddress =
    //                                   '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
    //                               LatLng x = await fnolBloc.getLatLang(
    //                                   fnolBloc.fnol.beforeRepairAddress!);
    //                               fnolBloc.fnol.beforeRepairAddressLatLng = x;
    //                             }
    //                             //   } else {
    //                             //     fnolBloc.fnol.billingAddress =
    //                             //         '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
    //                             //     LatLng x = await fnolBloc.getLatLang(
    //                             //         fnolBloc.fnol.billingAddress);
    //                             //     fnolBloc.fnol.billingAddressLatLng = x;
    //                             // }
    //                           },
    //                           child: Column(
    //                             children: [
    //                               Row(
    //                                 children: [
    //                                   SizedBox(
    //                                     width: 50,
    //                                     child: Column(children: [
    //                                       const Icon(
    //                                         MdiIcons.mapMarker,
    //                                         color: mainColor,
    //                                       ),
    //                                       Text(
    //                                         option.distanceMeters != null
    //                                             ? (option.distanceMeters! /
    //                                                     1000)
    //                                                 .toStringAsFixed(1)
    //                                             : "",
    //                                         style: GoogleFonts.tajawal(
    //                                           textStyle: const TextStyle(
    //                                             color: appBlack,
    //                                             fontWeight: FontWeight.w700,
    //                                             fontStyle: FontStyle.normal,
    //                                             fontSize: 13.0,
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ]),
    //                                   ),
    //                                   Expanded(
    //                                       child: Column(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.start,
    //                                     children: [
    //                                       Text(
    //                                         option
    //                                             .structuredFormatting!.mainText
    //                                             .toString(),
    //                                         style: GoogleFonts.tajawal(
    //                                           textStyle: const TextStyle(
    //                                             color: appBlack,
    //                                             fontWeight: FontWeight.w700,
    //                                             fontStyle: FontStyle.normal,
    //                                             fontSize: 13.0,
    //                                           ),
    //                                         ),
    //                                       ),
    //                                       option.structuredFormatting!
    //                                                   .secondaryText !=
    //                                               null
    //                                           ? SizedBox(
    //                                               child: Text(
    //                                                 option.structuredFormatting!
    //                                                     .secondaryText
    //                                                     .toString(),
    //                                                 style: GoogleFonts.tajawal(
    //                                                   textStyle:
    //                                                       const TextStyle(
    //                                                     color: Colors.black,
    //                                                     fontWeight:
    //                                                         FontWeight.w700,
    //                                                     fontStyle:
    //                                                         FontStyle.normal,
    //                                                     fontSize: 13.0,
    //                                                   ),
    //                                                 ),
    //                                                 maxLines: 1,
    //                                                 softWrap: false,
    //                                                 overflow: TextOverflow.fade,
    //                                               ),
    //                                             )
    //                                           : Container(),
    //                                     ],
    //                                   ))
    //                                 ],
    //                               ),
    //                               Divider(
    //                                 color: Colors.grey[300],
    //                               ),
    //                             ],
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //     optionsBuilder: (textEditingValue) async {
    //       if (textEditingValue.text == '') {
    //         return [];
    //       }
    //       if (textEditingValue.text.length > 2) {
    //         var res = await fnolBloc.searchPlace(textEditingValue.text);
    //         return res.predictions;
    //       }
    //       return [];
    //     },
    //   ),
    // );
  }
}
