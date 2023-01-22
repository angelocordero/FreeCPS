import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectionSlideTextWidget extends StatelessWidget {
  const ProjectionSlideTextWidget({super.key, required this.text, required this.reference});

  final String text;
  final String reference;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 1080,
      width: 1920,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'LemonMilk',
                    fontSize: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (reference.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    reference,
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
