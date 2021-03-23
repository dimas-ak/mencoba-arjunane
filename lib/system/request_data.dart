class RequestData {

  bool has(String key) {

    if(RequestInit.dataPages[RequestInit.currentPage] == null) return false;

    bool isExist = false;

    RequestInit.dataPages[RequestInit.currentPage].forEach((key, value) {
      if( key == key ) isExist = true;
    });
    return isExist;
  }

  dynamic get(String key) {

    if(RequestInit.dataPages[RequestInit.currentPage] == null) return null;

    dynamic data;

    RequestInit.dataPages[RequestInit.currentPage].forEach((key, value) {
      if( key == key ) data = value;
    });
    return data;
  }

  Map<String, dynamic> all() {
    Map<String, dynamic> data = {};
    if(RequestInit.dataPages[RequestInit.currentPage] == null) return data;

    RequestInit.dataPages[RequestInit.currentPage].forEach((key, value) {
      data[key] = value;
    });
    return data;
  }

}

class RequestInit {
  static Map<String, Map<String, dynamic>> dataPages = {};

  static String currentPage = "";

  // menghapus data static dari dataPages
  // deleteData akan di eksekusi pada saat onWilPopScope
  static void onBack() {
    if(dataPages.length > 0) {
      var lastKey = dataPages.keys.last;
      dataPages.removeWhere((key, value) => key == lastKey);

      currentPage = dataPages.keys.last;
    }
  }

  static dynamic getData(String key) {
    
  }

  // isClear = true jika Redirect.route('halaman-baru')
  // menuju ke halaman baru

  // jika isClear = false jika Redirect.forward('halaman')
  // menuju ke halaman baru
  static void setPage(Map<String, dynamic> data, {bool isClear = false}) {
    if(isClear) dataPages.clear();

    dataPages[currentPage] = data;
  }
}