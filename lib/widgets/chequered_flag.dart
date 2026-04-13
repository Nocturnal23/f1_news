import 'package:flutter/material.dart';

class ChequeredFlag extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintWhite = Paint()..color = Colors.white;
    final paintBlack = Paint()..color = Colors.black;

    const squareSize = 5.0; //Questo determina le dimensione dei quadrati.

    for (double y = 0; y < size.height; y += squareSize) {
      for (double x = 0; x < size.width; x += squareSize) {
        /*
        Creazione del pattern. Con la divisione intera viene preso l'indice
        della cella su cui fare il digno. Il resto determina l'alternanza
        del patteren
         */
        final isBlack = ((x ~/ squareSize) + (y ~/ squareSize)) % 2 == 0;
        /*
        Qui viene disegnato il quadrato nella posizione.
         */
        canvas.drawRect(
          Rect.fromLTWH(x, y, squareSize, squareSize),
          isBlack ? paintBlack : paintWhite,
        );
      }
    }
  }

  @override
  /* Questo determina se il pattern va ridisegnato o meno.
  In base ai thread trovati questo è false nel mio caso
  perchè il mio pattern è statico.
   */
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}