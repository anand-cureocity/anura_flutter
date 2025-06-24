/// A model to act simplify data
class AnuraUserModel {
  /// A model to act simplify data
  AnuraUserModel({
    required this.sex,
    required this.height,
    required this.age,
    required this.weight,
  });

  /// To get user sex assigned at birth
  final AnuraUserModelSex sex;

  /// Height in cm
  final int height;

  /// Age in years
  final int age;

  /// Weight in KG
  final int weight;

  /// To create json from [AnuraUserModel]
  Map<String, dynamic> toJson() => {
        'sex': sex.name,
        'height': height,
        'weight': weight,
        'age': age,
      };
}

/// To get user sex assigned at birth
enum AnuraUserModelSex {
  /// Biological Male
  male,

  /// Biological Female
  female
}
