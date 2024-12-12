import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

String dateFormat(String? timestamp,
    {required WidgetRef ref,
    required BuildContext context,
    String? stringDate,
    bool forHistoryValue = false,
    bool useRelativeTimesTamps = true,
    String dateFormat = "",
    bool showHOURorMINUTE = false}) {
  final l10n = l10nLocalizations(context)!;
  final locale = currentLocale(context);
  final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
  final dateFrmt = ref.watch(dateFormatStateProvider);
  final dateTime = stringDate != null
      ? DateTime.parse(stringDate)
      : DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp!));

  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  if (date == today && useRelativeTimesTamps && relativeTimestamps != 0) {
    if (showHOURorMINUTE) {
      final difference = now.difference(dateTime);
      if (difference.inMinutes < 60) {
        return switch (difference.inMinutes) {
          0 => l10n.now,
          1 => l10n.n_minute_ago(difference.inMinutes),
          _ => l10n.n_minutes_ago(difference.inMinutes),
        };
      } else if (difference.inHours < 24) {
        return switch (difference.inHours) {
          1 => l10n.n_hour_ago(difference.inHours),
          _ => l10n.n_hours_ago(difference.inHours),
        };
      }
    }

    return l10n.today;
  } else if (date == today.subtract(const Duration(days: 1)) && useRelativeTimesTamps && relativeTimestamps != 0) {
    return l10n.yesterday;
  } else if (useRelativeTimesTamps && relativeTimestamps == 2) {
    final difference = today.difference(date).inDays;

    if (difference <= 7) {
      return switch (difference) {
        1 => l10n.n_day_ago(difference),
        != 7 => l10n.n_days_ago(difference),
        _ => l10n.a_week_ago,
      };
    }
  }

  if (forHistoryValue) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day).toString();
  }

  return DateFormat(dateFormat.isEmpty ? dateFrmt : dateFormat, locale.toLanguageTag()).format(date);
}

String dateFormatHour(String timestamp, BuildContext context) {
  final locale = currentLocale(context);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

  return DateFormat.Hm(locale.toLanguageTag()).format(dateTime);
}

List<String> dateFormatsList = [
  "M/d/y",
  "MM/dd/yy",
  "dd/MM/yy",
  "yyyy-MM-dd",
  "dd MMM yyyy",
  "MMM dd, yyyy"
];

List<String> relativeTimestampsList(BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return [
    l10n.off,
    l10n.relative_timestamp_short,
    l10n.relative_timestamp_long,
  ];
}
