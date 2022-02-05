class Weather5days {
  Weather5days.fromJson(Map<String, dynamic> json)
      : estadoTempo = json['weather'][0]['main'],
        humidade = json['main']['humidity'],
        precipitacao = json['pop'].truncate(),
        vento = json['wind']['speed'] *3.6, // converted de metros/segundo para km/h
        pressao = json['main']['pressure'],
        tempMin = json['main']['temp_min'] - 273.15, // passar para celsius
        tempMax = json['main']['temp_max'] - 273.15,
        tempAtual = json['main']['temp'] - 273.15,
        data = json['dt'];

  final int data;
  final String estadoTempo;
  final int humidade;
  final int precipitacao;
  final double vento;
  final int pressao;
  final double tempMin;
  final double tempMax;
  final double tempAtual;
}
