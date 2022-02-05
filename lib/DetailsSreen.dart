import 'package:flutter/material.dart';
import 'package:weather/weather5days_model.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

import 'generated/l10n.dart';

class DetailsSreen extends StatefulWidget {
  const DetailsSreen({Key? key}) : super(key: key);
  static const routeName = "DetalheScreen";

  @override
  State<DetailsSreen> createState() => _DetailsSreenState();
}

String getData(int data) {
  return DateTime.fromMillisecondsSinceEpoch(data * 1000).year.toString() +
      "/" +
      DateTime.fromMillisecondsSinceEpoch(data * 1000).month.toString() +
      "/" +
      DateTime.fromMillisecondsSinceEpoch(data * 1000).day.toString();
}

class _DetailsSreenState extends State<DetailsSreen> {
  late final Weather5days? _weatherDay =
      ModalRoute.of(context)!.settings.arguments as Weather5days;

  String getImg() {
    String img = "assets/images/sun.png";
    if (_weatherDay != null) {
      if (_weatherDay!.estadoTempo == "Clear") {
        img = "assets/images/sun.png";
      } else if (_weatherDay!.estadoTempo == "Clouds") {
        img = "assets/images/clouds.png";
      } else if (_weatherDay!.estadoTempo == "Rain") {
        img = "assets/images/rain.jpg";
      }
    }
    return img;
  }

  String getEstadoTempoLang(String estado) {
    String estadoTempo = "";

    if (estado == "Clear") {
      estadoTempo = S.of(context).clear;
    } else if (estado == "Thunderstorm") {
      estadoTempo = S.of(context).thunderstorm;
    } else if (estado == "Drizzle") {
      estadoTempo = S.of(context).drizzle;
    } else if (estado == "Rain") {
      estadoTempo = S.of(context).rain;
    } else if (estado == "Snow") {
      estadoTempo = S.of(context).snow;
    } else if (estado == "Clouds") {
      estadoTempo = S.of(context).clouds;
    }

    return estadoTempo;
  }

  @override
  void initState() {
    super.initState();
  }

  String getData(int data) {
    final f = DateFormat('yyyy-MM-dd');

    return f.format(DateTime.fromMillisecondsSinceEpoch(data * 1000));
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
          padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              if (_weatherDay != null)
                Text(
                  getData(_weatherDay!.data),
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 50.0),
              Expanded(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_weatherDay != null)
                        Text(
                          _weatherDay!.tempMax.toStringAsFixed(0) + " º",
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      if (_weatherDay != null)
                        const Icon(
                          Icons.arrow_drop_up,
                        ),
                      const SizedBox(width: 30.0),
                      if (_weatherDay != null)
                        Text(
                          getEstadoTempoLang(_weatherDay!.estadoTempo),
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(width: 30.0),
                      if (_weatherDay != null)
                        Text(
                          _weatherDay!.tempMin.toStringAsFixed(0) + " º",
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      if (_weatherDay != null)
                        const Icon(
                          Icons.arrow_drop_down,
                        ),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(30, 255, 255, 255),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(S.of(context).humidity,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                      const SizedBox(width: 10.0),
                                      const Icon(
                                        WeatherIcons.humidity,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ]),
                              ),
                              Text(
                                _weatherDay!.humidade.toString() + " %",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ])),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(30, 255, 255, 255),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(S.of(context).Precipitation,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                      const SizedBox(width: 10.0),
                                      const Icon(
                                        WeatherIcons.rain,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ]),
                              ),
                              Text(
                                _weatherDay!.precipitacao.toString() + " %",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(30, 255, 255, 255),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(S.of(context).windSpeed,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                      const SizedBox(width: 10.0),
                                      const Icon(
                                        WeatherIcons.wind,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ]),
                              ),
                              Text(
                                _weatherDay!.vento.toStringAsPrecision(2) +
                                    " Km/h",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ])),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(30, 255, 255, 255),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(S.of(context).Pressure,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                      const SizedBox(width: 10.0),
                                      const Icon(
                                        WeatherIcons.barometer,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ]),
                              ),
                              Text(
                                _weatherDay!.pressao.toString() + " hPa",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
