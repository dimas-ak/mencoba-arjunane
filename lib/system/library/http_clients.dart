
import 'dart:core';
import 'dart:io';
// WIP
class HttpClients {
  
  // String _url;

  // static Future<HttpServer> _init(String url, {int port = 80 }) async {
  //   var splitAddress = url.split("://");
  //   if(splitAddress.length == 1) {
  //     print("Ops, something went wrong\nYour url : $url not valid.");
  //     return null;
  //   }

  //   var server;

  //   String typeAddress = splitAddress[0];

  //   if(typeAddress == "https") {
  //     SecurityContext context = new SecurityContext();
  //     var chain =
  //         Platform.script.resolve('certificates/server_chain.pem')
  //         .toFilePath();
  //     var key =
  //         Platform.script.resolve('certificates/server_key.pem')
  //         .toFilePath();
  //     context.useCertificateChain(chain);
  //     context.usePrivateKey(key, password: 'dartdart');

  //     server = HttpServer
  //         .bindSecure(InternetAddress.anyIPv6,
  //                     443,
  //                     context);
  //   }
  //   else {
  //     server = await HttpServer.bind(url, port);
  //   }
  //   return server;
  // }

  // static Future<HttpServer> _initServerSecure() {

  // }

  static Future<HttpServer> _initServer(String url, {int port = 80 }) async {
    return await HttpServer.bind(url, port);
  }

  static bool? _isSecure(String url) {
    var splitAddress = url.split("://");
    if(splitAddress.length == 1) {
      print("Ops, something went wrong\nYour url : $url not valid.");
      return null;
    }

    return splitAddress[0] == "https";
  }

  static Future send(String url, { HttpClientsMethod method = HttpClientsMethod.GET }) async {

    if(_isSecure(url) == null) return;
    
    if(_isSecure(url)!) {

    }
    else await _initServer(url).then( (res) {
      
    });
  }

}

enum HttpClientsMethod {
  GET,
  POST,
  PUT,
  DELETE
}