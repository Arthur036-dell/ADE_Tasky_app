import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _competencesController = TextEditingController();

  String? _priorite;
  String? _statut;
  DateTime? _dateEcheance;

  final List<String> priorites = ['Basse', 'Moyenne', 'Haute'];
  final List<String> statuts = ['En attente', 'En cours', 'Terminée'];

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final nouvelleTache = {
        'titre': _titreController.text,
        'description': _descriptionController.text,
        'priorite': _priorite,
        'statut': _statut,
        'date_echeance': _dateEcheance?.toIso8601String(),
        'competences_requises': _competencesController.text.split(','),
        'projet_id': 1, // À adapter selon le contexte réel
      };

      print('Tâche soumise : $nouvelleTache');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tâche créée avec succès')),
      );
      context.pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dateEcheance) {
      setState(() {
        _dateEcheance = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Vert très clair
      appBar: AppBar(
        title: const Text('Créer une tâche'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.teal, width: 1.5),
            ),
            elevation: 8,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titreController,
                      decoration: const InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Veuillez entrer un titre' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _priorite,
                      items: priorites
                          .map((p) =>
                              DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (val) => setState(() => _priorite = val),
                      decoration: const InputDecoration(
                        labelText: 'Priorité',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null ? 'Sélectionnez une priorité' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _statut,
                      items: statuts
                          .map((s) =>
                              DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) => setState(() => _statut = val),
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null ? 'Sélectionnez un statut' : null,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(_dateEcheance == null
                          ? 'Sélectionner une date'
                          : 'Date d\'échéance: ${DateFormat('dd/MM/yyyy').format(_dateEcheance!)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _competencesController,
                      decoration: const InputDecoration(
                        labelText:
                            'Compétences requises (séparées par des virgules)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200, // Largeur réduite du bouton
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _submitTask,
                        child: const Text(
                          'Créer la tâche',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
