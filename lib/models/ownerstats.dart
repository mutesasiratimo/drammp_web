class OwnerStats {
  int? individuals;
  int? nonindividuals;
  int? owners;

  OwnerStats({this.individuals, this.nonindividuals, this.owners});

  OwnerStats.fromJson(Map<String, dynamic> json) {
    individuals = json['individuals'];
    nonindividuals = json['nonindividuals'];
    owners = json['owners'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['individuals'] = individuals;
    data['nonindividuals'] = nonindividuals;
    data['owners'] = owners;
    return data;
  }
}

class Stats {
  int? bodas;
  int? riders;
  int? owners;
  int? stages;

  Stats({this.bodas, this.riders, this.owners, this.stages});

  Stats.fromJson(Map<String, dynamic> json) {
    bodas = json['bodas'];
    riders = json['riders'];
    owners = json['owners'];
    stages = json['stages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bodas'] = this.bodas;
    data['riders'] = this.riders;
    data['owners'] = this.owners;
    data['stages'] = this.stages;
    return data;
  }
}
