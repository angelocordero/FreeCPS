import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';

class VersesList extends ConsumerWidget {
  const VersesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map>? map = ref.watch(scriptureModelProvider).verses ?? [];

    int start = ref.watch(scriptureModelProvider).startVerse ?? 0;
    int? end = ref.watch(scriptureModelProvider).endVerse;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: map.length,
        itemBuilder: (context, index) {
          if (map.isEmpty) return Container();

          return Card(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              selected: end != null ? ((index + 1) >= start && (index + 1 <= end)) : (index + 1) == start,
              selectedColor: Colors.black,
              selectedTileColor: Colors.lightBlue.shade50,
              title: Text(map[index]['text']),
              subtitle: Text((index + 1).toString()),
            ),
          );
        },
      ),
    );
  }
}
