import 'package:flutter/material.dart';

class SetCard extends StatefulWidget {
  const SetCard({Key? key, required this.setName, required this.setCount}) : super(key: key);

  final String setName, setCount;

  @override
  State<SetCard> createState() => _SetCardState();
}

class _SetCardState extends State<SetCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool) {
                setState(() => isChecked = bool!);
              },
            ),
            Text(widget.setName),
          ],
        ),
        Text(widget.setCount),
      ],
    );
  }
}
