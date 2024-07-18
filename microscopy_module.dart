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
  bool showSuccessMessage = false;
  bool showNewModel = false;
  bool showFineFocusQuestion = false;
  bool showBaseDiscussion = false;
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
                        Text(
                          'Scan the surface and tap to start',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            backgroundColor: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  if (surfaceDetected && !modelPlaced)
                    Column(
                      children: [
                        Icon(Icons.touch_app, size: 100, color: Colors.white),
                        SizedBox(height: 20),
                        Text(
                          'Tap the screen to place the model',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            backgroundColor: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          if (modelPlaced &&
              !showQuestion &&
              !showNewModel &&
              !showFineFocusQuestion &&
              !showBaseDiscussion &&
              !showCoarseFocusDiscussion &&
              !showCoarseFocusQuestion &&
              !showArmQuestion &&
              !showEyepieceDiscussion &&
              !showEyepieceQuestion &&
              !showIlluminatorQuestion &&
              !showDiaphragmQuestion &&
              !showDiaphragmDiscussion &&
              !showStageQuestion &&
              !showStageDiscussion &&
              !showObjectiveQuestion &&
              !showObjectiveDiscussion &&
              !showNosepieceQuestion &&
              !showNosepieceDiscussion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Here is the model!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                  Text(
                    "But first, can you answer this question?\nWhat part of the microscope is used to support it?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                        showNewModel = true;
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
                            "Make sure the base is clean and free from dust to maintain a clear view through the lenses.",
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
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is used for fine focusing?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
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
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),

// Code for the fine focus discussion
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
                            "The fine focus knob is used for precise focusing once the coarse focus has been used.",
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
                            "It allows for slight movement of the stage to sharpen the focus of the specimen.",
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
                            "Use the fine focus knob with high power objectives to avoid damaging the slides.",
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
          // Code for the coarse focus question
          if (showCoarseFocusQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is used for coarse focusing?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Stage'),
                  ),
                ],
              ),
            ),

// Code for the coarse focus discussion
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
                            "The coarse focus knob is used to bring the specimen into general focus.",
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
                            "It moves the stage up and down to help you get the specimen in focus.",
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
                            "Use the coarse focus knob only with low power objectives to prevent damage to the slides.",
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
          // Code for the arm question
          if (showArmQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is known as the arm?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),

// Code for the arm discussion
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
                            "The arm of the microscope connects the base to the head and provides support for the optical components.",
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
                            "It is important to hold the arm when carrying the microscope to ensure stability and avoid damage.",
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
                            "The arm also supports the stage and adjustment knobs, making it a crucial part of the microscope's structure.",
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
          // Code for the eyepiece question
          if (showEyepieceQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is the eyepiece?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Stage'),
                  ),
                ],
              ),
            ),

// Code for the eyepiece discussion
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
                            "The eyepiece is the part of the microscope where you place your eye to observe the specimen.",
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
                            "It contains a lens that magnifies the image of the specimen.",
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
                            "The eyepiece tube holds the eyepiece in place.",
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
          // Code for the illuminator question
          if (showIlluminatorQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is the illuminator?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Coarse Focus'),
                  ),
                ],
              ),
            ),

// Code for the illuminator discussion
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
                            "It projects light upwards through the diaphragm, the specimen, and the lenses.",
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
                            "Adjusting the illuminator's intensity can improve the visibility and contrast of the specimen.",
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
          // Code for the diaphragm question
          if (showDiaphragmQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is the diaphragm?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),

// Code for the diaphragm discussion
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
                            "The diaphragm is used to vary the intensity and size of the cone of light projected.",
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
                            "It is located under the stage, just above the light source.",
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
                            "Adjusting the diaphragm helps improve contrast and detail in the image.",
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
          // Code for the stage question
          if (showStageQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is the stage?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),

// Code for the stage discussion
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
                            "The stage is the flat platform where you place your slides.",
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
                            "You can move the stage left, right, forward, and backward to view different areas of the slide.",
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

// Code for the objective lenses question
          if (showObjectiveQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is the objective lens?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Eyepiece'),
                  ),
                ],
              ),
            ),

