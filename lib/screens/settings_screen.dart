import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: themeMode == ThemeMode.dark,
            onChanged: (val) {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About Crypto Portfolio"),
            subtitle: Text("Version 1.0.0"),
          ),
        ],
      ),
    );
  }
}
