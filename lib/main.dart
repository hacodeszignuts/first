import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFonts = const TextStyle(fontSize: 18);
  final _saved = <WordPair>{};

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(
          title: Text(pair.asPascalCase, style: _biggerFonts),
        );
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
          : <Widget>[];

      return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
            backgroundColor: const Color(0xFF5F4B8B),
          ),
          body: Container(
            color: const Color(0xFFE69A8D),
            child: ListView(
              children: divided,
            ),
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5F4B8B),
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              onPressed: _pushSaved,
              icon: const Icon(Icons.list),
              tooltip: 'Saved Suggestion',
            )
          ],
        ),
        body: Container(
            color: const Color(0xFFE69A8D),
            child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, i) {
                  if (i.isOdd) return const Divider();
                  final index = i ~/ 2;
                  if (index >= _suggestions.length) {
                    _suggestions.addAll(generateWordPairs().take(10));
                  }
                  final alreadysaved = _saved.contains(_suggestions[index]);

                  return ListTile(
                    tileColor: const Color(0xE69A8DFF),
                    title: Text(_suggestions[index].asPascalCase,
                        style: _biggerFonts),
                    trailing: Icon(
                        alreadysaved ? Icons.favorite : Icons.favorite_border,
                        color: alreadysaved ? Colors.black : null,
                        semanticLabel:
                            alreadysaved ? 'Removed from saved' : 'Save'),
                    onTap: () {
                      setState(() {
                        if (alreadysaved) {
                          _saved.remove(_suggestions[index]);
                        } else {
                          _saved.add(_suggestions[index]);
                        }
                      });
                    },
                  );
                })));
  }
}
