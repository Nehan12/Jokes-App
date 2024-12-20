import 'package:json_annotation/json_annotation.dart';

part 'joke.g.dart'; // This will be generated by the build_runner

@JsonSerializable()
class Joke {
  final String setup;
  final String punchline;

  Joke({required this.setup, required this.punchline});

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);
  Map<String, dynamic> toJson() => _$JokeToJson(this);

  String get joke => '$setup $punchline';
}