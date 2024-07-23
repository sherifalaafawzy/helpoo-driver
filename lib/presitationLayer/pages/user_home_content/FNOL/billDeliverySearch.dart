import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';

class billDeliveryLocation extends StatefulWidget {
  billDeliveryLocation({
    super.key,
  });

  @override
  State<billDeliveryLocation> createState() => _billDeliveryLocationState();
}

class _billDeliveryLocationState extends State<billDeliveryLocation> {
  FocusNode? searchFocusNode;

  TextEditingController? fieldTextEditingController;

  saveLatLng(fnolBloc) async {
    LatLng x = await fnolBloc.getLatLang(fnolBloc.fnol.billingAddress);
    fnolBloc.fnol.billingAddressLatLng = x;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return BlocBuilder<FnolBloc, FnolState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Autocomplete<Prediction>(
              displayStringForOption: (x) => x.description ?? '',
              fieldViewBuilder: (BuildContext context,
                  fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                fieldTextEditingController.text =
                    bloc.fnol.billingAddress.isEmpty
                        ? bloc.fnol.currentAddress
                        : bloc.fnol.billingAddress;

                searchFocusNode = fieldFocusNode;
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: appInput.copyWith(
                    filled: true,
                    fillColor: Colors.white,
                    hintMaxLines: 3,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: InputBorder.none,
                  ),
                );
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<Prediction> onSelected,
                Iterable<Prediction> options,
              ) {
                return SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Material(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                        child: Container(
                          width: double.infinity,
                          height: Get.height * 0.64,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(20.0),
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final Prediction option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () async {
                                        onSelected(option);
                                        bloc.fnol.billingAddress =
                                            '${option.structuredFormatting!.mainText}+${option.structuredFormatting!.secondaryText}';
                                        LatLng x = await bloc.getLatLang(
                                            bloc.fnol.billingAddress);
                                        bloc.fnol.billingAddressLatLng = x;
                                        debugPrint('555555555555555');
                                        debugPrint(
                                            '${bloc.fnol.billingAddress}');
                                        sRBloc.billingAddress =
                                            bloc.fnol.billingAddress;
                                        bloc.changeStateTo(billLocationAdded());
                                        navigatorKey.currentContext!.pop;
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                child: Column(
                                                  children: [
                                                    const Icon(
                                                      MdiIcons.mapMarker,
                                                      color: mainColor,
                                                    ),
                                                    Text(
                                                      option.distanceMeters !=
                                                              null
                                                          ? (option.distanceMeters! /
                                                                  1000)
                                                              .toStringAsFixed(
                                                                  1)
                                                          : "",
                                                      style:
                                                          GoogleFonts.tajawal(
                                                        textStyle:
                                                            const TextStyle(
                                                          color: appBlack,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 13.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                                      textStyle:
                                                          const TextStyle(
                                                        color: appBlack,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
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
                                                            style: GoogleFonts
                                                                .tajawal(
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13.0,
                                                              ),
                                                            ),
                                                            maxLines: 1,
                                                            softWrap: false,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
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
                  ),
                );
              },
              optionsMaxHeight: 200,
              optionsBuilder: (textEditingValue) async {
                if (textEditingValue.text == '') {
                  return [];
                }
                if (textEditingValue.text.length > 2) {
                  var res = await bloc.searchPlace(textEditingValue.text);
                  return res.predictions;
                }
                return [];
              },
            ),
          ),
        );
      },
    );
  }
}
