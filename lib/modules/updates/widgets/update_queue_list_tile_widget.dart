import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/dto/group.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_periodicity_provider.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/manga.dart';

class UpdateQueueListTileWidget extends ConsumerWidget {
  final Group<MangaPeriodicity, int> candidate;

  const UpdateQueueListTileWidget({
    required this.candidate,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:manga, :last, :period, :days) = candidate.first!;
    final regularColor = Theme.of(context).textTheme.bodyLarge!.color;
    final now = DateTime.now().millisecondsSinceEpoch;
    final at = DateTime.fromMillisecondsSinceEpoch(last.millisecondsSinceEpoch + period.inMilliseconds);
    final isOverdue = at.millisecondsSinceEpoch < now;
    final atStr = dateFormat(
      null,
      ref: ref,
      context: context,
      datetimeDate: at,
      useRelativeTimesTamps: true,
      showHourOrMinute: true,
    );

    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () async {
          context.push('/manga-reader/detail', extra: manga.id);
        },
        onLongPress: () {},
        onSecondaryTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          child: Container(
            height: 45,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Material(
                          child: Ink.image(
                            fit: BoxFit.cover,
                            width: 40,
                            height: 45,
                            image: manga.imageProvider(ref),
                            child: InkWell(child: Container()),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                manga.name!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: regularColor),
                              ),
                              Text(
                                isOverdue ? 'Should\'ve checked $atStr' : 'Would check $atStr',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11, color: regularColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (manga.updateError != null)
                        Tooltip(
                          message: manga.updateError,
                          preferBelow: false,
                          child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                size: 12,
                                Icons.medical_services_outlined,
                                color: Theme.of(context).focusColor,
                              )),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
