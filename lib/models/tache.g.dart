// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tache _$TacheFromJson(Map<String, dynamic> json) => Tache(
  id: (json['id'] as num?)?.toInt(),
  titre: json['titre'] as String,
  description: json['description'] as String,
  priorite: json['priorite'] as String,
  statut: json['statut'] as String,
  dateEcheance: DateTime.parse(json['dateEcheance'] as String),
  competencesRequises:
      (json['competencesRequises'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  projetId: (json['projetId'] as num).toInt(),
  projet:
      json['projet'] == null
          ? null
          : Project.fromJson(json['projet'] as Map<String, dynamic>),
  utilisateurs:
      (json['utilisateurs'] as List<dynamic>?)
          ?.map((e) => Utilisateur.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TacheToJson(Tache instance) => <String, dynamic>{
  'id': instance.id,
  'titre': instance.titre,
  'description': instance.description,
  'priorite': instance.priorite,
  'statut': instance.statut,
  'dateEcheance': instance.dateEcheance.toIso8601String(),
  'competencesRequises': instance.competencesRequises,
  'projetId': instance.projetId,
  'projet': instance.projet,
  'utilisateurs': instance.utilisateurs,
};
