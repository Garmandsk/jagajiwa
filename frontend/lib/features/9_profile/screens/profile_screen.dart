import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/core/utils/quiz_result_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variabel state lokal untuk layar ini
  String? _newAnonymousName;
  bool _isEditing = false;
  bool _isGenerating = false;
  bool _isSaving = false;

  // Fungsi untuk tombol Roll
  Future<void> _rollNewName() async {
    setState(() => _isGenerating = true);
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final generatedName = await provider.generateNewAnoname();
    if (generatedName != null) {
      setState(() {
        _newAnonymousName = generatedName;
        _isEditing = true;
      });
    }
    setState(() => _isGenerating = false);
  }

  // Fungsi untuk tombol Batal
  void _cancelEdit() {
    setState(() {
      _newAnonymousName = null;
      _isEditing = false;
    });
  }

  // Fungsi untuk tombol Simpan
  Future<void> _saveNewName() async {
    if (_newAnonymousName == null) return;
    setState(() => _isSaving = true);
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final success = await provider.updateAnoname(_newAnonymousName!);

    if (mounted) { // Cek jika widget masih ada di tree
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Nama berhasil diperbarui!' : 'Gagal memperbarui nama.'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      setState(() {
        _newAnonymousName = null;
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
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      // Kita hanya butuh Consumer di sini untuk mendapatkan data awal
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !_isEditing) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.profile == null) {
            return const Center(child: Text('Gagal memuat profil.'));
          }

          final profile = provider.profile!;

          // Menggunakan nama yang sedang diedit jika ada, jika tidak pakai dari provider
          final currentName = _newAnonymousName ?? profile.anoname;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // ... (ListTile untuk username, dll)

              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.userSecret,
                  size: 45,
                  color: Colors.grey[600],
                ),
                title: const Text('Anoname'),
                subtitle: Text(
                  currentName ?? 'Memuat...',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: _isGenerating
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : IconButton(
                        icon: const Icon(Icons.sync),
                        tooltip: 'Buat nama baru',
                        onPressed: _rollNewName,
                      ),
              ),

              // Tombol Batal dan Simpan yang hanya muncul saat mode edit
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

              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Username'),
                subtitle: Text(profile.username),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Bergabung Sejak'),
                // Contoh format tanggal sederhana
                subtitle: Text('${profile.created_at.day}/${profile.created_at.month}/${profile.created_at.year}'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.psychology_outlined),
                title: const Text('Hasil Kuis Terakhir'),
                subtitle: Text(QuizResultHelper.getQuizResultText(profile.quiz_result)),
              ),
              const Divider(),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  // Tambahkan logika untuk logout di sini
                  Supabase.instance.client.auth.signOut();
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
              
            ],
          );
        },
      ),
    );
  }
}