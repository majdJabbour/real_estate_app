enum PropertyType {
  apartment,
  townhome,
  house,
  condo,
  duplex,
  studio;

  String get id => name;

  static PropertyType? fromId(String id) =>
      values.where((type) => type.id == id).firstOrNull;
}
