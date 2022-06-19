class Persons{
  final String name;
  final String dob;
  final int id;
  

  Persons( {required this.id,required this.name,required this.dob,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob
    };
  }


  @override
  String toString() {
    return 'Dog{id: $id,name: $name,dob: $dob}';
  }
}