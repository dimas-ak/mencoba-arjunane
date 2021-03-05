class FlashData
{
  static Map<String, dynamic> _data = new Map<String, dynamic>();

  static void setData(String key, dynamic data) {
    _data[key] = _data;
  }

  static dynamic getData(String key) {
    var dt = _data.containsKey(key) ? _data[key] : null;
    _data.removeWhere( (_key, _val) => _key == key );
    return dt;
  }

  
}