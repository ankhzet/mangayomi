import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class RetryWidget extends StatelessWidget {
  final void Function() onPressed;

  const RetryWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.image_loading_error,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onLongPress: onPressed,
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  l10n.retry,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
