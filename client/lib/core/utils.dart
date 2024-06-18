import 'dart:io';

import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

String rbgToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xff000000);
}

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(content)),
    );
}

Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

void goToSong(
  BuildContext context,
) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return const MusicPlayer();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
          .animate(CurvedAnimation(parent: animation, curve: Curves.ease));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
  ));
}
