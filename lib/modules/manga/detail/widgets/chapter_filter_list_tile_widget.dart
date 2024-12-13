import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';

class ListTileItemFilter extends StatelessWidget {
  final String label;
  final int type;
  final VoidCallback onTap;

  const ListTileItemFilter({
    super.key,
    required this.label,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      tristate: true,
      value: type == FilterType.exclude.index ? null : type == FilterType.include.index,
      title: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (_) => onTap(),
    );
  }
}
