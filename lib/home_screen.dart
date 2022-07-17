import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool isReadmore = false;
  bool isReadless = true;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: const Text(
              '4',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 4,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.blueGrey,
        ),
        itemBuilder: (context, index) => ListTile(
          trailing: SizedBox(
            width: 110.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: isVisible,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {},
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          title: const Text('Note title'),
          subtitle: const Text('Note content'),
          onTap: () {},
          onLongPress: () {
            showToast();
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: const Icon(Icons.menu),
              tooltip: 'Show less. Hide notes content',
              onPressed: () {
                setState(() {
                  isReadless = !isReadless;
                });
              }),
          FloatingActionButton(
              child: const Icon(Icons.menu),
              tooltip: 'Show more. Unhide notes content',
              onPressed: () {
                setState(() {
                  isReadmore = !isReadmore;
                });
              }),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void showToast() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<http.Response> deleteDocument(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
      headers: <String, String>{
        'title': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}
