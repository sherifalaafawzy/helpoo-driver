import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../submittedAirbadUmages.dart';

class micsImages extends StatelessWidget {
  const micsImages({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Column(
      children: [
        bloc.fnol.airBagImages.length == 0
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Text(
                  "Extra Photos".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
        bloc.fnol.airBagImages.length == 0
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2),
                    itemBuilder: (_, idx) => bloc.fnol.airBagImages.length > idx
                        ? BuildSubmittedAirBagImageView(
                            img: bloc.fnol.airBagImages[idx])
                        : Container(),
                  ),
                ),
              ),
      ],
    );
  }
}
