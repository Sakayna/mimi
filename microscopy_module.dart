import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MaterialApp(home: ModuleScreen()));
}

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  _ModuleScreenPage createState() => _ModuleScreenPage();
}

class _ModuleScreenPage extends State<ModuleScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARLocationManager? arLocationManager;

  bool surfaceDetected = false;
  bool modelPlaced = false;
  bool showPlanes = true;
  bool showQuestion = false;
  bool showBaseDiscussion = false;
  bool showFineFocusQuestion = false;
  bool showFineFocusDiscussion = false;
  bool showCoarseFocusQuestion = false;
  bool showCoarseFocusDiscussion = false;
  bool showArmQuestion = false;
  bool showArmDiscussion = false;
  bool showEyepieceQuestion = false;
  bool showEyepieceDiscussion = false;
  bool showIlluminatorQuestion = false;
  bool showIlluminatorDiscussion = false;
  bool showDiaphragmQuestion = false;
  bool showDiaphragmDiscussion = false;
  bool showStageQuestion = false;
  bool showStageDiscussion = false;
  bool showObjectiveQuestion = false;
  bool showObjectiveDiscussion = false;
  bool showNosepieceQuestion = false;
  bool showNosepieceDiscussion = false;

  int baseDiscussionStep = 0;
  int fineFocusDiscussionStep = 0;
  int coarseFocusDiscussionStep = 0;
  int armDiscussionStep = 0;
  int eyepieceDiscussionStep = 0;
  int illuminatorDiscussionStep = 0;
  int diaphragmDiscussionStep = 0;
  int stageDiscussionStep = 0;
  int objectiveDiscussionStep = 0;
  int nosepieceDiscussionStep = 0;

  int wrongAnswers = 0;
  int correctAnswers = 0;
  ARNode? placedNode;
  List<bool> unlockedButtons = List.filled(10, false);

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            'AR Surface Detection',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          if (!surfaceDetected || !modelPlaced)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!surfaceDetected)
                    Column(
                      children: [
                        Icon(Icons.camera, size: 100, color: Colors.white),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Scan the surface and tap to start',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  if (surfaceDetected && !modelPlaced)
                    Column(
                      children: [
                        Icon(Icons.touch_app, size: 100, color: Colors.white),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Tap the screen to place the model',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          if (modelPlaced &&
              !showQuestion &&
              !showBaseDiscussion &&
              !showFineFocusDiscussion &&
              !showCoarseFocusDiscussion &&
              !showArmDiscussion &&
              !showEyepieceDiscussion &&
              !showIlluminatorDiscussion &&
              !showDiaphragmDiscussion &&
              !showStageDiscussion &&
              !showObjectiveDiscussion &&
              !showNosepieceDiscussion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Here is the model!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showQuestion = true;
                      });
                    },
                    child: Text('Continue'),
                  ),
                ],
              ),
            ),
          if (showQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "But first, can you answer this question?\nWhat part of the microscope is used to support it?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Condenser'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showQuestion = false;
                        showBaseDiscussion = true;
                        unlockedButtons[0] = true; // Unlock the first button
                      });
                    },
                    child: Text('Base'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Stage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Objective Lens'),
                  ),
                ],
              ),
            ),
          if (showBaseDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (baseDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The base of the microscope is used to support the microscope and keep it steady.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                baseDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (baseDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "It is important to place the microscope on a flat, stable surface to ensure accurate observations.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                baseDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (baseDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The base often contains the light source and other electronic components.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                baseDiscussionStep += 1;
                                showBaseDiscussion = false;
                                showFineFocusQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showFineFocusQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the fine focus?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Base'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showFineFocusQuestion = false;
                        showFineFocusDiscussion = true;
                        unlockedButtons[1] = true; // Unlock the second button
                      });
                    },
                    child: Text('Fine Focus'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Stage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Objective Lens'),
                  ),
                ],
              ),
            ),
          if (showFineFocusDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (fineFocusDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The fine focus knob is used to bring the specimen into sharp focus under low power.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                fineFocusDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (fineFocusDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "It is used to fine-tune the focus of the specimen after using the coarse focus.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                fineFocusDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (fineFocusDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The fine focus knob is typically smaller and located inside the coarse focus knob.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                fineFocusDiscussionStep += 1;
                                showFineFocusDiscussion = false;
                                showCoarseFocusQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showCoarseFocusQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the coarse focus?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Illuminator'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showCoarseFocusQuestion = false;
                        showCoarseFocusDiscussion = true;
                        unlockedButtons[2] = true; // Unlock the third button
                      });
                    },
                    child: Text('Coarse Focus'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Eyepiece'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Fine Focus'),
                  ),
                ],
              ),
            ),
          if (showCoarseFocusDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (coarseFocusDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The coarse focus knob is used to move the objective lenses toward or away from the specimen.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                coarseFocusDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (coarseFocusDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "It is typically larger than the fine focus knob.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                coarseFocusDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (coarseFocusDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The coarse focus knob is used to quickly bring the specimen into general focus.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                coarseFocusDiscussionStep += 1;
                                showCoarseFocusDiscussion = false;
                                showArmQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showArmQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the arm?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Stage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showArmQuestion = false;
                        showArmDiscussion = true;
                        unlockedButtons[3] = true; // Unlock the fourth button
                      });
                    },
                    child: Text('Arm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Illuminator'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),
          if (showArmDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (armDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The arm supports the tube and connects it to the base.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                armDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (armDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "It is used to carry the microscope.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                armDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (armDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The arm is usually one of the sturdiest parts of the microscope.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                armDiscussionStep += 1;
                                showArmDiscussion = false;
                                showEyepieceQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showEyepieceQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the eyepiece?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Fine Focus'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showEyepieceQuestion = false;
                        showEyepieceDiscussion = true;
                        unlockedButtons[4] = true; // Unlock the fifth button
                      });
                    },
                    child: Text('Eyepiece'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Coarse Focus'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Stage'),
                  ),
                ],
              ),
            ),
          if (showEyepieceDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (eyepieceDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The eyepiece, or ocular lens, is the lens at the top that you look through.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                eyepieceDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (eyepieceDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "They are usually 10x or 15x power.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                eyepieceDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (eyepieceDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The eyepiece tube holds the eyepieces in place above the objective lens.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                eyepieceDiscussionStep += 1;
                                showEyepieceDiscussion = false;
                                showIlluminatorQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showIlluminatorQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the illuminator?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Eyepiece'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showIlluminatorQuestion = false;
                        showIlluminatorDiscussion = true;
                        unlockedButtons[5] = true; // Unlock the sixth button
                      });
                    },
                    child: Text('Illuminator'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Stage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Nosepiece'),
                  ),
                ],
              ),
            ),
          if (showIlluminatorDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (illuminatorDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The illuminator is the light source for a microscope, typically located in the base.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                illuminatorDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (illuminatorDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "It focuses light on the specimen, providing bright, even illumination.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                illuminatorDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (illuminatorDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "Modern microscopes use LED lights for longer life and consistent color temperature.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                illuminatorDiscussionStep += 1;
                                showIlluminatorDiscussion = false;
                                showDiaphragmQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showDiaphragmQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the diaphragm?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Eyepiece'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showDiaphragmQuestion = false;
                        showDiaphragmDiscussion = true;
                        unlockedButtons[6] = true; // Unlock the seventh button
                      });
                    },
                    child: Text('Diaphragm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Illuminator'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Fine Focus'),
                  ),
                ],
              ),
            ),
          if (showDiaphragmDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (diaphragmDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The diaphragm controls the amount of light reaching the specimen.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                diaphragmDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (diaphragmDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "It can be adjusted to improve contrast and resolution.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                diaphragmDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (diaphragmDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The diaphragm is typically located under the stage.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                diaphragmDiscussionStep += 1;
                                showDiaphragmDiscussion = false;
                                showStageQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showStageQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the stage?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Diaphragm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showStageQuestion = false;
                        showStageDiscussion = true;
                        unlockedButtons[7] = true; // Unlock the eighth button
                      });
                    },
                    child: Text('Stage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Illuminator'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),
          if (showStageDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (stageDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The stage is where the specimen is placed for viewing.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                stageDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (stageDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "Stage clips hold the slides in place.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                stageDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (stageDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "Mechanical stages can be moved precisely in small increments.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                stageDiscussionStep += 1;
                                showStageDiscussion = false;
                                showObjectiveQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showObjectiveQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the objective lens?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Stage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showObjectiveQuestion = false;
                        showObjectiveDiscussion = true;
                        unlockedButtons[8] = true; // Unlock the ninth button
                      });
                    },
                    child: Text('Objective Lens'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Illuminator'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),
          if (showObjectiveDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (objectiveDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "Objective lenses are the primary optical lenses on a microscope.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                objectiveDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (objectiveDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "They range from 4x to 100x magnification.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                objectiveDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (objectiveDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The objective lenses are color-coded for different magnifications.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                objectiveDiscussionStep += 1;
                                showObjectiveDiscussion = false;
                                showNosepieceQuestion = true;
                              });
                            },
                            child: Text('Proceed with the next part'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showNosepieceQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Can you answer this question?\nWhich part of the microscope is the nosepiece?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Objective Lens'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        correctAnswers += 1;
                        showNosepieceQuestion = false;
                        showNosepieceDiscussion = true;
                        unlockedButtons[9] = true; // Unlock the tenth button
                      });
                    },
                    child: Text('Nosepiece'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Stage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        wrongAnswers += 1;
                      });
                    },
                    child: Text('Illuminator'),
                  ),
                ],
              ),
            ),
          if (showNosepieceDiscussion)
            Positioned(
              bottom: 150, // Adjusted to move above the buttons
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    if (nosepieceDiscussionStep == 0)
                      Column(
                        children: [
                          Text(
                            "The nosepiece, also known as the revolving turret, holds the objective lenses.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                nosepieceDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (nosepieceDiscussionStep == 1)
                      Column(
                        children: [
                          Text(
                            "It allows the user to rotate different objective lenses into position.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                nosepieceDiscussionStep += 1;
                              });
                            },
                            child: Text('>'),
                          ),
                        ],
                      ),
                    if (nosepieceDiscussionStep == 2)
                      Column(
                        children: [
                          Text(
                            "The nosepiece ensures that each objective lens is correctly aligned with the eyepiece.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          // Positioning the buttons at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 10; i++)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: unlockedButtons[i]
                                ? () {
                                    // Handle button press
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              backgroundColor: unlockedButtons[i]
                                  ? Colors.green
                                  : Colors.grey, // Background color
                            ),
                            child: unlockedButtons[i]
                                ? Image.asset(
                                    'assets/lesson1&2/assets/${[
                                      'base',
                                      'fine',
                                      'coarse',
                                      'arm',
                                      'eye',
                                      'lamp',
                                      'diaphragm',
                                      'stage',
                                      'objective',
                                      'nose'
                                    ][i]}/${[
                                      'base',
                                      'fine',
                                      'coarse',
                                      'arm',
                                      'eye',
                                      'lamp',
                                      'diaphragm',
                                      'stage',
                                      'objective',
                                      'nose'
                                    ][i]}.png',
                                    width: 40,
                                    height: 40,
                                  )
                                : Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                          ),
                          if (unlockedButtons[i])
                            Text(
                              [
                                'Base',
                                'Fine Focus',
                                'Coarse Focus',
                                'Arm',
                                'Eyepiece',
                                'Illuminator',
                                'Diaphragm',
                                'Stage',
                                'Objective',
                                'Nosepiece'
                              ][i],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              'Wrong: $wrongAnswers  Correct: $correctAnswers',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(showPlanes ? Icons.visibility : Icons.visibility_off),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  showPlanes = !showPlanes;
                  if (arSessionManager != null) {
                    arSessionManager!.onInitialize(
                      showFeaturePoints: false,
                      showPlanes: showPlanes,
                      showWorldOrigin: false,
                      handlePans: false,
                      handleScale: false,
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arLocationManager = arLocationManager;

    print("ARView created");

    this.arSessionManager!.onInitialize(
          showFeaturePoints: true,
          showPlanes: true,
          showWorldOrigin: false,
          handlePans: false,
          handleScale: false,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap =
        (List<ARHitTestResult> hitTestResults) {
      print("Plane or point tapped");

      if (!surfaceDetected) {
        setState(() {
          surfaceDetected = true;
        });
      } else if (!modelPlaced) {
        ARHitTestResult? singleHitTestResult;
        try {
          singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
          );
        } catch (e) {
          singleHitTestResult = null;
        }

        if (singleHitTestResult != null) {
          print("Hit test result found: $singleHitTestResult");
          // Extract the translation and rotation from the hit test result
          var translation =
              singleHitTestResult.worldTransform!.getTranslation();
          var rotation = singleHitTestResult.worldTransform!.getRotation();
          var rotationQuaternion = vector.Quaternion.fromRotation(rotation);

          // Create and add a 3D node at the tap location
          var newNode = ARNode(
            type: NodeType.localGLTF2,
            uri: "assets/lesson1&2/assets/lens/lens.gltf",
            scale: vector.Vector3(0.1, 0.1, 0.1),
            position: translation,
            rotation: vector.Vector4(
              rotationQuaternion.x,
              rotationQuaternion.y,
              rotationQuaternion.z,
              rotationQuaternion.w,
            ),
          );

          print("Adding 3D node: $newNode");

          arObjectManager.addNode(newNode).then((didAddNode) {
            if (didAddNode!) {
              print("3D model added to the scene.");
              setState(() {
                modelPlaced = true;
                placedNode = newNode;
                // Turn off plane detection when the model is placed
                if (arSessionManager != null) {
                  arSessionManager!.onInitialize(
                    showFeaturePoints: false,
                    showPlanes: false,
                    showWorldOrigin: false,
                    handlePans: false,
                    handleScale: false,
                  );
                }
              });
            } else {
              arSessionManager.onError("Failed to add 3D model.");
            }
          }).catchError((error) {
            print("Error adding 3D node: $error");
            arSessionManager.onError("Failed to add 3D model: $error");
          });
        } else {
          print("No hit test result found.");
        }
      }
    };
  }
}
