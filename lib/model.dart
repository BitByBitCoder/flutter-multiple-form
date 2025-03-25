class FamilyMember {
  String? name;
  DateTime? dob;
  String? gender;
  bool isIndian = false; // Add this field with a default value

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'isIndian': isIndian, // Add this to the JSON output
    };
  }
}
