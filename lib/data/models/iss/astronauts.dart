import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;

import '../../../util/photos.dart';
import '../../../util/url.dart';
import '../models.dart';

/// ASTRONAUT MODEL
/// Represents an astronaut in the outter space, including his/her name & spacecraft.
class AstronautsModel extends QueryModel {
  @override
  Future loadData([BuildContext context]) async {
    // Get items by http call
    var response = await http.get(Url.issAstronauts);
    var snapshot = json.decode(response.body)['people'];

    // Add parsed items
    items.addAll(
      snapshot.map((astronaut) => Astronaut.fromJson(astronaut)).toList(),
    );

    // Add photos & shuffle them
    if (photos.isEmpty) {
      photos.addAll(IssPhotos.astronauts);
      photos.shuffle();
    }

    // Finished loading data
     finishLoading();
  }
}

class Astronaut {
  final String name, craft;

  Astronaut({this.name, this.craft});

  factory Astronaut.fromJson(Map<String, dynamic> json) {
    return Astronaut(
      name: json['name'],
      craft: json['craft'],
    );
  }

  String description(context) => FlutterI18n.translate(
        context,
        'iss.astronauts.tab.from',
        {'place': craft},
      );
}
