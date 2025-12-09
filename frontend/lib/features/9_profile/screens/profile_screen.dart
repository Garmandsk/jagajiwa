import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:frontend/features/9_profile/providers/setting_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/core/utils/quiz_result_helper.dart';
import 'package:intl/intl.dart';

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

  // --- FUNGSI BARU UNTUK BOTTOM NAVIGATION ---
  void navigateBottomBar(String route) {
    // Menggunakan context.go untuk berpindah antar tab utama
    context.go(route);
  }
  // ------------------------------------------

  // --- Fungsi helper tetap sama ---
  Future<void> _rollNewAnoname() async {
    setState(() => _isGenerating = true);
    final profileProvider = context.read<ProfileProvider>();
    final generatedName = await profileProvider.generateNewAnoname();
    if (generatedName != null) {
      setState(() {
        _newAnoname = generatedName;
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
    final provider = context.read<ProfileProvider>();
    final success = await provider.updateAnoname(_newAnoname!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Nama berhasil diperbarui!' : 'Gagal memperbarui nama.'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      setState(() {
        _newAnoname = null;
        _isEditing = false;
      });
    }
    setState(() => _isSaving = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
      // Mengatur locale intl ke 'id' jika belum diset
      Intl.defaultLocale = 'id';
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // 🎯 PERUBAHAN DI SINI: centerTitle: true
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),
      body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {

            if (profileProvider.isLoading && profileProvider.profile == null) return const Center(child: CircularProgressIndicator());

            if (profileProvider.profile == null) return Center(child: Text(profileProvider.errorMessage ?? 'Gagal memuat profil.'));

            final profile = profileProvider.profile!;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // --- Bagian Anoname (Dinamis dengan Consumer) ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) {
                        final currentAnoname = _isEditing
                            ? _newAnoname
                            : profileProvider.profile?.anoname;

                        return ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.userSecret,
                            size: 40,
                            color: Colors.grey[700],
                          ),
                          title: const Text('Anoname'),
                          subtitle: Text(
                            currentAnoname ?? 'Memuat...',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          trailing: _isGenerating
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                              : IconButton(
                            icon: const Icon(Icons.sync),
                            tooltip: 'Buat nama baru',
                            onPressed: _rollNewAnoname,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // --- Tombol Simpan/Batal (Dinamis dengan State Lokal) ---
                Visibility(
                  visible: _isEditing,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: _cancelEdit,
                          child: const Text('Batal', style: TextStyle(color: Colors.red)),
                        ),
                        ElevatedButton(
                          onPressed: _saveNewName,
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- Bagian Info Lain (Statis) ---
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Username'),
                        subtitle: Text(profile.username),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: const Text('Bergabung Sejak'),
                        subtitle: Text(
                            DateFormat('d MMM y').format(profile.created_at)
                        ),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.psychology_outlined),
                        title: const Text('Hasil Kuis Terakhir'),
                        subtitle: Text(
                          QuizResultHelper.getQuizResultText(profile.quiz_result),
                          style: TextStyle(
                            color: QuizResultHelper.getQuizResultColor(profile.quiz_result),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --- Bagian Pengaturan ---
                Card(
                    color: Theme.of(context).colorScheme.surface,
                    child: Consumer<SettingProvider>(
                        builder: (context, settingProvider, child){
                          return Column(
                            children: [
                              // Kartu 1: Notifikasi
                              Card(
                                child: SwitchListTile(
                                  title: const Text('Notifikasi'),
                                  value: settingProvider.notificationsEnabled,
                                  onChanged: (value) {
                                    settingProvider.toggleNotifications(value);
                                  },
                                ),
                              ),

                              // Kartu 2: Pengingat Harian
                              Card(
                                child: SwitchListTile(
                                  title: const Text('Pengingat Harian'),
                                  value: settingProvider.dailyReminderEnabled,
                                  onChanged: (value) {
                                    settingProvider.toggleDailyReminder(value);
                                  },
                                ),
                              ),

                              // Kartu 3: Mode Gelap
                              Card(
                                child: SwitchListTile(
                                  title: const Text('Mode Gelap'),
                                  value: settingProvider.themeMode == ThemeMode.dark,
                                  onChanged: (value) {
                                    settingProvider.toggleTheme(value);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                    )
                ),


                const SizedBox(height: 30),

                // --- Tombol Logout (Tetap Dipertahankan) ---
                TextButton(
                  onPressed: () async {
                    context.read<ProfileProvider>().clearData();
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) context.go('/sign-in');
                  },
                  child: const Text('Logout', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          }),

      // 🎯 FLOATING ACTION BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke Loss Simulation
          context.push('/loss-simulation');
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // 🎯 BOTTOM NAVIGATION BAR (Menggantikan tombol Beranda/Knowledge)
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Home
            IconButton(
                icon: const Icon(Icons.home, color: Colors.grey),
                onPressed: () => navigateBottomBar('/home')
            ),
            // Komunitas (Forum Anonim)
            IconButton(
                icon: const Icon(Icons.group, color: Colors.grey),
                onPressed: () => navigateBottomBar('/anonym-forum')
            ),
            const SizedBox(width: 40), // Jarak untuk FAB
            // Artikel (Knowledge)
            IconButton(
                icon: const Icon(Icons.menu_book, color: Colors.grey),
                onPressed: () => navigateBottomBar('/knowledge')
            ),
            // Profil - DIBUAT HIGHLIGHT (HITAM)
            IconButton(
                icon: const Icon(Icons.person, color: Colors.black), // <-- HIGHLIGHT DI SINI
                onPressed: () => navigateBottomBar('/profile')
            ),
          ],
        ),
      ),
    );
  }
}