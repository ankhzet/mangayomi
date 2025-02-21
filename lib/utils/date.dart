import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

String dateFormat(
  String? timestamp, {
  required WidgetRef ref,
  required BuildContext context,
  String? stringDate,
  DateTime? datetimeDate,
  bool forHistoryValue = false,
  bool useRelativeTimesTamps = true,
  String dateFormat = "",
  bool showHourOrMinute = false,
}) {
  final l10n = l10nLocalizations(context)!;
  final locale = currentLocale(context);
  final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
  final dateTime = datetimeDate ??
      (stringDate != null ? DateTime.parse(stringDate) : DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp!)));

  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final now = DateTime.now();

  if (useRelativeTimesTamps) {
    final delta = now.difference(dateTime);
    final difference = delta.abs();
    final inDays = delta.inDays;
    final ago = delta.inMilliseconds > 0;

    if (inDays == 0 && relativeTimestamps != 0) {
      if (showHourOrMinute) {
        if (difference.inMinutes == 0) {
          return l10n.now;
        }

        if (ago) {
          if (difference.inMinutes < 60) {
            return switch (difference.inMinutes) {
              1 => l10n.a_minute_ago,
              _ => l10n.n_minutes_ago(difference.inMinutes),
            };
          }

          if (difference.inHours < 24) {
            return switch (difference.inHours) {
              1 => l10n.an_hour_ago,
              _ => l10n.n_hours_ago(difference.inHours),
            };
          }
        } else {
          if (difference.inMinutes < 60) {
            return switch (difference.inMinutes) {
              1 => l10n.in_a_minute,
              _ => l10n.in_n_minutes(difference.inMinutes),
            };
          }

          if (difference.inHours < 24) {
            return switch (difference.inHours) {
              1 => l10n.in_an_hour,
              _ => l10n.in_n_hours(difference.inHours),
            };
          }
        }
      }

      return l10n.today;
    } else if (delta.inDays == 1 && relativeTimestamps != 0) {
      return l10n.yesterday;
    } else if (relativeTimestamps == 2) {
      final days = inDays.abs();

      if (days <= 7) {
        return switch (days) {
          1 => ago ? l10n.a_day_ago : l10n.in_a_day,
          != 7 => ago ? l10n.n_days_ago(days) : l10n.in_n_days(days),
          _ => ago ? l10n.a_week_ago : l10n.in_a_week,
        };
      }

      final months = days ~/ 30;

      if (months <= 12) {
        return switch (months) {
          0 => ago ? l10n.n_days_ago(days) : l10n.in_n_days(days),
          1 => ago ? l10n.a_month_ago : l10n.in_a_month,
          != 12 => ago ? l10n.n_month_ago(months) : l10n.in_n_month(months),
          _ => ago ? l10n.a_year_ago : l10n.in_a_year,
        };
      }
    }
  }

  if (forHistoryValue) {
    return date.toString();
  }

  final format = dateFormat.isEmpty ? ref.watch(dateFormatStateProvider) : dateFormat;
  final dateStr = DateFormat(format, locale.toLanguageTag()).format(date);

  if (showHourOrMinute) {
    final timeStr = DateFormat('HH:mm', locale.toLanguageTag()).format(dateTime);
    return '$dateStr $timeStr';
  }

  return dateStr;
}

String dateFormatHour(String timestamp, BuildContext context) {
  final locale = currentLocale(context);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

  return DateFormat.Hm(locale.toLanguageTag()).format(dateTime);
}

List<String> dateFormatsList = ["M/d/y", "MM/dd/yy", "dd/MM/yy", "yyyy-MM-dd", "dd MMM yyyy", "MMM dd, yyyy", "dd.MM.yyyy"];

List<String> relativeTimestampsList(BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return [
    l10n.off,
    l10n.relative_timestamp_short,
    l10n.relative_timestamp_long,
  ];
}
