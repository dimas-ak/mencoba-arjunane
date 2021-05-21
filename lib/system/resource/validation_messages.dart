class ValidationMessage {
  static final Map<String, Map<String, String>> validationMessages = {
    "id" : {
      "in" :                 "{field} tidak valid.",
      "ip" :                 "{field} tidak valid.",
      "gt" :                 "{field} harus lebih besar dari {param}.", //Greater Than
      "lt" :                 "{field} harus lebih kecil dari {param}.", //Lower Than
      "gte" :                "{field} harus lebih besar dari sama dengan {param}.", //Greater Than or Equal
      "lte" :                "{field} harus lebih kecil dari sama dengan {param}.", //Lower Than or Equal//Lower Than or Equal
      "max" :                "Maksimal Angka dari {field} ialah {param}.",
      "min" :                "Minimal Angka dari {field} ialah {param}.",
      "url" :                "{field} tidak valid.",
      "ipv4" :               "{field} tidak valid.",
      "ipv6" :               "{field} tidak valid.",
      "json" :               "{field} tidak valid.",
      "name" :               "{field} tidak valid.",
      "same" :               "{field} tidak sama dengan {param}.",
      "email" :              "{field} tidak valid.",
      "regex" :              "{field} tidak valid.",
      "alpha" :              "{field} hanya boleh diisi dengan Alphabet.",
      "not_in" :             "{field} tidak valid.",
      "integer" :            "{field} tidak valid.",
      "numeric" :            "{field} tidak valid.",
      "boolean" :            "{field} tidak valid.",
      "required" :           "{field} harap diisi.",
      "ends_with" :          "{field} harus diakhiri dengan {param}.",
      "different" :          "{field} tidak boleh sama dengan {param}.",
      "not_regex" :          "{field} tidak valid.",
      "gt_checked" :         "Maksimal yang boleh dicentang dari {field} ialah {param}.", //Greater Than
      "lt_checked" :         "Minimal yang boleh dicentang dari {field} ialah {param}.", //Lower Than
      "max_length" :         "Maksimal Karakter untuk {field} ialah {param}.",
      "min_length" :         "Minimal Karakter untuk {field} ialah {param}.",
      "alpha_dash" :         "{field} hanya boleh diisi dengan Alphabet dan Garis.",
      "gte_checked" :        "Maksimal yang boleh dicentang dari {field} ialah sama dengan {param}.", //Greater Than or Equal
      "lte_checked" :        "Minimal yang boleh dicentang dari {field} ialah sama dengan {param}.", 
      "starts_with" :        "{field} harus diawali dengan {param}.",
      "required_if" :        "{field} harus diisi.",
      "equal_checked" :      "Yang boleh dicentang dari {field} ialah sama dengan {param}.", 
      "alpha_numeric" :      "{field} hanya boleh diisi dengan Alphabet dan Angka.",
      "alpha_numeric_dash" : "{field} hanya boleh diisi dengan Alphabet, Angka dan Garis.",
    }
  };

  static final String validationMessageId = "id";
}