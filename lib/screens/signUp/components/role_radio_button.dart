import 'package:flutter/material.dart';

class RoleSelectionWidget extends StatefulWidget {
  final String role;
  final void Function(String?) setRole;

  const RoleSelectionWidget(
      {Key? key, required this.role, required this.setRole})
      : super(key: key);

  @override
  _RoleSelectionWidgetState createState() => _RoleSelectionWidgetState();
}

class _RoleSelectionWidgetState extends State<RoleSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Role',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Helper',
              groupValue: widget.role,
              onChanged: (value) {
                widget.setRole(value!);
              },
            ),
            const Text('Helper'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Helped',
              groupValue: widget.role,
              onChanged: (value) {
                widget.setRole(value!);
              },
            ),
            const Text('Helped'),
          ],
        ),
      ],
    );
  }
}
