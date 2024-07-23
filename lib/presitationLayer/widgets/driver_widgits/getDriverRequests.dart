import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:helpoo/dataLayer/constants/variables.dart';
import '../../../dataLayer/bloc/driver/driver_cubit.dart';
import 'driverRequests.dart';
import 'requestCardWidget/driverRequestCard.dart';

class GetDriverRequests extends StatefulWidget {
  GetDriverRequests({
    Key? key,
  }) : super(key: key);

  @override
  State<GetDriverRequests> createState() => _GetDriverRequestsState();
}

class _GetDriverRequestsState extends State<GetDriverRequests> {
  DriverRequests driver = DriverRequests();

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<DriverCubit>(context);
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        return Expanded(
            child: cubit.driverRequests.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: cubit.driverRequests.length,
                    itemBuilder: (BuildContext context, int i) {
                      cubit.req = cubit.driverRequests[i];
                      return driverRequestCard(
                        cubit.req!,
                      );
                    },
                  )
                : state is DriverGetDriverRequestsLoading
                    ? CupertinoActivityIndicator(
                        color: mainColor,
                      )
                    : Center(
                        child: Container(
                          child: Text(
                            "You Have No Requests For Now".tr,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ));
      },
    );
    // : waitingWidget());
  }
}
