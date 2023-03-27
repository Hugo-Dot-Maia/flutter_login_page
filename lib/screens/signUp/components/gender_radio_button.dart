import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String gender;
  final void Function(String?) setGender;

  const GenderSelectionWidget(
      {Key? key, required this.gender, required this.setGender})
      : super(key: key);

  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Gender',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: widget.gender,
              onChanged: (value) {
                widget.setGender(value!);
              },
            ),
            const Text('Male'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Female',
              groupValue: widget.gender,
              onChanged: (value) {
                widget.setGender(value!);
              },
            ),
            const Text('Female'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Other',
              groupValue: widget.gender,
              onChanged: (value) {
                widget.setGender(value!);
              },
            ),
            const Text('Other'),
          ],
        ),
      ],
    );
  }
}
