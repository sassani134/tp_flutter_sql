import 'package:tp_fluter/model/table_util.dart';

class Personne {
  // Attributs
  int id;
  String nom;
  String prenom;
  String age;

  Personne()
      : id = 0,
        nom = '',
        prenom = '',
        age = '';

  // Constructeur à partir d'une map
  Personne.fromMap(Map<String, dynamic> map)
      : id = map[COLONNE_ID] ??
            0, // Utilisation de l'opérateur de coalescence pour gérer les valeurs nulles
        nom = map[COLONNE_NOM] ?? '',
        prenom = map[COLONNE_PRENOM] ?? '',
        age = map[COLONNE_AGE] ?? '';

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      COLONNE_NOM: nom,
      COLONNE_PRENOM: prenom,
      COLONNE_AGE: age
    };
    if (id != 0) {
      map[COLONNE_ID] = id;
    }
    return map;
  }
}
