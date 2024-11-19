import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:text_gradient/code.dart';
import 'package:text_gradient/loading_indicators.dart';
import 'package:text_gradient/animated_cross_over.dart';
import 'package:text_gradient/gradient-customizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const LoadingIndicatorsShowcase(),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(color: Colors.red, width: 50, height: 100),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(color: Colors.blue, height: 100),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(color: Colors.black, height: 100),
                ),
                Container(color: Colors.green, width: 50, height: 100),
                Container(color: Colors.green, width: 50, height: 100),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(color: Colors.red, width: 50, height: 100),
                Expanded(
                  child: Container(color: Colors.blue, height: 100),
                ),
                Expanded(
                  child: Container(color: Colors.black, height: 100),
                ),
                Container(color: Colors.green, width: 50, height: 100),
                Container(color: Colors.green, width: 50, height: 100),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

// class BoxShadowCustomizer extends StatefulWidget {
//   @override
//   _BoxShadowCustomizerState createState() => _BoxShadowCustomizerState();
// }

// class _BoxShadowCustomizerState extends State<BoxShadowCustomizer> {
//   Color shadowColor = Colors.white;
//   double spreadRadius = 0.0;
//   double blurRadius = 0.0;
//   double offsetX = 0.0;
//   double offsetY = 0.0;
//   bool enableShadow = true;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [],
//     );
//   }
// }

class ImageGridScreen extends StatelessWidget {
  const ImageGridScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Grid with Context Menu'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 10, // Number of images
        itemBuilder: (context, index) {
          return CupertinoContextMenu(
            actions: <Widget>[
              CupertinoContextMenuAction(
                child: SizedBox(),
                onPressed: () {
                  Navigator.pop(context);
                  // Add view functionality here
                },
              ),
              // CupertinoContextMenuAction(
              //   child: const Text('Share'),
              //   onPressed: () {
              //     Navigator.pop(context);
              //     // Add share functionality here
              //   },
              // ),
              // CupertinoContextMenuAction(
              //   child: const Text('Delete'),
              //   isDestructiveAction: true,
              //   onPressed: () {
              //     Navigator.pop(context);
              //     // Add delete functionality here
              //   },
              // ),
            ],
            child: Center(
              child: Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://picsum.photos/200/200?random=$index'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
