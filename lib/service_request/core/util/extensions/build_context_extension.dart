import 'package:flutter/material.dart';

extension NavigationContext on BuildContext {
  get pop => Navigator.pop(this);

  set pushNamed(String routeName) => Navigator.pushNamed(this, routeName);

  set pushNamedAndRemoveUntil(String routeName) =>
      Navigator.pushNamedAndRemoveUntil(this, routeName, (route) => false);
}
