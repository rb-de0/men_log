import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:men_log/api/api_client.dart';
import 'package:men_log/view/story_list.dart';

final storyControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController(text: '');
});

final isLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class StoryAddForm extends ConsumerWidget {
  const StoryAddForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(storyControllerProvider);
    final isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add')),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.only(left: 8, right: 8),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).listTileTheme.tileColor ?? Colors.black12),
        ),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(border: InputBorder.none, hintText: 'New story text'),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading
            ? null
            : () async {
                await _addStory(ref, () {
                  Navigator.of(context).pop();
                }, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text("add story failed"), backgroundColor: Theme.of(context).errorColor));
                });
              },
        child: isLoading ? const CircularProgressIndicator() : const Text("Add"),
      ),
    );
  }

  _addStory(WidgetRef ref, void Function() onSuccess, void Function() onError) async {
    ref.read(isLoadingProvider.notifier).state = true;
    try {
      await APIClient().addStory(ref.read(storyControllerProvider).text);
      // ignore: unused_result
      ref.refresh(storiesProvider);
      onSuccess();
    } catch (e) {
      onError();
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }
}
