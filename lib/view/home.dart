import 'package:flutter/material.dart';
import 'package:men_log/view/story_add_form.dart';
import 'package:men_log/view/story_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MenLog')),
      body: const StoryListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return const StoryAddForm();
                },
                fullscreenDialog: true),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
