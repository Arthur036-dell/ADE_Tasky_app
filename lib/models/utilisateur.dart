// ignore: unused_import
import 'dart:convert';

class Utilisateur {
  final int? id;
  final String email;
  final String motDePasse;
  final String nom;
  final String role;
  final List<String> competences;

  Utilisateur({
    this.id,
    required this.email,
    required this.motDePasse,
    required this.nom,
    required this.role,
    required this.competences,
  });

  // Création d'un Utilisateur à partir d'un objet JSON
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      email: json['email'],
      motDePasse: json['mot_de_passe'],
      nom: json['nom'],
      role: json['role'],
      competences: List<String>.from(json['competences']),
    );
  }

  // Conversion d'un Utilisateur en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'mot_de_passe': motDePasse,
      'nom': nom,
      'role': role,
      'competences': competences,
    };
  }
}
