class AtividadeEntity {
  int id;
  String activity;
  //String description;
  //int status;

  AtividadeEntity({required this.id, required this.activity
      //required this.description,
      //required this.status,
      });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity': activity
      //'description': description,
      //'status': status,
    };
  }

  factory AtividadeEntity.fromMap(Map<String, dynamic> map) {
    return AtividadeEntity(
      id: map['id'],
      activity: map['activity'],
      //description: map['description'],
      //status: map['status'],
    );
  }
}
