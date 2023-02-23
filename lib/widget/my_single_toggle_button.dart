import 'package:flutter/material.dart';

const List<Widget> isCount = <Widget>[Text('제외'), Text('포함')];

class MySingleToggleButton extends StatefulWidget {
  MySingleToggleButton({Key? key, required this.callbackFn}) : super(key: key);

  Function callbackFn;

  @override
  State<MySingleToggleButton> createState() => _MySingleToggleButtonState();
}

class _MySingleToggleButtonState extends State<MySingleToggleButton> {
  final List<bool> _selectedCount = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ToggleButtons(
            direction: Axis.horizontal,
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedCount.length; i++) {
                  _selectedCount[i] = i == index;
                }
                if (_selectedCount[0] == true) {
                  widget.callbackFn(false);
                } else if (_selectedCount[0] == false) {
                  widget.callbackFn(true);
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            // selectedBorderColor: Colors.black,
            selectedColor: Colors.white,
            fillColor: Colors.black,
            color: Colors.black,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 100.0,
            ),
            isSelected: _selectedCount,
            children: isCount,
          )
        ],
      ),
    );
  }
}
