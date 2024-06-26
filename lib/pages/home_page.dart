import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snake/components/blank_feild.dart';
import 'package:snake/components/food.dart';
import 'package:snake/components/medal.dart';
import 'package:snake/components/snake.dart';
import 'package:snake/models/result_model.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SnakeDirection { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    fetchResult();
    super.initState();
  }

  List<Result> result = [];

  void sort() {
    for (var i = 0; i < result.length; i++) {
      for (var j = 0; j < result.length - 1 - i; j++) {
        if (result[j].result < result[j + 1].result) {
          var temp = result[j + 1];
          result[j + 1] = result[j];
          result[j] = temp;
        }
      }
    }
  }

  Future<void> fetchResult() async {
    try {
      var querySnapshot = await results.get();
      setState(() {
        result = querySnapshot.docs
            .map(
              (e) => Result.formDocument(
                e.data(),
              ),
            )
            .toList();
      });
      sort();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      debugPrint("Signed in anoymously: ${user!.uid}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> addResultToFireBase(
      String name, int result, String userId) async {
    try {
      await results
          .doc(userId)
          .set(Result(
            name: nameController.text,
            result: foodCount,
            userId: userId,
          ).toDocument())
          .then(
            (value) => print("Result Added"),
          )
          .catchError(
            (error) => print(
              "Failed to add the result $error",
            ),
          );
    } catch (e) {
      print(e);
    }
  }

  int rowSize = 10;
  int area = 100;
  int foodPos = 45;
  int foodCount = 0;

  bool isStarted = false;

  List<int> snakePos = [0, 1, 2];
  final results = FirebaseFirestore.instance.collection('results');
  TextEditingController nameController = TextEditingController();

  var snakeDirection = SnakeDirection.RIGHT;

  startGame() {
    signInAnonymously();
    isStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        motion();
        eatFood();
        if (body()) {
          showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 220, 220, 220),
                title: const Text("Game Over"),
                actions: [
                  Text(
                    "Your score: $foodCount",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    maxLength: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        color: Colors.green,
                        onPressed: () {
                          newGame();
                        },
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 20),
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: () {
                          addResultToFireBase(
                            nameController.text,
                            foodCount,
                            const Uuid().v1(),
                          );
                          fetchResult();
                          newGame();
                          nameController.clear();
                        },
                        child: const Text('Save result'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
          timer.cancel();
        }
      });
    });
  }

  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 44;
      foodCount = 0;
      isStarted = false;
      snakeDirection = SnakeDirection.RIGHT;
      Navigator.of(context).pop();
    });
  }

  void submit() {
    isStarted = false;
  }

  bool body() {
    List<int> snakeBody = snakePos.sublist(0, snakePos.length - 1);
    if (snakeBody.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  void eatFood() {
    if (snakePos.last == foodPos) {
      foodCount++;
      foodPos = Random().nextInt(area);
    }
  }

  void motion() {
    switch (snakeDirection) {
      case SnakeDirection.RIGHT:
        if (snakePos.last % 10 == 9) {
          snakePos.add(snakePos.last + 1 - rowSize);
        } else {
          snakePos.add(snakePos.last + 1);
        }

        break;

      case SnakeDirection.LEFT:
        if (snakePos.last % rowSize == 0) {
          snakePos.add(snakePos.last - 1 + rowSize);
        } else {
          snakePos.add(snakePos.last - 1);
        }

        break;
      case SnakeDirection.DOWN:
        if (snakePos.last + rowSize > area) {
          snakePos.add(snakePos.last + rowSize - area);
        } else {
          snakePos.add(snakePos.last + rowSize);
        }

        break;

      case SnakeDirection.UP:
        if (snakePos.last < rowSize) {
          snakePos.add(snakePos.last - rowSize + area);
        } else {
          snakePos.add(snakePos.last - rowSize);
        }

        break;
      default:
    }

    if (snakePos.last == foodPos) {
    } else {
      snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      foodCount.toString(),
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 47.0, top: 5),
                    child: ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (context, i) {
                        if (result.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (i == 0) {
                          return Medal(
                            name: result[i].name,
                            result: result[i].result,
                            emoji: "🥇",
                          );
                        } else if (i == 1) {
                          return Medal(
                            name: result[i].name,
                            result: result[i].result,
                            emoji: "🥈",
                          );
                        } else if (i == 2) {
                          return Medal(
                            name: result[i].name,
                            result: result[i].result,
                            emoji: "🥉",
                          );
                        } else {
                          return Medal(
                            name: result[i].name,
                            result: result[i].result,
                            emoji: "🤦‍♀️",
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    snakeDirection != SnakeDirection.UP) {
                  snakeDirection = SnakeDirection.DOWN;
                } else if (details.delta.dy < 0 &&
                    snakeDirection != SnakeDirection.DOWN) {
                  snakeDirection = SnakeDirection.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    snakeDirection != SnakeDirection.LEFT) {
                  snakeDirection = SnakeDirection.RIGHT;
                } else if (details.delta.dx < 0 &&
                    snakeDirection != SnakeDirection.RIGHT) {
                  snakeDirection = SnakeDirection.LEFT;
                }
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: area,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const Snake();
                  } else if (foodPos == index) {
                    return const Food();
                  } else {
                    return const BlankField();
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    textColor: Colors.white,
                    onPressed: isStarted ? () {} : startGame,
                    color: isStarted ? Colors.grey : Colors.pink,
                    child: const Text("PLAY"),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(18.0),
                  //   child: MaterialButton(
                  //       onPressed: newGame,
                  //       color: Colors.amber,
                  //       child: const Text("Paly Again")),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
