class Weather {
  Weather.fromJson(Map<String, dynamic> json)
      : localidade = json['name'],
        estadoTempo = json['weather'][0]['main'],
        condicao = json['weather'][0]['description'],
        tempMin = json['main']['temp_min'] - 273.15, // passar para celsius
        tempMax = json['main']['temp_max'] - 273.15,
        tempAtual = json['main']['temp'] - 273.15,
        data = json['dt'];

  final int data;
  final String condicao;
  final String estadoTempo;
  final String localidade;
  final double tempMin;
  final double tempMax;
  late final double tempAtual;
}
