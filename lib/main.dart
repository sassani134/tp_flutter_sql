
import 'package:flutter/material.dart';
import 'package:tp_fluter/model/personne.dart';
import 'package:tp_fluter/model/table_util.dart';
import 'package:tp_fluter/provider/personne_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo SQfLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> mapPersonne = {
    'nom': 'DOE',
    'prenom': 'John',
    'age': '35',
  };
  late Map<String, dynamic> mapPersonneRecuperee;
  Personne personneEnregistree = Personne();
  Personne personneRecuperee = Personne();
  late PersonneProvider provider;

  @override
  void initState() {
    super.initState();
    personneEnregistree = Personne.fromMap(mapPersonne);
    getInstance();
  }

  Future<void> getInstance() async {
    provider = PersonneProvider.instance;
  }

  @override
  void dispose() {
    super.dispose();
    provider.close();
  }

  Future<void> enregistrer() async {
    int? id = await provider.insert(personneEnregistree);
    if (id != null) {
      mapPersonneRecuperee = {'id': id};
      personneRecuperee = Personne.fromMap(mapPersonneRecuperee);
    } else {
      // Gérer le cas où l'insertion échoue
      print("Erreur d'insertion");
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Enregistrement'),
          content: Text('Les données ont été enregistrées !'),
        );
      },
    );
  }

  Future<void> recuperer() async {
    int? id = personneRecuperee.toMap()[COLONNE_ID] as int?;
    if (id != null) {
      Personne? recuperee = await provider.getPersonne(id);
      if (recuperee != null) {
        setState(() {
          personneRecuperee = recuperee;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Récupération'),
              content: Text('Aucune donnée trouvée pour cet ID !'),
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Récupération'),
            content: Text('Aucune donnée à récupérer !'),
          );
        },
      );
    }
  }

  Future<void> supprimer() async {
    int? id = personneRecuperee.toMap()[COLONNE_ID] as int?;
    if (id != null) {
      await provider.delete(id);
      setState(() {
        personneRecuperee = Personne();
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Suppression'),
            content: Text('Les données ont été supprimées !'),
          );
        },
      );
    } else {
      // Gérer le cas où il n'y a aucune donnée à supprimer
      print("Erreur de suppression");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 80.0,
              color: Colors.blue,
            ),
            const Text('Données soumises :'),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // NOM SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Nom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${personneEnregistree.toMap()[COLONNE_NOM]}',
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // PRENOM SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Prenom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${personneEnregistree.toMap()[COLONNE_PRENOM]}',
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // AGE SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Age : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${personneEnregistree.toMap()[COLONNE_AGE]}',
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Text('Données Récupérées :'),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ID SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'id : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee.toMap()[COLONNE_ID] != null
                          ? Text(
                              '${personneRecuperee.toMap()[COLONNE_ID]}',
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Aucune donnée',
                              style: TextStyle(color: Colors.white),
                            ),
                    ],
                  ),
                  // NOM SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Nom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee.toMap()[COLONNE_NOM] != null
                          ? Text(
                              '${personneRecuperee.toMap()[COLONNE_NOM]}',
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Aucune donnée',
                              style: TextStyle(color: Colors.white),
                            ),
                    ],
                  ),
                  // PRENOM SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Prenom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee.toMap()[COLONNE_PRENOM] != null
                          ? Text(
                              '${personneRecuperee.toMap()[COLONNE_PRENOM]}',
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Aucune donnée',
                              style: TextStyle(color: Colors.white),
                            ),
                    ],
                  ),
                  // AGE SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Age : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee.toMap()[COLONNE_AGE] != null
                          ? Text(
                              '${personneRecuperee.toMap()[COLONNE_AGE]}',
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Aucune donnée',
                              style: TextStyle(color: Colors.white),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  onPressed: enregistrer,
                  child: const Text('Enregistrer'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  onPressed: recuperer,
                  child: const Text('Lire les données'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  onPressed: supprimer,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
