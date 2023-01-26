import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:men_log/api/api_client.dart';
import 'package:men_log/model/story.dart';

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  final stories = await APIClient().fetchStories();
  stories.sort((lhs, rhs) {
    return rhs.createdAt.compareTo(lhs.createdAt);
  });
  return stories;
});

class StoryListView extends ConsumerWidget {
  const StoryListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storiesProvider);
    return stories.when(
      loading: () {
        return Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
        );
      },
      error: (error, stacktrace) {
        return Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: TextButton(
            onPressed: () async {
              // ignore: unused_result
              ref.refresh(storiesProvider);
            },
            child: Text(
              "reload",
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          ),
        );
      },
      data: (value) {
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(storiesProvider),
          child: ListView(children: [
            for (final story in value)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(story.text, style: const TextStyle(fontSize: 14.0)),
                  ),
                  subtitle:
                      Text(DateFormat('yyyy/MM/dd(E) HH:mm').format(story.createdAt), style: const TextStyle(fontSize: 14.0)),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
          ]),
        );
      },
    );
  }
}
