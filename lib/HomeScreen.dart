import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather/DetailsSreen.dart';
import 'package:weather/weather5days_model.dart';
import 'package:weather/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

String apiKey = "0628a3d6c620b3b01ca96fad6bb3939f";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Location location = Location();
  static int _counter = 0;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;
  late SharedPreferences sharedData;
  Weather? _weather;
  List<Weather5days>? weatherListaDias;
  late String condicao;
  late String iconWeather;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _fetchWeatherShared();
    if (weatherListaDias == null) _counter = 5;
  }

  void setCondicaoLang(String cond) {
    if (cond == "clear sky") {
      condicao = S.of(context).clearSky;
    } else if (cond == "few clouds") {
      condicao = S.of(context).fewClouds;
    } else if (cond == "scattered clouds") {
      condicao = S.of(context).scatteredClouds;
    } else if (cond == "broken clouds") {
      condicao = S.of(context).brokenClouds;
    } else if (cond == "shower rain") {
      condicao = S.of(context).showerRain;
    } else if (cond == "rain") {
      condicao = S.of(context).rain;
    } else if (cond == "thunderstorm") {
      condicao = S.of(context).thunderstorm;
    } else if (cond == "snow") {
      condicao = S.of(context).snow;
    } else if (cond == "mist") {
      condicao = S.of(context).mist;
    }
  }

  IconData iconTempo(String estado) {
    if (estado == "Clear") {
      return WeatherIcons.day_sunny;
    } else if (estado == "Thunderstorm") {
      return WeatherIcons.storm_showers;
    } else if (estado == "Drizzle") {
      return WeatherIcons.day_rain_mix;
    } else if (estado == "Rain") {
      return WeatherIcons.rain;
    } else if (estado == "Snow") {
      return WeatherIcons.snow;
    } else if (estado == "Clouds") {
      return WeatherIcons.cloud;
    }

    return WeatherIcons.alien;
  }

  String _buildUrlWeather_Today(double? lat, double? lon) {
    String url = 'https://api.openweathermap.org/data/2.5/weather?';

    //  if (cityName != null) {
    //    url += 'q=$cityName&';
    //  } else {
    url += 'lat=$lat&lon=$lon';
    //}
    url += '&appid=$apiKey';

    print(url);
    return url;
  }

  String buildUrlWeatherDayX(double? lat, double? lon) {
    String url = 'http://api.openweathermap.org/data/2.5/forecast?';

    //  if (cityName != null) {
    //    url += 'q=$cityName&';
    //  } else {
    url += 'lat=$lat&lon=$lon';
    //}
    url += '&appid=$apiKey';
    print(url);

    return url;
  }

  Future<void> _fetchWeatherShared() async {
    sharedData = await SharedPreferences.getInstance();

    if (sharedData.get("tempData") != null) {
      _weather =
          Weather.fromJson(json.decode(sharedData.get("tempData").toString()));

      setCondicaoLang(_weather!.condicao);
    }

    if (sharedData.get("tempDataLista") != null) {
      final Map<String, dynamic> jsonData =
          json.decode(sharedData.get("tempDataLista").toString());
      weatherListaDias = (jsonData['list'] as List)
          .map((main) => Weather5days.fromJson(main))
          .toList();

      final ids = <dynamic>{};
      // excluir datas repetidas - da o tempo de 3 em 3 horas por dia
      weatherListaDias!.retainWhere((x) =>
          ids.add(DateTime.fromMillisecondsSinceEpoch(x.data * 1000).day));

      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String today = formatter.format(now);
      if (getData(weatherListaDias![0].data) == today) {
        // excluir dia atual da lista
        weatherListaDias!.removeAt(0);
      }

      _counter = weatherListaDias!.length;
      setState(() => weatherListaDias);
      //setState(() => _counter);
    }
  }

  Future<void> _fetch_Location_Weather() async {
    // Verificar estado do serviço
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    // Pede permissões em runtime
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    await _getCoordinates();
    setState(() {});

    //print("Latitude > " + _locationData!.latitude.toString());
    //print("\nLongitude > " + _locationData!.longitude.toString());

    try {
      //Para ir buscar os dados do dia ATUAL
      String url = _buildUrlWeather_Today(
          _locationData?.latitude, _locationData?.longitude);

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == HttpStatus.ok) {
        //debugPrint(response.body);
        final Map<String, dynamic> decodedData = json.decode(response.body);
        _weather = Weather.fromJson(decodedData);
        setCondicaoLang(_weather!.condicao);
        sharedData = await SharedPreferences.getInstance();
        sharedData.setString("tempData", response.body);

        // int millis = _weather!.data *
        //     1000; //converter data recebida para o formato normal
        //print(DateTime.fromMillisecondsSinceEpoch(millis));
      }

      //Para ir buscar os proximos 5 dias
      String url_5DIAS = buildUrlWeatherDayX(
          _locationData?.latitude, _locationData?.longitude);

      response = await http.get(Uri.parse(url_5DIAS));

      if (response.statusCode == HttpStatus.ok) {
        // debugPrint(response.body);
        final Map<String, dynamic> jsonData = json.decode(response.body);
        sharedData = await SharedPreferences.getInstance();
        sharedData.setString("tempDataLista", response.body);

        weatherListaDias = (jsonData['list'] as List)
            .map((main) => Weather5days.fromJson(main))
            .toList();

        final ids = <dynamic>{};
        // excluir datas repetidas - da o tempo de 3 em 3 horas por dia
        weatherListaDias!.retainWhere((x) =>
            ids.add(DateTime.fromMillisecondsSinceEpoch(x.data * 1000).day));

        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        String today = formatter.format(now);
        if (getData(weatherListaDias![0].data) == today) {
          // excluir dia atual da lista
          weatherListaDias!.removeAt(0);
        }

        _counter = weatherListaDias!.length;
        setState(() => _weather);
        _controller.reset();
      }
      getImg();
    } catch (ex) {
      debugPrint('Something went wrong: $ex');
    }
  }

  String getData(int data) {
    final f = DateFormat('yyyy-MM-dd');

    return f.format(DateTime.fromMillisecondsSinceEpoch(data * 1000));
  }

  String getDataHora(int data) {
    final f = DateFormat('yyyy-MM-dd  |  HH:mm');

    return f.format(DateTime.fromMillisecondsSinceEpoch(data * 1000));
  }

  Future<void> _getCoordinates() async {
    _locationData = await location.getLocation();
    setState(() {});
  }

  String getImg() {
    String img = "assets/images/sun.png";
    if (_weather != null) {
      if (_weather?.estadoTempo == "Clear") {
        img = "assets/images/sun.png";
      } else if (_weather?.estadoTempo == "Clouds") {
        img = "assets/images/clouds.png";
      } else if (_weather?.estadoTempo == "Rain") {
        img = "assets/images/rain.jpg";
      }
    }

    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getImg()),
                fit: BoxFit.fill,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 30.0),
              if (_weather != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.gps_fixed_outlined,
                      size: 30,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      _weather!.localidade,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10.0),
              if (_weather == null)
                Text(
                  S.of(context).infoUnavailable,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.normal,
                  ),
                )
              else
                Text(
                  getDataHora(_weather!.data),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: 100.0),
              if (_weather != null)
                Text(
                  "  " + _weather!.tempAtual.toStringAsFixed(0) + " º",
                  style: const TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 30.0),
              if (_weather != null)
                Text(
                  condicao,
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20.0),
              Expanded(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_weather != null)
                        Text(
                          _weather!.tempMax.toStringAsFixed(0) + " º",
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      if (_weather != null)
                        const Icon(
                          Icons.arrow_drop_up,
                        ),
                      const SizedBox(width: 30.0),
                      if (_weather != null)
                        RotationTransition(
                            turns: _animation,
                            child: Icon(iconTempo(_weather!.estadoTempo),
                                size: 55)),
                      const SizedBox(width: 40.0),
                      if (_weather != null)
                        Text(
                          _weather!.tempMin.toStringAsFixed(0) + " º",
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      if (_weather != null)
                        const Icon(
                          Icons.arrow_drop_down,
                        ),
                    ],
                  )),
              Container(
                height: 50,
                width: 150,
                margin: const EdgeInsets.only(top: 40.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _fetch_Location_Weather();
                    // if (!_controller.isAnimating) {

                    _controller.repeat();
                  },
                  label: Text(S.of(context).refresh,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      )),
                  icon: const Icon(Icons.refresh),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  splashColor: Colors.blue[100],
                ),
              ),
              const SizedBox(height: 20.0),
              Builder(builder: (BuildContext context) {
                if (!_serviceEnabled) {
                  //return Text(S.of(context).locationService);
                  return const Text('');
                } else if (_permissionGranted == PermissionStatus.denied) {
                  return Text(S.of(context).locationPermissions);
                } else if (_locationData != null) {
                  return StreamBuilder<LocationData>(
                      stream: location.onLocationChanged,
                      builder: (_, AsyncSnapshot<LocationData> snapshot) =>
                          snapshot.hasData
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                )
                              : snapshot.hasError
                                  ? Text(S.of(context).error)
                                  : const Text(''));
                } else {
                  return const Text('');
                }
              }),
              const SizedBox(height: 50.0),
              Column(
                children: [
                  SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _counter,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              height: 200.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(50, 0, 0, 0),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(children: [
                                Container(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Column(children: [
                                      if (weatherListaDias != null)
                                        Text(
                                            getData(
                                                weatherListaDias![index].data),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                            )),
                                    ])),
                                Container(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Column(children: [
                                      if (weatherListaDias != null)
                                        Icon(
                                          iconTempo(weatherListaDias![index]
                                              .estadoTempo),
                                          size: 30,
                                        ),
                                    ])),
                                const SizedBox(height: 40.0),
                                Expanded(
                                    flex: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            if (weatherListaDias != null)
                                              Text(
                                                  weatherListaDias![index]
                                                          .tempMax
                                                          .toStringAsFixed(0) +
                                                      " º",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  )),
                                            if (weatherListaDias != null)
                                              const Icon(
                                                Icons.arrow_drop_up,
                                                size: 18,
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            if (weatherListaDias != null)
                                              Text(
                                                  weatherListaDias![index]
                                                          .tempMin
                                                          .toStringAsFixed(0) +
                                                      " º",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  )),
                                            if (weatherListaDias != null)
                                              const Icon(
                                                Icons.arrow_drop_down,
                                                size: 18,
                                              ),
                                          ],
                                        )
                                      ],
                                    )),
                              ]),
                            ),
                            onTap: () {
                              if (weatherListaDias != null) {
                                Navigator.pushNamed(
                                    context, DetailsSreen.routeName,
                                    arguments: weatherListaDias![index]);
                              }
                            });
                      },
                    ),
                  ),
                ],
              ),
            ])));
  }
}
