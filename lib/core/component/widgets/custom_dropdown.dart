import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatelessWidget {
  final List<dynamic> list;
  final dynamic value;
  final ValueChanged<dynamic> onchangeValue;

  const CustomDropdownWidget({
    Key? key,
    required this.list,
    required this.value,
    required this.onchangeValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      value: value,
      items: list.map((item) {
        return DropdownMenuItem<dynamic>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onchangeValue,
    );
  }
}
