import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    title: "Weather App",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var windSpeed;
  var humidity;
  var currently;

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=Boston&units=imperial&appid=5669da9f7124121c946468a941cc6ab0"));
    var results = jsonDecode(response.body);
    setState(() {
      temp = results['main']['temp'];
      description = results['weather'][0]['description'];
      currently = results['weather'][0]['main'];
      humidity = results['main']['humidity'];
      windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text("Currently in Boston",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600)),
              ),
              Text(
                temp != null ? "$temp\u00B0" : "Loading",
                style: const TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(currently != null ? "$currently" : "Loading",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.temperatureHalf),
                title: const Text("Temperature"),
                trailing: Text(temp != null ? "$temp\u00B0" : "Loading"),
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.cloud),
                title: const Text("Weather"),
                trailing:
                    Text(description != null ? "$description" : "Loading"),
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.sun),
                title: const Text("Humidity"),
                trailing: Text(humidity != null ? "$humidity" : "Loading"),
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.wind),
                title: const Text("Wind Speed"),
                trailing: Text(windSpeed != null ? "$windSpeed" : "Loading"),
              ),
            ],
          ),
        ))
      ],
    ));
  }
}
