import 'package:flutter/material.dart';

class ResumeSettingsPage extends StatefulWidget {
  const ResumeSettingsPage({super.key});

  @override
  State<ResumeSettingsPage> createState() => _ResumeSettingsPageState();
}

class _ResumeSettingsPageState extends State<ResumeSettingsPage> {
  List<String> items = [
    'Objective',
    'Education',
    'Experience',
    'Skills',
    'Awards',
    'Certifications',
    'Interests',
    'Languages',
    'References',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
          });
        },
        children: [
          for (int index = 0; index < items.length; index += 1)
            _singleItem(
              index,
              items[index],
              'Item ${index + 1}',
            ),
        ],
      ),
    );
  }

  Widget _singleItem(int index, String title, String subtitle) {
    return Card(
      key: ValueKey(index),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.drag_handle),
      ),
    );
  }
}
