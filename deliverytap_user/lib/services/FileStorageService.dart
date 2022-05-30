import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as path;

Future<String> uploadFile({Uint8List? bytes, dynamic blob, File? file, String prefix = mFirebaseStorageFilePath}) async {
  if (blob == null && file == null) {
    throw errorSomethingWentWrong;
  }

  if (prefix.isNotEmpty && !prefix.endsWith('/')) {
    prefix = '$prefix';
  }
  String fileName = currentTimeStamp().toString();
  if (file != null) {
    fileName = '${path.basename(file.path)}';
  }

  Reference storageReference = FirebaseStorage.instance.ref(mFirebaseStorageFilePath).child('$fileName.png');

  log(storageReference.fullPath);

  UploadTask? uploadTask;

  if (file != null) {
    uploadTask = storageReference.putFile(file);
  } else if (blob != null) {
    uploadTask = storageReference.putBlob(blob);
  } else if (bytes != null) {
    uploadTask = storageReference.putData(bytes, SettableMetadata(contentType: 'image/png'));
  }

  if (uploadTask == null) throw errorSomethingWentWrong;

  log('File Uploading');

  return await uploadTask.then((v) async {
    log('File Uploaded');

    if (v.state == TaskState.success) {
      String url = await storageReference.getDownloadURL();

      log(url);

      return url;
    } else {
      throw errorSomethingWentWrong;
    }
  }).catchError((error) {
    throw error;
  });
}
