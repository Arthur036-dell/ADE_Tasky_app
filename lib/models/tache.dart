import 'package:json_annotation/json_annotation.dart';
import 'project.dart';
import 'utilisateur.dart';  // Assure-toi que Utilisateur est défini dans utilisateur.dart

part 'tache.g.dart';

@JsonSerializable()
class Tache {
  final int? id;
  final String titre;
  final String description;
  final String priorite;
  final String statut;
  final DateTime dateEcheance;
  final List<String> competencesRequises;
  final int projetId;
  final Project? projet; // La tâche appartient à un projet
  final List<Utilisateur>? utilisateurs; // Liste des utilisateurs associés à la tâche

  Tache({
    this.id,
    required this.titre,
    required this.description,
    required this.priorite,
    required this.statut,
    required this.dateEcheance,
    required this.competencesRequises,
    required this.projetId,
    this.projet,
    this.utilisateurs,
  });

  // Création d'une instance Tache depuis un objet JSON
  factory Tache.fromJson(Map<String, dynamic> json) => _$TacheFromJson(json);

  // Convertir une instance Tache en JSON
  Map<String, dynamic> toJson() => _$TacheToJson(this);

  // Méthode pour obtenir la priorité sous forme lisible
  String getPrioriteText() {
    switch (priorite) {
      case 'high':
        return 'Haute';
      case 'medium':
        return 'Moyenne';
      case 'low':
        return 'Basse';
      default:
        return 'Non définie';
    }
  }

  // Méthode pour obtenir le statut sous forme lisible
  String getStatutText() {
    switch (statut) {
      case 'open':
        return 'Ouverte';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminée';
      default:
        return 'Non définie';
    }
  }
}
