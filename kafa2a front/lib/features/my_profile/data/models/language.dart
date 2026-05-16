class Language {
  Language({
    required this.name,
    required this.code,
  });

  String code;
  String name;
}

List<Language> languages = [
  Language(name: "English", code: "en"),
  Language(name: "العربية", code: "ar")
];
