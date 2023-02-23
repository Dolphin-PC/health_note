import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  MyDropdownButton({Key? key, required this.dropdownList, required this.callBackFn}) : super(key: key);

  final List<String> dropdownList;
  final Function callBackFn;

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  // List<String> list = UNIT.values.map((e) => e.name).toList();
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.dropdownList.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          widget.callBackFn(value);
          dropdownValue = value!;
        });
      },
      items: widget.dropdownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
