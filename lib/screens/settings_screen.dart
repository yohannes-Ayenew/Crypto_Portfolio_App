import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/stylish_app_bar.dart';
import '../core/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final user = ref
        .watch(authStateProvider)
        .value; // Get current Firebase user
    final bool isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const StylishAppBar(firstWord: "ACCOUNT", secondWord: "SETTINGS"),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // User Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.neonGreen.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.neonGreen,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.email?.split('@')[0].toUpperCase() ?? "USER",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? "Guest User",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDark,
            onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
    );
  }
}
