import 'dart:async';
import 'dart:io';

import 'package:actividad4future/people.dart';
import 'package:actividad4future/planet.dart';
import 'package:actividad4future/services.dart';

// Clase principal como asíncrona
Future<void> main(List<String> arguments) async {
  // Listado de planetas
  List<Planet> planetList = [];

  // Petición mediante un servicio
  Services service = Services();

  try {
    // Esperar a que se obtengan los planetas
    planetList = await service.getStarWarsPlanets();

    // Tratamiento de datos de forma individual
    for (Planet item in planetList) {
      print(
          "The planet ${item.getName()} has a diameter of ${item.getDiameter()} kms, gravity: ${item.getGravity()}, climate: ${item.getClimate()} and terrain(s): ${item.getTerrain()}");
    }

    print("-----");

    // Ahora es el momento de pedir al usuario que elija un planeta
    print("2. List of residents of a planet");
    print(
        "Which planet do you want to see the residents of? (Choose one of the planets above)");
    String planetElection = stdin.readLineSync()!;
    int planetId = int.parse(planetElection);

    // Obtener los residentes del planeta elegido
    List<People> peopleList = await service.getStarWarsResidentsUrl(planetId);

    for (People item in peopleList) {
      print(
          "The inhabitant ${item.getName()} is ${item.getHeight()} tall, has hair color: ${item.getHair()}, gender: ${item.getGender()} and was born in the year: ${item.getBirth()}");
    }
  } catch (error) {
    print("Error: $error");
  } finally {
    // Cerramos conexión al final
    service.getConnection().close();
  }
}
