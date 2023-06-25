import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/audio_provider.dart';


class FilterList extends StatelessWidget {
  const FilterList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioProvider>();
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return UnconstrainedBox(
            child: GestureDetector(
              onTap: () {
                audioProvider.selectFilterIndex(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                    color: audioProvider.selectedFilterIndex == index
                        ? Theme.of(context).primaryColorLight
                        : Colors.transparent,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child:
                    Center(child: Text(audioProvider.filters.toList()[index])),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              width: 12,
            ),
        itemCount: audioProvider.filters.length);
  }
}
