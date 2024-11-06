class Planet {
  final String name;
  final int diameter;
  final String climate;
  final String gravity;
  final String terrain;

  Planet(this.name, this.diameter, this.climate, this.gravity, this.terrain);

  String getName() {
    return name;
  }

  int getDiameter() {
    return diameter;
  }

  String getClimate() {
    return climate;
  }

  String getGravity() {
    return gravity;
  }

  String getTerrain() {
    return terrain;
  }
}
