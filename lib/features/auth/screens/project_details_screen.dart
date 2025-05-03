import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:file_picker/file_picker.dart';
// ignore: unused_import
import 'package:open_filex/open_filex.dart';

void main() => runApp(MaterialApp(home: ProjectDetailsScreen(projectId: '1')));

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> with TickerProviderStateMixin {
  late Project project;
  late List<TaskItem> tasks;
  List<SharedDocument> sharedDocuments = [];
  bool allMarkedDone = false;
  String selectedStatusFilter = 'Tous';
  String searchQuery = '';

  final List<String> teamMembers = ['Arthur', 'Fatima', 'Nina', 'Ali', 'Emma'];

  @override
  void initState() {
    super.initState();
    project = MockService.getProjectById(widget.projectId);
    tasks = project.tasks.map((task) => TaskItem(
      title: task,
      isDone: false,
      priority: 'Moyenne',
      skills: [],
      deadline: null,
      assignedTo: '',
      status: 'Non commencé',
      animationController: null,
    )).toList();
  }

  void _toggleTaskDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
      tasks[index].status = tasks[index].isDone ? 'Terminé' : 'En cours';
      allMarkedDone = tasks.every((task) => task.isDone);
    });
  }

  void _changeTaskStatus(TaskItem task, String newStatus) {
    setState(() {
      task.status = newStatus;
      task.isDone = newStatus == 'Terminé';
    });
  }

  void _toggleAllTasksDone() {
    setState(() {
      allMarkedDone = !allMarkedDone;
      for (var task in tasks) {
        task.isDone = allMarkedDone;
        task.status = allMarkedDone ? 'Terminé' : 'Non commencé';
      }
    });
  }

  void _addTask(String title, String priority, DateTime? deadline, String skills, String assignedTo, String status) {
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    final newTask = TaskItem(
      title: title,
      priority: priority,
      deadline: deadline,
      skills: skills.split(',').map((s) => s.trim()).toList(),
      assignedTo: assignedTo,
      status: status,
      isDone: status == 'Terminé',
      animationController: controller,
    );
    setState(() {
      tasks.add(newTask);
      allMarkedDone = false;
    });
    controller.forward();
  }

  void _showAddTaskDialog() {
    final taskController = TextEditingController();
    final skillController = TextEditingController();
    String selectedPriority = 'Moyenne';
    String selectedStatus = 'Non commencé';
    String? selectedMember;
    DateTime? selectedDeadline;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une tâche'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: taskController, decoration: const InputDecoration(labelText: 'Nom de la tâche')),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedPriority,
                items: ['Haute', 'Moyenne', 'Basse'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (value) => selectedPriority = value!,
                decoration: const InputDecoration(labelText: 'Priorité'),
              ),
              const SizedBox(height: 12),
              TextField(controller: skillController, decoration: const InputDecoration(labelText: 'Compétences')),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedMember,
                decoration: const InputDecoration(labelText: 'Assigner à'),
                items: teamMembers.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (value) => selectedMember = value!,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Statut de la tâche'),
                items: ['Non commencé', 'En cours', 'Terminé']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => selectedStatus = value!,
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDeadline = pickedDate);
                  }
                },
                child: const Text('Choisir une deadline 📅'),
              ),
              if (selectedDeadline != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Deadline : ${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (taskController.text.isNotEmpty && selectedMember != null) {
                _addTask(
                  taskController.text.trim(),
                  selectedPriority,
                  selectedDeadline,
                  skillController.text.trim(),
                  selectedMember!,
                  selectedStatus,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddProjectFileDialog() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        sharedDocuments.add(SharedDocument(name: file.name, path: file.path!));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fichier ajouté : ${file.name}"), backgroundColor: Colors.green),
      );
    }
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
      decoration: const InputDecoration(
        labelText: "Rechercher une tâche",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }


  Widget _buildTaskTile(TaskItem task, int index) {
    return GestureDetector(
      onLongPress: () => _showStatusChangeDialog(task),
      child: CheckboxListTile(
        value: task.isDone,
        onChanged: (_) => _toggleTaskDone(index),
        title: Text(task.title, style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Priorité: ${task.priority}'),
            if (task.deadline != null)
              Text('Deadline: ${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year}'),
            Text('Assigné à: ${task.assignedTo}'),
            Text('Statut: ${task.status}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        secondary: task.isDone
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
      ),
    );
  }

  void _showStatusChangeDialog(TaskItem task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: ['Non commencé', 'En cours', 'Terminé'].map((status) {
          return ListTile(
            leading: Icon(
              status == 'Terminé' ? Icons.check_circle : status == 'En cours' ? Icons.timelapse : Icons.pause_circle,
              color: status == 'Terminé' ? Colors.green : status == 'En cours' ? Colors.orange : Colors.grey,
            ),
            title: Text(status),
            onTap: () {
              _changeTaskStatus(task, status);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) =>
      (selectedStatusFilter == 'Tous' || task.status == selectedStatusFilter) &&
      task.title.toLowerCase().contains(searchQuery)).toList();

    final total = tasks.length;
    final done = tasks.where((t) => t.status == "Terminé").length;
    final percentDone = total == 0 ? 0 : (done / total * 100).toDouble();

    final percentDoneText = "Progression: ${percentDone.toStringAsFixed(1)}%";

    final dataMap = {
      "Non commencé": tasks.where((t) => t.status == "Non commencé").length.toDouble(),
      "En cours": tasks.where((t) => t.status == "En cours").length.toDouble(),
      "Terminé": done.toDouble(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du projet"),
        actions: [
          IconButton(onPressed: _toggleAllTasksDone, icon: const Icon(Icons.select_all)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            _buildSearchBar(),
            Text("Répartition des tâches"),
            Text(percentDoneText, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Répartition des tâches"),
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              chartRadius: MediaQuery.of(context).size.width / 3,
              chartLegendSpacing: 32,
              colorList: const [Colors.red, Colors.orange, Colors.green],
              legendOptions: LegendOptions(legendPosition: LegendPosition.left),
            ),
            const SizedBox(height: 20),
            Text("Documents partagés", style: Theme.of(context).textTheme.headline6),
            ElevatedButton(
              onPressed: _showAddProjectFileDialog,
              child: const Text("Ajouter un fichier"),
            ),
            const SizedBox(height: 20),
            Text("Tâches", style: Theme.of(context).textTheme.headline6),
            ...filteredTasks.map((task) => _buildTaskTile(task, filteredTasks.indexOf(task))).toList(),
          ],
        ),
      ),
    );
  }
}

extension on TextTheme {
  get headline6 => null;
}

class Project {
  final String id;
  final String title;
  final List<String> tasks;

  Project({required this.id, required this.title, required this.tasks});
}

class TaskItem {
  final String title;
  final String priority;
  final DateTime? deadline;
  final List<String> skills;
  final String assignedTo;
  String status;
  bool isDone;
  final AnimationController? animationController;

  TaskItem({
    required this.title,
    required this.priority,
    required this.deadline,
    required this.skills,
    required this.assignedTo,
    required this.status,
    required this.isDone,
    required this.animationController,
  });
}

class SharedDocument {
  final String name;
  final String path;

  SharedDocument({required this.name, required this.path});
}

class MockService {
  static Project getProjectById(String id) {
    return Project(
      id: id,
      title: "Projet ${id}",
      tasks: ["Tâche 1", "Tâche 2", "Tâche 3"],
    );
  }

  static getProjects() {}
}
