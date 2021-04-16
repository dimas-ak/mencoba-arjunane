import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Request {
  static void post(String url, void Function(_GetRequest) callback,
          {Map<String, String> headers,
          dynamic body,
          Encoding encoding}) async =>
      await _req(
          url: url,
          method: "POST",
          body: body,
          encoding: encoding,
          headers: headers,
          cb: (_gr) => callback(_gr));

  static void get(String url, void Function(_GetRequest) callback,
          {Map<String, String> headers}) async =>
      await _req(
          url: url, method: "GET", headers: headers, cb: (gr) => callback(gr));

  static void put(String url, void Function(_GetRequest) callback,
          {Map<String, String> headers,
          dynamic body,
          Encoding encoding}) async =>
      await _req(
          url: url,
          method: "GET",
          body: body,
          encoding: encoding,
          headers: headers,
          cb: (gr) => callback(gr));

  static void delete(String url, void Function(_GetRequest) callback,
          {Map<String, String> headers}) async =>
      await _req(
          url: url, method: "GET", headers: headers, cb: (gr) => callback(gr));

  static Future _req(
      {String url,
      void Function(_GetRequest) cb,
      String method = "POST",
      Map<String, String> headers,
      dynamic body,
      Encoding encoding}) async {
    _GetRequest gr = new _GetRequest();

    gr.error = null;
    gr.response = null;

    var result;
    try {
      Uri uri = Uri.parse(url);
      if (method == "POST")
        result = await http.post(uri,
            body: body, encoding: encoding, headers: headers);
      else if (method == "DELETE")
        result = await http.delete(uri, headers: headers);
      else if (method == "PUT")
        result = await http.put(uri,
            body: body, encoding: encoding, headers: headers);
      else if (method == "GET") result = await http.get(uri, headers: headers);
      if (result.statusCode == 200) {
        gr.isSuccess = true;
        gr.response = result.body;
      } else {
        gr.error = result.body;
      }
      gr.isRedirect = result.isRedirect;
      gr.statusCode = result.statusCode;
    } on SocketException catch (e) {
      gr.error = e.message;
    }
    cb(gr);
  }
}

class _GetRequest {
  bool isSuccess = false;
  String response;
  String error;
  int statusCode;
  bool isRedirect;
}
