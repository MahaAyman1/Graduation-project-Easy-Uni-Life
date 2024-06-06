import 'package:appwithapi/Cstum/menu.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Column(
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("Fitring");
              },
              child: Text("Go To Toutring Page"),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('VotedList');
            },
            child: Text("Go To  'VotingScreen'"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('CreateVoteForm');
            },
            child: Text('CreateVoteForm'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed("VoteList");
            },
            child: Text("VoteList"),
          ),
          /* TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('MarkerMapPage');
            },
            child: Text('MarkerMapPage'),
          ),*/
        ],
      ),
      drawer: Menu(),
    );
  }
}
