import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/features/auth/screens/calendar_screen.dart' as details show TaskItem;
import 'package:tasky_app/features/auth/screens/calendar_screen.dart' hide TaskItem;
import 'package:tasky_app/features/auth/screens/profile_screen.dart';
import 'package:tasky_app/features/auth/screens/project_details_screen.dart' as details_screen;
import 'package:tasky_app/features/auth/screens/settings_screen.dart';
import '../../../app/theme/app_colors.dart';
import '../../../services/mock_service.dart';
import '../../../models/project.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Project> projects = [];
  int _selectedIndex = 0;
  late Map<DateTime, List<details.TaskItem>> _tasksByDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // ignore: unused_field
  List<details.TaskItem> _selectedTasks = [];

  final String userRole = 'admin'; // À adapter dynamiquement si besoin

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _tasksByDate = {};
    _loadTasks();
  }

  Future<void> _loadProjects() async {
    try {
      final fetchedProjects = await ProjectService.fetchProjects();
      setState(() => projects = fetchedProjects);
    } catch (e) {
      debugPrint('Erreur lors du chargement des projets : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Impossible de charger les projets.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadTasks() async {
    try {
      final allProjects = details_screen.MockService.getProjects();
      for (var project in allProjects) {
        for (var task in project.tasks) {
          final parsedTask = details.TaskItem(
            title: task,
            deadline: DateTime.now().add(Duration(days: allProjects.indexOf(project) + 1)),
            priority: 'Moyenne',
            skills: [],
            projectId: project.id.toString(),
          );

          final key = DateTime.utc(
            parsedTask.deadline!.year,
            parsedTask.deadline!.month,
            parsedTask.deadline!.day,
          );
          _tasksByDate.putIfAbsent(key, () => []).add(parsedTask);
        }
      }

      _selectedDay = _focusedDay;
      _selectedTasks = _getTasksForDay(_selectedDay!);
    } catch (e) {
      debugPrint('Erreur lors du chargement des tâches : $e');
    }
  }

  List<details.TaskItem> _getTasksForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    return _tasksByDate[key] ?? [];
  }

  void _showAddProjectDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Projet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre du projet'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          OutlinedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                final newProject = Project(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  tasks: [],
                  equipeId: 1,
                  nom: titleController.text.trim(),
                  taches: [],
                );

                try {
                  final createdProject = await ProjectService.addProject(newProject);
                  setState(() {
                    projects.insert(0, createdProject);
                    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Projet ajouté avec succès 🎉',
                            style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Erreur lors de l\'ajout du projet.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: _showAddProjectDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Ajouter un projet',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (userRole == 'admin')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/create-task'),
                    icon: const Icon(Icons.add_task),
                    label: const Text('Créer une tâche'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              if (userRole == 'admin') const SizedBox(height: 16),
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: projects.length,
                  itemBuilder: (context, index, animation) {
                    final project = projects[index];
                    return SizeTransition(
                      sizeFactor: animation,
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(project.title ?? 'Titre indisponible'),
                          subtitle: Text(project.description),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          onTap: () => context.go('/project/${project.id}'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboard(),
      const CalendarScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.light,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendrier'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}
