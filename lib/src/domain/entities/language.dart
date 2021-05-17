class Language {
  final String? code;
  final String? name;

  Language(this.code, [this.name]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          name == other.name;

  @override
  int get hashCode => code.hashCode ^ name.hashCode;

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      json['code'] as String?,
      json['name'] as String?,
    );
  }
}
