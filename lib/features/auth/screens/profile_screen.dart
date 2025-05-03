import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚡ Simule un utilisateur connecté
    final String fullName = 'Arthur Razak KOURAOGO';
    final String email = 'arthur.mensah@example.com';
    final List<String> skills = ['Flutter', 'Laravel', 'Firebase'];
    final List<String> projects = [
      'Refonte UI App Mobile',
      'Développement API Backend'
    ];

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Divider(height: 32, thickness: 1),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Compétences',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map((skill) => Chip(
                            label: Text(skill),
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                          ))
                      .toList(),
                ),
                const Divider(height: 32, thickness: 1),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Projets Travaillés',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.work_outline, color: AppColors.primary),
                      title: Text(projects[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
