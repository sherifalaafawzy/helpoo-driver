import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';

class PrimarySearchField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool isOrigin;

  const PrimarySearchField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
    this.isOrigin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewServiceRequestBloc, NewServiceRequestState>(
      builder: (context, state) {
        return Container(
          height: 40,
          width: double.infinity,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: double.infinity,
                width: 120,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Center(
                  child: Text(
                    title.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  onTap: onTap,
                  controller: controller,
                  onChanged: onChanged,
                  maxLines: 1,
                  enabled: sRBloc.serviceRequestModel == null,
                  decoration: InputDecoration(
                    hintText: hint.tr,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: sRBloc.serviceRequestModel == null ? controller != null
                        ? controller!.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller!.clear();

                                  debugPrint(
                                      'countOpenedBottomSheets: ${sRBloc.countOpenedBottomSheets}');

                                  for (int i = 0;
                                      i < sRBloc.countOpenedBottomSheets;
                                      i++) {
                                    context.pop;
                                  }

                                  sRBloc.clearFields(
                                    origin: isOrigin,
                                  );
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).primaryColor,
                                ))
                            : null
                        : null : null,
                    hintStyle: GoogleFonts.tajawal(
                      textStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                      ),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8.0),
                  ),
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
