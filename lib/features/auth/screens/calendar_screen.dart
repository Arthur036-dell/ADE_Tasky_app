
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/services/mock_service.dart';
import '../../../app/theme/app_colors.dart';
// ignore: unused_import
import '../../../models/project.dart';
// ignore: unused_import
import '../../../models/tache.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<TaskItem>> _tasksByDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<TaskItem> _selectedTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tasksByDate = {};
    _loadProjectsAndTasks();
  }

  Future<void> _loadProjectsAndTasks() async {
    try {
      final allProjects = await ProjectService.fetchProjects();

      for (var project in allProjects) {
        final projectTasks = await ProjectService.fetchTachesByProjetId(project.id);

        for (var task in projectTasks) {
          final parsedTask = TaskItem(
            title: task.titre,
            deadline: task.dateEcheance,
            priority: task.priorite,
            skills: task.competencesRequises,
            projectId: project.id.toString(),
          );

          final key = DateTime.utc(parsedTask.deadline!.year, parsedTask.deadline!.month, parsedTask.deadline!.day);
          _tasksByDate.putIfAbsent(key, () => []).add(parsedTask);
        }
      }

      setState(() {
        _selectedDay = _focusedDay;
        _selectedTasks = _getTasksForDay(_selectedDay!);
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur lors du chargement des tâches : $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<TaskItem> _getTasksForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    return _tasksByDate[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: const Text('Calendrier des tâches', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar<TaskItem>(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  eventLoader: _getTasksForDay,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    markerDecoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _selectedTasks = _getTasksForDay(selectedDay);
                    });
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _selectedTasks.isEmpty
                      ? const Center(child: Text("Aucune tâche prévue ce jour-là"))
                      : ListView.builder(
                          itemCount: _selectedTasks.length,
                          itemBuilder: (context, index) {
                            final task = _selectedTasks[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(task.title),
                                subtitle: Text("Priorité : ${task.priority}"),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  context.go('/project/${task.projectId}');
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class TaskItem {
  final String title;
  final String priority;
  final DateTime? deadline;
  final List<String> skills;
  final String projectId;

  TaskItem({
    required this.title,
    required this.priority,
    this.deadline,
    required this.skills,
    required this.projectId,
  });
}
