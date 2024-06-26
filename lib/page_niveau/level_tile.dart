import 'package:akari_project/page_jeu/page_jeu.dart';
import 'package:akari_project/page_niveau/level.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class LevelTile extends StatelessWidget {
  final Level level;
  const LevelTile({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var saveBox = Hive.box("saveBox");
        String partie;
        if (level.size == Size.petit) {
          partie = "petit";
        } else if (level.size == Size.moyen) {
          partie = "moyen";
        } else {
          partie = "grand";
        }
        bool gameSaved = saveBox.get(partie) == null ? false : true;

        bool newGame = true;
        if (gameSaved) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Partie sauvegardée"),
              content: const Text("Voulez vous la continuer ?",
                  style: TextStyle(fontSize: 20)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              PageJeu(
                            level: level,
                            newGame: newGame,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  child: const Text('Non'),
                ),
                TextButton(
                  onPressed: () {
                    newGame = false;
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              PageJeu(
                            level: level,
                            newGame: newGame,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  child: const Text('Oui'),
                ),
              ],
            ),
          );
        } else {
          Navigator.pop(context);
          Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              PageJeu(
                            level: level,
                            newGame: newGame,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  
        }
      },
      child: Transform.rotate(
        angle: -0.15,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 7),
              ),
            ],
            color: level.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    child: Center(
                        child: Text(
                      level.icon,
                      style: const TextStyle(fontSize: 30),
                    ))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    level.size == Size.petit
                        ? "Petit"
                        : level.size == Size.moyen
                            ? "Moyen"
                            : "Grand",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: Hive.box('statBox').listenable(),
                      builder: (context, box, _) {
                        return Visibility(
                          visible: level.size == Size.petit
                                ? box.get("records").petitValue != 0
                                : level.size == Size.moyen
                                    ? box.get("records").moyenValue != 0
                                    : box.get("records").grandValue != 0,
                          child: Text(
                            level.size == Size.petit
                                ? "Meilleur temps : ${DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(box.get("records").petitValue))}"
                                : level.size == Size.moyen
                                    ? "Meilleur temps : ${DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(box.get("records").moyenValue))}"
                                    : "Meilleur temps : ${DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(box.get("records").grandValue))}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
