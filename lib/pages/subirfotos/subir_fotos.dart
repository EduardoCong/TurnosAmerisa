import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';


final FirebaseStorage storage = FirebaseStorage.instance;

Future<String?> uploadImage(File image) async {
  try {
    final uuid = Uuid();
    final String uniqueId = uuid.v4();
    final String nameFotos = '${uniqueId}_${image.path.split("/").last}';
    final Reference upload = storage.ref().child("images").child(nameFotos);
    final UploadTask uploadTask = upload.putFile(image);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    final String url = await snapshot.ref.getDownloadURL();
    print('URL de la imagen: $url');

    return url;
  } catch (e) {
    print('Error subiendo la imagen: $e');
    return null;
  }
}
