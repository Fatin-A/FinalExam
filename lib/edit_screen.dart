import 'package:flutter/material.dart';
import 'package:map_exam/home_screen.dart';

class EditScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const EditScreen());

  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String content = '';
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: const Text('App Bar Title'),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.check_circle,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }),
          IconButton(
              icon: const Icon(
                Icons.cancel_sharp,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              initialValue: null,
              enabled: true,
              decoration: const InputDecoration(
                hintText: 'Type the title here',
              ),
              onChanged: (value) {
                setState(() => title = value);
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TextFormField(
                  controller: _descriptionController,
                  enabled: true,
                  initialValue: null,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Type the description',
                  ),
                  onChanged: (value) {
                    setState(() => content = value);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
