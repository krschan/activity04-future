import 'dart:async';
import 'dart:convert';
import 'package:actividad4future/people.dart';
import 'package:http/retry.dart';
import 'package:actividad4future/planet.dart';
import 'package:http/http.dart' as http;

class Services {
  final String STAR_WARS_API_URL = 'https://swapi.dev/api/';
  late RetryClient connection;
  List<String> residentsUrlList = [];

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
      Map<String, dynamic> planetSelected = jsonDecode(responsePlanet);

      // Verificar si 'residents' es null o no existe
      List<dynamic> peopleUrl = planetSelected['residents'];

      // Verificar si hay residentes en el planeta
      bool residentsAlive = false;

      for (String url in peopleUrl) {
        residentsAlive = true;
        responsePeople = (await getConnection().read(Uri.parse(url)));

        Map<String, dynamic> peopleSelected = jsonDecode(responsePeople);

        // Aquí no necesitas 'results', ya que cada URL devuelve un objeto de persona
        People newPeople = People(
            peopleSelected['name'],
            int.parse(peopleSelected['height']),
            peopleSelected['hair_color'],
            peopleSelected['gender'],
            peopleSelected['birth_year']);
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
}
