import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/media_center/notifiers/bibles_notifier.dart';

import '../../core/file_utils.dart';
import '../media_center_providers.dart';

class BiblesTab extends ConsumerWidget {
  const BiblesTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<BibleData> bibles = ref.watch(biblesProvider);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: bibles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                mainAxisExtent: 200,
              ),
              itemBuilder: (context, index) {
                BibleData bible = bibles[index];
                return Card(
                  child: Center(
                    child: Text(bible.translationName),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: bibleFileExtenstion,
                  );

                  if (result == null) return;

                  FileUtils.importBibles(FileUtils.filePickerResultToFile(result));
                },
                child: const Text('Import'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
