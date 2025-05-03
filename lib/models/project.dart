class Project {
  final int id; // correspond à l'id auto-incrémenté Laravel
  final String nom; // correspond à 'nom' dans Laravel
  final String description;
  final int equipeId; // correspond à 'equipe_id'
  final List<Task> taches; // relation avec les tâches

  Project({
    required this.id,
    required this.nom,
    required this.description,
    required this.equipeId,
    required this.taches, required String title, required List tasks,
  });

  // Factory constructor pour construire un Project à partir du JSON Laravel
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      equipeId: json['equipe_id'],
      taches: (json['taches'] as List<dynamic>)
          .map((t) => Task.fromJson(t))
          .toList(),
      title: '',
      tasks: (json['taches'] as List<dynamic>)
          .map((t) => Task.fromJson(t))
          .toList(),
    );
  }

  get tasks => null;

  String? get title => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'equipe_id': equipeId,
      'taches': taches.map((t) => t.toJson()).toList(),
    };
  }
}

class Task {
  final int id;
  final String titre;
  final String contenu;
  final bool estTerminee;

  Task({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.estTerminee,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      titre: json['titre'],
      contenu: json['contenu'],
      estTerminee: json['est_terminee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'est_terminee': estTerminee,
    };
  }
}
