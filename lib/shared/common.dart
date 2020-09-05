import 'dart:io';

import 'package:image_picker/image_picker.dart';

double PERCENT(w, per){
  return (w * per) / 100;
}

Future pickImage(source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: source);

  return {
    'file': File(pickedFile.path),
  };
}