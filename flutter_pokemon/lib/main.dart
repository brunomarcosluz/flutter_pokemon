import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pokemon/pokemon.dart';
import 'package:flutter_pokemon/pokemondetail.dart';

void main() => runApp(MaterialApp(
  title: "App Pokemon do Bruno",
  home: HomePage(),
  debugShowCheckedModeBanner: false,
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub? pokeHub;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fectData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poke App"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null 
      ? Center(
          child: CircularProgressIndicator(),
        )
      : GridView.count(
        crossAxisCount: 2,
        children: pokeHub.Pokemon
          .map((poke) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokeDetail(
                      pokemon: poke,
                    )));
              },
              child: Hero(
                tag: poke.img,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width * 4.0,
                        width: MediaQuery.of(context).size.width * 2.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover, 
                            image: NetworkImage(poke.img))),
                      ),
                      Text(
                        poke.image,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ))
        .toList(),
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}