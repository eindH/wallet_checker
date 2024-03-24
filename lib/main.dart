import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String WALLET_ADDRESS = '1DEP8i3QJCsomS4BSMY2RpU1upv62aGvhD';

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://api.blockcypher.com/v1/btc/main/addrs/${WALLET_ADDRESS}')); //1DEP8i3QJCsomS4BSMY2RpU1upv62aGvhD'

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album1');
  }
}

class Album {
  //final int userId;
  //final int id;
  //final String title;
  final int balance;

  const Album({
    //required this.userId,
    //required this.id,
    //required this.title,
    required this.balance,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        //'userId': int userId,
        //'id': int id,
        //'title': String title,
        'balance': int balance,
      } =>
        Album(
          //userId: userId,
          //id: id,
          //title: title,
          balance: balance,
        ),
      _ => throw const FormatException('Failed to load album2'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(WALLET_ADDRESS);
    return MaterialApp(
      title: 'Wallet balance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wallet balance'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: myController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter wallet address'
                ),
              ),
              TextButton(
                onPressed: () {futureAlbum.then((result) => {
                  setState(() {
                    WALLET_ADDRESS = myController.text;
                  })
              });}, 
                child: const Text('Fetch balance')
              ),
              FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Text(snapshot.data!.balance.toString())
                        ]
                      );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}