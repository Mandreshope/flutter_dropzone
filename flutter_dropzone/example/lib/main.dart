import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DropzoneViewController controller1;
  DropzoneViewController controller2;
  Uint8List bytes;
  String message1 = 'Drop something here';
  String message2 = 'Drop something here';
  bool highlighted1 = false;
  int tick = 0;
  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          tick++;
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Dropzone example'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: 100,
                    width: double.infinity,
                    child: bytes == null
                        ? Container()
                        : Image.memory(bytes, errorBuilder:
                            (BuildContext context, Object exception,
                                StackTrace stackTrace) {
                            // Appropriate logging or analytics, e.g.
                            // myAnalytics.recordError(
                            //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                            //   exception,
                            //   stackTrace,
                            // );
                            return Text(
                              'Error loading image url',
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            );
                          })),
                Container(
                  height: 50,
                  width: double.infinity,
                  color: highlighted1 ? Colors.red : Colors.transparent,
                  child: Stack(
                    children: [
                      buildZone1(context),
                      Center(child: Text(message1)),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Text('widget rebuild time : ' + tick.toString()),
                      )
                    ],
                  ),
                ),
                // Expanded(
                //   child: Stack(
                //     children: [
                //       buildZone2(context),
                //       Center(child: Text(message2)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );

  Widget buildZone1(BuildContext context) => Builder(
      builder: (context) => DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (ctrl) {
              controller1 = ctrl;
              print('viewId: ${controller1.viewId}');
            },
            onLoaded: () => print('Zone 1 loaded'),
            onError: (ev) => print('Zone 1 error: $ev'),
            onHover: () {
              setState(() => highlighted1 = true);
              print('Zone 1 hovered');
            },
            onLeave: () {
              setState(() => highlighted1 = false);
              print('Zone 1 left');
            },
            onDrop: (ev) {
              print('Zone 1 drop: ${ev.name}');
              setState(() {
                message1 = '${ev.name} dropped';
                highlighted1 = false;
              });
            },
            onImgDrop: (event) {
              print('Zone 1 onImgDrop: called');
              setState(() {
                bytes = event;
                highlighted1 = false;
              });
            },
          ));

  Widget buildZone2(BuildContext context) => Builder(
        builder: (context) => DropzoneView(
          operation: DragOperation.move,
          onCreated: (ctrl) {
            controller2 = ctrl;
            print(controller2.viewId);
          },
          onLoaded: () => print('Zone 2 loaded'),
          onError: (ev) => print('Zone 2 error: $ev'),
          onHover: () => print('Zone 2 hovered'),
          onLeave: () => print('Zone 2 left'),
          onDrop: (ev) {
            print('Zone 2 drop: ${ev.name}');
            setState(() {
              message2 = '${ev.name} dropped';
            });
          },
          onImgDrop: (event) {
            print('Zone 2 onImgDrop called');
            setState(() {
              bytes = event;
            });
          },
        ),
      );
}
