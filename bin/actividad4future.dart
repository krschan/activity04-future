import 'dart:async';
import 'dart:io';

import 'package:actividad4future/globals.dart';
import 'package:actividad4future/people.dart';
import 'package:actividad4future/planet.dart';
import 'package:actividad4future/services.dart';

// Clase principal como asíncrona
Future<void> main(List<String> arguments) async {
  // Lista de planetas
  List<Planet> planetList = [];

  // Petición mediante un servicio
  Services service = Services();

  try {
    // Esperar a que se obtengan los planetas
    planetList = await service.getStarWarsPlanets();

    print("${green}1. List of planets$reset");

    // Tratamiento de datos de forma individual
    int counter = 1;
    for (Planet item in planetList) {
      print(
          "$yellow $counter$reset. The planet $cyan${item.getName()}$reset has a diameter of $cyan${item.getDiameter()} kms$reset, gravity: $cyan${item.getGravity()}$reset, climate: $cyan${item.getClimate()}$reset and terrain(s): $cyan${item.getTerrain()}$reset");
      counter++;
    }

    print("$blue ----- $reset");

    // El usuario debe elegir un planeta
    print("${green}2. List of residents of a planet$reset");
    print(
        "Which planet do you want to see the residents of? $green(Choose a number from the previous planets)$reset");
    String planetElection = stdin.readLineSync()!;
    int planetId = int.parse(planetElection);

    // Obtener los residentes del planeta elegido
    List<People> peopleList = await service.getStarWarsResidentsUrl(planetId);

    for (People item in peopleList) {
      print(
          "${blue}The resident ${item.getName()} is ${item.getHeight()} tall, has hair color: ${item.getHair()}, gender: ${item.getGender()} and was born in the year: ${item.getBirth()}$reset");
    }

    print("$blue ----- $reset");

    print("${green}3. Description of a planet by selected character$reset");

    List<People> peopleAllList = await service.getStarWarsAllResidents();

    for (People item in peopleAllList) {
      print("$blue ${item.name}$reset");
    }

    print(
        "Which resident do you want to see the planet of? $green(Type a character from the previous ones)$reset");

    String characterElection = stdin.readLineSync()!;

    List<Planet> homeworldList =
        await service.getStarWarsHomeworld(characterElection);

    for (Planet item in homeworldList) {
      print(
          "The planet $cyan${item.getName()}$reset has a diameter of $cyan${item.getDiameter()} kms$reset, gravity: $cyan${item.getGravity()}$reset, climate: $cyan${item.getClimate()}$reset and terrain(s): $cyan${item.getTerrain()}$reset");
    }
  } catch (error) {
    print("${red}Error: $error$reset");
  } finally {
    // Cerramos conexión al final
    service.getConnection().close();
  }
}
