import 'dart:async';

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
          "El planeta ${item.getName()} tiene ${item.getDiameter()}Kms de diámetro y gravedad: ${item.getGravity()}");
    }

    print("-----");

    // Ahora es el momento de pedir al usuario que elija un planeta
    print("2. Listado de habitantes de un planeta");
    print(
        "¿Qué planeta quieres ver sus habitantes? (Elige uno de los planetas de arriba)");
    String planetElection = "1";
    // String planetElection = stdin.readLineSync()!;
    int planetId = int.parse(planetElection);

    // Obtener los residentes del planeta elegido
    List<People> peopleList = await service.getStarWarsResidentsUrl(planetId);

    for (People item in peopleList) {
      print(
          "El habitante ${item.getName()} tiene ${item.getHeight()} de altura y pesa:");
    }
  } catch (error) {
    print("Error: $error");
  } finally {
    // Cerramos conexión al final
    service.getConnection().close();
  }
}
