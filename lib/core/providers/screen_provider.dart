import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenProvider {
  final double width;
  final double height;
  final bool isSmallPhone;
  final bool isStandardPhone;
  final bool isTablet;

  ScreenProvider({
    required this.width,
    required this.height,
    required this.isSmallPhone,
    required this.isStandardPhone,
    required this.isTablet,
  });
}

final screenProvider = Provider<ScreenProvider>((ref) {
  throw UnimplementedError();
});
