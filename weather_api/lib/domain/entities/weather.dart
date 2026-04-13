class Weather {
  final DateTime time; // New field to help us filter
  final double temp;
  final String description;

  Weather({required this.time, required this.temp, required this.description});

  factory Weather.fromListItem(Map<String, dynamic> json) {
    return Weather(
      // Parsing the text "2026-04-08 12:00:00" into a real DateTime object
      time: DateTime.parse(json['dt_txt']),
      temp: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
    );
  }
}
