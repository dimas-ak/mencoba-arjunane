import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FileServer {

  static Future<void> downloadFile(String url, String fileName, String dir, {Function(int) onBefore, Function(DownloadInfo) onProgress, Function() onFinish, Function(StackTrace) onError}) async {
    try {
      final client = new http.Client();
      http.StreamedResponse response = await client.send(http.Request("GET", Uri.parse('$url')));

      File file = File("$dir/$fileName");

      var length = response.contentLength;
      var sink = file.openWrite();

      if(onBefore != null) onBefore(length);

      Future.doWhile(() async {
        var received = await file.length();
        var percent = ((received / length) * 100).toStringAsFixed(0);
        if(onProgress != null) onProgress(new DownloadInfo(progress: received.toDouble(), size: length.toDouble(), percent: int.parse(percent)));
        return received != length;
      });
      //print("File Path : " + file.path);
      await response.stream.pipe(sink);
      if(onFinish != null) onFinish();
    } catch (e, stack) {
      if(onError != null) onError(stack);
    }
  }

  static Future<void> uploadFile(String url, String name, File file, {Function() onBefore, Function() onProgress, Function() onFinish, Function(StackTrace) onError}) async {

    var uri = Uri.parse('$url');

    var stream = new http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('$name', stream, length,
        filename: file.path.split('/').last);
        //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}

class DownloadInfo {
  double size;
  double progress;
  int percent;
  DownloadInfo({this.size, this.progress, this.percent});
}