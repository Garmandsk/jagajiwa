import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:frontend/features/9_profile/providers/setting_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/core/utils/quiz_result_helper.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State lokal tetap ada
  String? _newAnoname;
  bool _isEditing = false;
  bool _isGenerating = false;
  bool _isSaving = false;

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
    // ... (kode initState Anda yang sudah ada tetap di sini)
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }


  @override
  Widget build(BuildContext context) {
    print('Rebuilding ProfileScreen');
    
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      // Gunakan ListView untuk daftar pengaturan
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          print('Rebuilding ProfileScreen 2');
          // Tampilkan loading spinner besar
        if (profileProvider.isLoading && profileProvider.profile == null) return const Center(child: CircularProgressIndicator());

        // Tampilkan error jika gagal load
        if (profileProvider.profile == null) return Center(child: Text(profileProvider.errorMessage ?? 'Gagal memuat profil.'));        
        
        // Data sudah ada, simpan di variabel
        final profile = profileProvider.profile!;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // --- Bagian Anoname (Dinamis dengan Consumer) ---
            // Gunakan Card agar sesuai tema "Pelita Jiwa" (latar putih, teks hitam)
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                // Consumer hanya membungkus bagian yang berubah
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    // Ambil data terbaru dari 'profileProvider'
                    final currentAnoname = _isEditing 
                        ? _newAnoname 
                        : profileProvider.profile?.anoname;
        
                    return ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.userSecret,
                        size: 40,
                        color: Colors.grey[700], // Warna ikon di atas kartu putih
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
            
            const SizedBox(height: 16), // Jarak antar kartu
        
            // --- Bagian Info Lain (Statis) ---
            // Bungkus sisanya dengan Card agar rapi
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Username'),
                    subtitle: Text(profile.username), // Data statis (tidak berubah)
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Bergabung Sejak'),
                    // Gunakan intl untuk format tanggal yang benar
                    subtitle: Text(
                      DateFormat('d MMM y', 'id_ID').format(profile.created_at)
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.psychology_outlined),
                    title: const Text('Hasil Kuis Terakhir'),
                    subtitle: Text(
                      QuizResultHelper.getQuizResultText(profile.quiz_result),
                      style: TextStyle(
                        // Beri warna sesuai helper
                        color: QuizResultHelper.getQuizResultColor(profile.quiz_result),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            const SizedBox(height: 16),
        
            Card(
              color: Theme.of(context).colorScheme.background,
              child: Consumer<SettingProvider>(
                builder: (context, settingProvider, child){
                  return Column(
                    children: [
                      Card(
                        child: SwitchListTile(
                          title: const Text('Notifikasi'),
                          value: settingProvider.notificationsEnabled,
                          onChanged: (value) {
                            // Panggil fungsi di provider
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
                          // Cek apakah mode saat ini adalah gelap
                          value: settingProvider.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            // value adalah true jika switch diaktifkan (gelap)
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
        
            // --- Tombol Aksi ---
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Beranda'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/knowledge'), // push agar bisa kembali
              child: const Text('Pusat Pengetahuan'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                context.read<ProfileProvider>().clearData();
                await Supabase.instance.client.auth.signOut();
                // Arahkan kembali ke login setelah logout
                if (context.mounted) context.go('/sign-in'); 
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ); // Supaya tidak error
      }),
    );
  }
}