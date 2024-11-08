import 'package:flutter/material.dart';

class RoleModalSheet extends StatelessWidget {
  RoleModalSheet({
    super.key,
    required this.onChange,
  });

  final ValueChanged<String> onChange;

  static Future show(BuildContext context, ValueChanged<String> onChange) async {
    return await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return RoleModalSheet(onChange: onChange);
      },
    );
  }

  final List<String> _roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _roles.map((role) {
          return ListTile(
            title: Text(role),
            onTap: () {
              onChange(role);
              Navigator.pop(context); // Close the bottom sheet
            },
          );
        }).toList(),
      ),
    );
  }
}
