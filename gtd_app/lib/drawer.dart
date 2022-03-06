import 'package:flutter/material.dart';
import 'package:gtd_app/done_settings.dart';
import 'package:gtd_app/settings.dart';
import 'package:gtd_app/done_settings_state.dart';

class GTDDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SettingsHeader(),
          DoneHeader(),
          DoneOptionsWidget(
            model: DoneSettings.shared,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}

class SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Row(
        children: const [
          Icon(
            Icons.settings,
            size: 64,
            color: Colors.white,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            kSettings,
            style: TextStyle(fontSize: 42, color: Colors.white),
          )
        ],
      ),
      decoration: BoxDecoration(color: Colors.blue),
    );
  }
}

class DoneHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: const [
          Icon(
            Icons.done,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            kDoneTasksQuestion,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
