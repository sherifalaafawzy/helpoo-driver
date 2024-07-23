import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';


class MainScaffold extends StatelessWidget {
  final Widget scaffold;

  const MainScaffold({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewServiceRequestBloc, NewServiceRequestState>(
      builder: (context, state) {
        return scaffold;

        return Directionality(
          textDirection: NewServiceRequestBloc.get(context).isRtl
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: scaffold,
        );
      },
    );
  }
}
