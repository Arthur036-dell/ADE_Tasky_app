// ignore: unused_import
import 'dart:convert';
import 'utilisateur.dart';
import 'tache.dart';

class Equipe {
  final int? id;
  final String nom;
  final List<Utilisateur> utilisateurs;
  final List<Tache> taches;

  Equipe({
    this.id,
    required this.nom,
    required this.utilisateurs,
    required this.taches,
  });

  // Création d'une équipe à partir d'un objet JSON
  factory Equipe.fromJson(Map<String, dynamic> json) {
    var utilisateursList = json['utilisateurs'] as List;
    var tachesList = json['taches'] as List;

    return Equipe(
      id: json['id'],
      nom: json['nom'],
      utilisateurs: utilisateursList.map((item) => Utilisateur.fromJson(item)).toList(),
      taches: tachesList.map((item) => Tache.fromJson(item)).toList(),
    );
  }

  // Conversion d'une équipe en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'utilisateurs': utilisateurs.map((utilisateur) => utilisateur.toJson()).toList(),
      'taches': taches.map((tache) => tache.toJson()).toList(),
    };
  }

  // Méthode pour ajouter un utilisateur à l'équipe
  void addUtilisateur(Utilisateur utilisateur) {
    utilisateurs.add(utilisateur);
  }

  // Méthode pour ajouter une tâche à l'équipe
  void addTache(Tache tache) {
    taches.add(tache);
  }
}
