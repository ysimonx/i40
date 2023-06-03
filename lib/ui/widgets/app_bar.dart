import 'package:flutter/material.dart';

// cf https://stackoverflow.com/a/64147831
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text('Service App'));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
