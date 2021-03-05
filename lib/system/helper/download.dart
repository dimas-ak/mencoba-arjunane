import 'dart:io';
import 'package:http/http.dart' as http;

class DownloadFile {
  static Future<void> downloadFile(String url, String fileName, String dir, {Function(int) beforeDownload, Function(DownloadInfo) onProgress, Function() onFinish, Function(StackTrace) onError}) async {
    try {
      final client = new http.Client();
      http.StreamedResponse response = await client.send(http.Request("GET", Uri.parse('$url')));

      File file = File("$dir/$fileName");

      var length = response.contentLength;
      var sink = file.openWrite();

      if(beforeDownload != null) beforeDownload(length);

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
}

class DownloadInfo {
  double size;
  double progress;
  int percent;
  DownloadInfo({this.size, this.progress, this.percent});
}