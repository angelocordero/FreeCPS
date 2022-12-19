import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlidesPanel extends ConsumerWidget {
  const SlidesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List<Map>? selectedVerses = ref.watch(ScriptureModelProvider.select((value) {return value.})) ?? [];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        itemCount: 0,
        // itemCount: selectedVerses.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          mainAxisExtent: 150,
        ),
        itemBuilder: (context, index) {
          // if (selectedVerses.isEmpty) return Container();

          return const Card(
            child: Center(
              child: Text(''
                  // selectedVerses[index]['text'],
                  //textAlign: TextAlign.center,
                  ),
            ),
          );
        },
      ),
    );
  }
}
