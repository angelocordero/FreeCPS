import 'package:flutter/material.dart';
import '../projector_layers/media_layer.dart';
import '../projector_layers/slide_layer.dart';

class ProjectorWindow extends StatelessWidget {
  const ProjectorWindow({super.key});

  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: const [
              MediaLayer(),
              SlideLayer(),
            ],
          ),
        ),
      ),
    );
  }
}
