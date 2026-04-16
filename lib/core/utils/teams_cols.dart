import 'package:flutter/material.dart';

class TeamsCols {
  static const Map<String, Map<String, Color>> colors = {
    'ferrari': {
      'background' : Color(0xFFe8002d),
      'foreground' : Color(0xFF5c0012),
    },
    'red_bull': {
      'background' : Color(0xFF3671c6),
      'foreground' : Color(0xFF142948),
    },
    'mercedes': {
      'background' : Color(0xFF27f4d2),
      'foreground' : Color(0xFF067e6a),
    },
    'mclaren': {
      'background' : Color(0xFFff8000),
      'foreground' : Color(0xFF804000),
    },
    'aston_martin': {
      'background' : Color(0xFF229971),
      'foreground' : Color(0xFF0f4331),
    },
    'alpine': {
      'background' : Color(0xFF00a1e8),
      'foreground' : Color(0xFF004e70),
    },
    'williams': {
      'background' : Color(0xFF1868db),
      'foreground' : Color(0xFF082145),
    },
    'rb': {
      'background' : Color(0xFF6692ff),
      'foreground' : Color(0xFF0038c2),
    },
    'audi': {
      'background' : Color(0xFFff2d00),
      'foreground' : Color(0xFF751500),
    },
    'haas': {
      'background' : Color(0xFFdee1e2),
      'foreground' : Color(0xFF667175),
    },
    'cadillac': {
      'background' : Color(0xFFaaaaad),
      'foreground' : Color(0xFF58585b),
    },
  };

  //Da qui prendo i colori, se l'id non esiste allora pendo il grigio come default.
  static Color getBackground(String teamId) {
    return colors[teamId]?['background'] ?? Colors.grey.shade800;
  }

  static Color getForeground(String teamId) {
    return colors[teamId]?['foreground'] ?? Colors.grey;
  }
}