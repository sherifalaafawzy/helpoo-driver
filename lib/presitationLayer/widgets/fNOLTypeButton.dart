import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/FNOLType.dart';
import 'round_button.dart';

class typeButton extends StatefulWidget {
  final FNOLType type;
  const typeButton(this.type, {Key? key}) : super(key: key);

  @override
  State<typeButton> createState() => typeButtonState();
}

class typeButtonState extends State<typeButton> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    void toggleAccidentType(FNOLType type) {
      if (type.id == bloc.fnol.fullCarAccident.id) {
        if (bloc.fnol.selectedTypes.contains(bloc.fnol.fullCarAccident)) {
          setState(() {
            bloc.fnol.selectedTypes = [];
            bloc.changeStateTo(unSelectedBox());

            // bloc.emit(unSelectedBox());
          });
        } else {
          setState(() {
            bloc.fnol.selectedTypes = [bloc.fnol.fullCarAccident];
            bloc.changeStateTo(unSelectedBox());
            bloc.changeStateTo(selectedBox());

            // bloc.emit(unSelectedBox());
            // bloc.emit(selectedBox());
          });
        }
      } else {
        if (bloc.fnol.selectedTypes.contains(type)) {
          setState(() {
            bloc.fnol.selectedTypes.remove(type);
            bloc.fnol.selectedTypes.remove(bloc.fnol.fullCarAccident);
            bloc.changeStateTo(unSelectedBox());

            // bloc.emit(unSelectedBox());
          });
        } else {
          setState(() {
            bloc.fnol.selectedTypes.add(type);
            bloc.changeStateTo(selectedBox());

            // bloc.emit(selectedBox());
          });
        }
      }
    }

    return BlocBuilder<FnolBloc, FnolState>(
      builder: (context, state) {
        return SizedBox(
          width: 156,
          height: 47,
          child: bloc.fnol.selectedTypes.contains(widget.type) ||
                  bloc.fnol.selectedTypes.contains(bloc.fnol.fullCarAccident)
              ? RoundButtonChecked(
                  onPressed: () {
                    toggleAccidentType(widget.type);
                  },
                  padding: false,
                  text: widget.type.name,
                  color: mainColor)
              : RoundButtonUnchecked(
                  onPressed: () {
                    toggleAccidentType(widget.type);
                  },
                  padding: false,
                  text: widget.type.name,
                  color: mainColor),
        );
      },
    );
  }
}
