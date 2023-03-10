import 'package:brewcrew/models/brew.dart';
import 'package:brewcrew/screens/home/brew_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewList extends StatefulWidget {
  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<Brew>?>(context) ?? [];
    if (brews != null) {

      brews.forEach((brew) {
        print(brew.name);
        print(brew.sugers);
        print(brew.strength);
      });
    }

    return ListView.builder(
      itemCount: brews.length,
        itemBuilder: (context, index){
        return BrewTile(brew: brews[index]);
        }
    );
  }
}
