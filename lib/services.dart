import 'dart:async';
import 'dart:convert';
import 'package:actividad4future/people.dart';
import 'package:http/retry.dart';
import 'package:actividad4future/planet.dart';
import 'package:http/http.dart' as http;

class Services {
  final String STAR_WARS_API_URL = 'https://swapi.dev/api/';
  late RetryClient connection;

  Services() {
    setConnection();
  }

  /// Inicializa la conexión
  setConnection() {
    connection = RetryClient(http.Client());
  }

  /// Obtiene la conexión
  getConnection() {
    return connection;
  }

  /// Obtiene planetas del api de Start Wars
  Future<List<Planet>> getStarWarsPlanets() async {
    List<Planet> planetsList = [];
    late String response;
    // Conexión con el API
    try {
      response = (await getConnection()
          .read(Uri.parse('${STAR_WARS_API_URL}planets')));
      // Tratar el resultado
      Map<String, dynamic> planets = jsonDecode(response);

      // Recorrer mapa obtenido
      planets['results'].forEach((value) {
        Planet newPlanet = Planet(
            value['name'],
            int.parse(
              value['diameter'],
            ),
            value['climate'],
            value['gravity'],
            value['terrain']);
        planetsList.add(newPlanet);
      });
    } finally {}
    // Devuelve el listado de planetas.
    return planetsList;
  }

  Future<List<People>> getStarWarsResidentsUrl(int planetId) async {
    List<People> peopleList = [];
    late String responsePlanet;
    late String responsePeople;

    // Conexión con el API
    try {
      responsePlanet = (await getConnection()
          .read(Uri.parse('${STAR_WARS_API_URL}planets/$planetId')));

      // Tratar el resultado
      Map<String, dynamic> planetMap = jsonDecode(responsePlanet);

      // Verificar si 'residents' es null o no existe
      List<dynamic> peopleUrl = planetMap['residents'];

      // Verificar si hay residentes en el planeta
      bool residentsAlive = false;

      for (String url in peopleUrl) {
        residentsAlive = true;
        responsePeople = (await getConnection().read(Uri.parse(url)));

        Map<String, dynamic> peopleMap = jsonDecode(responsePeople);

        // Guardar la información seleccionada en una lista
        People newPeople = People(
            peopleMap['name'],
            int.parse(peopleMap['height']),
            peopleMap['hair_color'],
            peopleMap['gender'],
            peopleMap['birth_year']);
        peopleList.add(newPeople);
      }

      if (!residentsAlive) {
        print("There are no residents on this planet.");
      }

      // Devuelve el listado de personas.
    } catch (error) {
      print("Error obtaining residents: $error");
    }
    return peopleList;
  }

  Future<List<People>> getStarWarsAllResidents() async {
    List<People> peopleList = [];
    late String responsePlanet;

    // Conexión con el API
    try {
      responsePlanet =
          (await getConnection().read(Uri.parse('${STAR_WARS_API_URL}people')));

      // Tratar el resultado
      Map<String, dynamic> peopleMap = jsonDecode(responsePlanet);

      // Guardar la información seleccionada en una lista
      peopleMap['results'].forEach((value) {
        People newPeople = People(value['name'], int.parse(value['height']),
            value['hair_color'], value['gender'], value['birth_year']);
        peopleList.add(newPeople);
      });

      // Devuelve el listado de personas.
    } catch (error) {
      print("Error obtaining residents: $error");
    }
    return peopleList;
  }

  Future<List<Planet>> getStarWarsHomeworld(String characterElection) async {
    late String responsePeople;
    late String responseHomeworld;
    List<Planet> homeworldList = [];
    late String homeworldUrl;

    // Conexión con el API
    try {
      responsePeople =
          (await getConnection().read(Uri.parse('${STAR_WARS_API_URL}people')));
      // Tratar el resultado
      Map<String, dynamic> people = jsonDecode(responsePeople);

      // Iterar sobre los resultados para encontrar el personaje seleccionado
      for (var character in people['results']) {
        if (character['name'] == characterElection) {
          homeworldUrl = character['homeworld'];
          break; // Salir del bucle una vez encontrado el personaje
        }
      }

      // Verificar si se encontró el homeworld
      responseHomeworld = (await getConnection().read(Uri.parse(homeworldUrl)));

      Map<String, dynamic> homeworldMap = jsonDecode(responseHomeworld);

      Planet newPlanet = Planet(
          homeworldMap['name'],
          int.parse(homeworldMap['diameter']),
          homeworldMap['climate'],
          homeworldMap['gravity'],
          homeworldMap['terrain']);
      homeworldList.add(newPlanet);
    } catch (error) {
      print("Error obtaining planet: $error");
    }

    // Devuelve el listado de planetas.
    return homeworldList;
  }
}
