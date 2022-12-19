import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';

class VersesList extends ConsumerWidget {
  const VersesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map>? map = ref.watch(bibleReferenceProvider).verses ?? [];

    int start = ref.watch(bibleReferenceProvider).startVerse ?? 0;
    int? end = ref.watch(bibleReferenceProvider).endVerse;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: map.length,
        itemBuilder: (context, index) {
          if (map.isEmpty) return Container();


          return ListTile(
            selected: end != null ? ((index + 1) >= start &&  (index + 1 <= end)) : (index + 1) == start,
            title: Text(map[index]['text']),
            subtitle: Text((index + 1).toString()),
          );
        },
      ),
    );
  }
}
