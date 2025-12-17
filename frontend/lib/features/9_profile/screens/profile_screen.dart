import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:frontend/features/9_profile/providers/setting_provider.dart';
import 'package:frontend/core/utils/quiz_result_helper.dart';
import 'package:frontend/app/widgets/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../../../app/widgets/navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _newAnoname;
  bool _isEditing = false;
  bool _isGenerating = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
      Intl.defaultLocale = 'id';
    });
  }

  Future<void> _rollNewAnoname() async {
    setState(() => _isGenerating = true);
    final provider = context.read<ProfileProvider>();
    final name = await provider.generateNewAnoname();
    if (name != null) {
      setState(() {
        _newAnoname = name;
        _isEditing = true;
      });
    }
    setState(() => _isGenerating = false);
  }

  void _cancelEdit() {
    setState(() {
      _newAnoname = null;
      _isEditing = false;
    });
  }

  Future<void> _saveNewName() async {
    if (_newAnoname == null) return;
    setState(() => _isSaving = true);

    final success =
    await context.read<ProfileProvider>().updateAnoname(_newAnoname!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(success ? 'Nama berhasil diperbarui' : 'Gagal menyimpan'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      _cancelEdit();
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),

      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.profile == null) {
            return Center(
              child: Text(provider.errorMessage ?? 'Gagal memuat profil'),
            );
          }

          final profile = provider.profile!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// ===== ANONAME =====
              Card(
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.userSecret, size: 36),
                  title: const Text('Anoname'),
                    subtitle: Text(
                    _isEditing
                    ? _newAnoname ?? ''
                        : profile.anoname ?? 'Anoname belum tersedia',
                    style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    ),
                    ),
                            trailing: _isGenerating
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: _rollNewAnoname,
                  ),
                ),
              ),

              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _isSaving
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _cancelEdit,
                        child: const Text('Batal',
                            style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: _saveNewName,
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              /// ===== INFO USER =====
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Username'),
                      subtitle: Text(profile.username),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: const Text('Bergabung Sejak'),
                      subtitle:
                      Text(DateFormat('d MMM y').format(profile.created_at)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.psychology_outlined),
                      title: const Text('Hasil Kuis Terakhir'),
                      subtitle: Text(
                        QuizResultHelper.getQuizResultText(
                            profile.quiz_result),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                          QuizResultHelper.getQuizResultColor(
                              profile.quiz_result),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ===== PENGATURAN =====
              Consumer<SettingProvider>(
                builder: (context, setting, _) {
                  return Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Notifikasi'),
                          value: setting.notificationsEnabled,
                          onChanged: setting.toggleNotifications,
                        ),
                        SwitchListTile(
                          title: const Text('Pengingat Harian'),
                          value: setting.dailyReminderEnabled,
                          onChanged: setting.toggleDailyReminder,
                        ),
                        SwitchListTile(
                          title: const Text('Mode Gelap'),
                          value: setting.themeMode == ThemeMode.dark,
                          onChanged: setting.toggleTheme,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// ===== LOGOUT =====
              TextButton(
                onPressed: () async {
                  context.read<ProfileProvider>().clearData();
                  await Supabase.instance.client.auth.signOut();
                  if (mounted) context.go('/sign-in');
                },
                child: const Text('Logout',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ),

      /// ✅ BOTTOM NAVIGATION (PROFILE INDEX = 3)
      bottomNavigationBar: const MainNavigationBar(currentIndex: 4),
    );
  }
}