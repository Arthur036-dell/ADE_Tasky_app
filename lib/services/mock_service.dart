import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/tache.dart';

class ProjectService {
  static const String baseUrl = 'http://localhost:8000/api'; // Changez par l'URL de votre serveur Laravel

  // ===================== PROJETS =====================

  // Obtenir tous les projets
  static Future<List<Project>> fetchProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projets'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((jsonItem) => Project.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Erreur lors du chargement des projets');
    }
  }

  // Obtenir un projet par son ID
  static Future<Project> fetchProjectById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/projets/$id'));

    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Projet non trouvé');
    }
  }

  // Ajouter un projet
  static Future<Project> addProject(Project project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projets'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': project.title, // Remplacer par 'nom' pour correspondre à votre contrôleur Laravel
        'description': project.description,
        'equipe_id': project.equipeId, // 'equipe_id' correspond au champ dans la base PostgreSQL
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l\'ajout du projet');
    }
  }

  // ===================== TÂCHES =====================

  // Obtenir les tâches d’un projet donné
  static Future<List<Tache>> fetchTachesByProjetId(int projetId) async {
    final response = await http.get(Uri.parse('$baseUrl/projets/$projetId/taches'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((jsonItem) => Tache.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Erreur lors du chargement des tâches');
    }
  }

  // Ajouter une tâche à un projet
  static Future<Tache> addTache(Tache tache) async {
    final response = await http.post(
      Uri.parse('$baseUrl/taches'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'titre': tache.titre,
        'description': tache.description,
        'priorite': tache.priorite,
        'statut': tache.statut,
        'date_echeance': tache.dateEcheance.toIso8601String(),
        'competences_requises': tache.competencesRequises,
        'projet_id': tache.projetId, // Utilisation du 'projet_id' pour faire correspondre avec la base PostgreSQL
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Tache.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l\'ajout de la tâche');
    }
  }
}