// Code for the objective lenses discussion
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
                            "They range from 4x to 100x and typically include 3 to 4 lenses.",
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
                            "The lenses are color-coded and screwed into the nosepiece.",
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
          // Code for the nosepiece question
          if (showNosepieceQuestion)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Can you answer this question?\nWhich part of the microscope is the nosepiece?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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
                    child: Text('Illuminator'),
                  ),
                ],
              ),
            ),

// Code for the nosepiece discussion
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
                            "The nosepiece holds the objective lenses and allows you to switch between them.",
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
                            "It is located just above the stage and below the eyepiece.",
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
                            "Rotating the nosepiece changes the magnification power by switching the objective lenses.",
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
                                showNosepieceDiscussion = false;
                                // End of the process
                              });
                            },
                            child: Text('Finish'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          if (showNewModel ||
              showBaseDiscussion ||
              showFineFocusQuestion ||
              showCoarseFocusDiscussion ||
              showCoarseFocusQuestion ||
              showArmQuestion ||
              showEyepieceDiscussion ||
              showEyepieceQuestion ||
              showIlluminatorQuestion ||
              showDiaphragmQuestion ||
              showDiaphragmDiscussion ||
              showStageQuestion ||
              showStageDiscussion ||
              showObjectiveQuestion ||
              showObjectiveDiscussion ||
              showNosepieceQuestion ||
              showNosepieceDiscussion)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(10, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: unlockedButtons[index]
                                  ? () {
                                      // Handle button press
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                              child: unlockedButtons[index]
                                  ? Image.asset(
                                      index == 0
                                          ? 'assets/lesson1&2/assets/base/base.png'
                                          : index == 1
                                              ? 'assets/lesson1&2/assets/fine/fine.png'
                                              : index == 2
                                                  ? 'assets/lesson1&2/assets/coarse/coarse.png'
                                                  : index == 3
                                                      ? 'assets/lesson1&2/assets/arm/arm.png'
                                                      : index == 4
                                                          ? 'assets/lesson1&2/assets/eye/eye.png'
                                                          : index == 5
                                                              ? 'assets/lesson1&2/assets/lamp/illuminator.png'
                                                              : index == 6
                                                                  ? 'assets/lesson1&2/assets/diaphragm/diaphragm.png'
                                                                  : index == 7
                                                                      ? 'assets/lesson1&2/assets/stage/stage.png'
                                                                      : index ==
                                                                              8
                                                                          ? 'assets/lesson1&2/assets/objective/objective.png'
                                                                          : 'assets/lesson1&2/assets/nose/nose.png', // Path to the respective images
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    )
                                  : Icon(Icons.help_outline,
                                      size: 40), // "?" icon
                            ),
                            if (unlockedButtons[index])
                              Text(
                                index == 0
                                    ? 'Base'
                                    : index == 1
                                        ? 'Fine Focus'
                                        : index == 2
                                            ? 'Coarse Focus'
                                            : index == 3
                                                ? 'Arm'
                                                : index == 4
                                                    ? 'Eyepiece'
                                                    : index == 5
                                                        ? 'Illuminator'
                                                        : index == 6
                                                            ? 'Diaphragm'
                                                            : index == 7
                                                                ? 'Stage'
                                                                : index == 8
                                                                    ? 'Objective'
                                                                    : 'Nosepiece',
                                style: TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                      );
                    }),
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
          var translation = singleHitTestResult.worldTransform.getTranslation();
          var rotation = singleHitTestResult.worldTransform.getRotation();
          var rotationQuaternion = vector.Quaternion.fromRotation(rotation);

          // Create and add a 3D node at the tap location
          var newNode = ARNode(
            type: NodeType.localGLTF2,
            uri: showNewModel
                ? "assets/lesson1&2/assets/lenses/4x/4x.gltf"
                : "assets/lesson1&2/assets/lens/lens.gltf",
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

class InstructionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instructions: Move your camera until white dots appear on the screen. These dots indicate detected surfaces. Once a surface is detected, tap on it to start.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
