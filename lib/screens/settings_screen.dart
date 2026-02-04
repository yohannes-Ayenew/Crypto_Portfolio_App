import 'package:crypto_app/providers/auth_provider.dart';
import 'package:crypto_app/widgets/stylish_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../core/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
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
                  radius: 50,
                  backgroundColor: AppTheme.neonGreen.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppTheme.neonGreen,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Upwork Developer",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "premium_dev@example.com",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Settings Categories
          _sectionHeader("Display"),
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Toggle between light and dark themes"),
            secondary: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppTheme.neonGreen,
            ),
            value: isDark,
            activeThumbColor: AppTheme.neonGreen,
            onChanged: (val) {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),

          _sectionHeader("Security"),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: AppTheme.neonGreen),
            title: const Text("Biometric Lock"),
            trailing: const Text("Off", style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),

          _sectionHeader("Support"),
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppTheme.neonGreen),
            title: const Text("Help Center"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppTheme.neonGreen),
            title: const Text("About Crypto Portfolio"),
            subtitle: const Text("Version 1.0.0"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
