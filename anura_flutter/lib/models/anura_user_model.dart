/// A model to act simplify data
class AnuraUserModel {
  /// A model to act simplify data
  AnuraUserModel({
    required this.sex,
    required this.height,
    required this.age,
    required this.weight,
    required this.partnerID,
  });

  /// To get user sex assigned at birth
  final AnuraUserModelSex sex;

  /// Height in cm
  final int height;

  /// Age in years
  final int age;

  /// Weight in KG
  final int weight;

  /// Weight in KG
  final String partnerID;

  /// To create json from [AnuraUserModel]
  Map<String, dynamic> toJson() => {
        'sex': sex.name,
        'height': height,
        'weight': weight,
        'age': age,
        'partnerID': partnerID,
      };
}

/// To get user sex assigned at birth
enum AnuraUserModelSex {
  /// Biological Male
  male,

  /// Biological Female
  female
}
