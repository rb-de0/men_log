import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:men_log/model/story.dart';

class APIClient {
  Future<List<Story>> fetchStories() async {
    final accessToken = dotenv.env['ASANA_ACCESS_TOKEN'] ?? "";
    final taskID = dotenv.env['ASANA_TASK_ID'] ?? "";
    final url = Uri.parse(
        'https://app.asana.com/api/1.0/tasks/$taskID/stories?opt_fields=text,created_at,resource_type,resource_subtype&opt_pretty');
    Map<String, String> headers = {'Accept': 'application/json', 'Authorization': 'Bearer $accessToken'};
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonBody['data'];
        final List<dynamic> storyData = jsonData.where((dynamic story) => story['resource_subtype'] == 'comment_added').toList();
        final List<Story> stories =
            storyData.map((dynamic story) => Story(text: story['text'], createdAt: DateTime.parse(story['created_at']))).toList();
        return stories;
      } else {
        throw Exception("fetch stories failed");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addStory(String storyText) async {
    final accessToken = dotenv.env['ASANA_ACCESS_TOKEN'] ?? "";
    final taskID = dotenv.env['ASANA_TASK_ID'] ?? "";
    final url = Uri.parse('https://app.asana.com/api/1.0/tasks/$taskID/stories');
    Map<String, String> headers = {'Accept': 'application/json', 'Authorization': 'Bearer $accessToken'};
    String body = json.encode({
      'data': {'text': storyText}
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception("add story failed");
      }
    } catch (e) {
      rethrow;
    }
  }
}
