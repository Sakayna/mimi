import 'package:capstone/Module%20Contents/Microscopy/Microscopy_AT/Microscopy_AT_1_1/Microscopy_AT_Quiz_1_Content.dart';
import 'package:capstone/Module%20Contents/Microscopy/Microscopy_AT/Microscopy_AT_1_2/Microscopy_AT_1_2.dart';
import 'package:capstone/Module%20Contents/Microscopy/Microscopy_TLA/Microscopy_TLA_1_2.dart';
import 'package:capstone/categories/microscopy_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone/globals/global_variables_notifier.dart';

class Microscopy_AT_1_1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var globalVariables = Provider.of<GlobalVariables>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicroscopyScreen(),
          ),
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Color(0xFFFFA551), // Background color of appbar
                    floating: false,
                    pinned: false,
                    snap: false,
                    expandedHeight: 120.0, // Adjusted expanded height
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final isTop = constraints.biggest.height <= kToolbarHeight + 16.0; // Margin size

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isTop) ...[
                              // Only show when expanded (not at the top)
                              Padding(
                                padding: const EdgeInsets.only(top: 25.0, left: 50.0), // Add left padding
                                child: Text(
                                  'Microscopy', // Title text for the appbar
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white, // Set text color to white
                                  ),
                                ),
                              ),
                              SizedBox(height: 5), // Adjusted spacing between texts
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0), // Add left padding
                                child: Text(
                                  'Teaching Learning Activity', // Subtitle text for the appbar
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white, // Set text color to white
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0, right: 18.0), // Add left padding
                                child: Text(
                                  'AT 1.1', // Additional text for the appbar
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white, // Set text color to white
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 20), // Adjusted top padding of the leading icon
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.white, // Back button icon color
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MicroscopyScreen(),
                          ));
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 150.0, left: 20, right: 20),
                    sliver: SliverPadding(
                      padding: EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Instructions: In this identification-based quiz, your task is to recognize and label the various components of the microscope. Review the provided image and corresponding functions carefully, then identify each part accordingly. Pay close attention to details and use your knowledge of microscope anatomy to accurately label each component.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Microscopy_AT_Quiz_1_Content(),
                                    ));
                                  },
                                  child: Text('Take Quiz'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white, // Set the background color to white
          width: double.infinity, // Set the width to fill the screen
          padding: EdgeInsets.symmetric(vertical: 16.0), // Add padding vertically
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0), // Adjusted left padding
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Microscopy_TLA_1_2(),
                      ),
                    );
                  },
                  heroTag: 'prevBtn',
                  child: Icon(
                    Icons.navigate_before,
                    color: Colors.white, // Set icon color to white
                  ),
                  backgroundColor: Color(0xFFFFA551),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0), // Adjusted right padding
                child: Opacity(
                  opacity: globalVariables.getQuizTaken('lesson1', 1) ? 1.0 : 0.5,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (globalVariables.getQuizTaken('lesson1', 1)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Microscopy_AT_1_2(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Quiz not taken'),
                            content: Text(
                              'Please take the quiz for this lesson before proceeding to the next lesson.',
                            ),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    heroTag: 'nextBtn',
                    child: Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ),
                    backgroundColor: Color(0xFFFFA551),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
