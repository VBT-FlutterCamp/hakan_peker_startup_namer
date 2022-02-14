import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

part 'home_string.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _HomeString text = _HomeString();
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    void buttonOnTap() {
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else {
          _saved.add(pair);
        }
      });
    }

    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
          semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
        ),
        onTap: () {
          buttonOnTap();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _buildSuggestions(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title:  Text(text.scaffoldAppbarText,style: Theme.of(context).textTheme.headline6,),
      actions: [
        IconButton(
          onPressed: _pushSaved,
          icon: const Icon(Icons.list),
          tooltip: "Saved Suggestions",
        ),
      ],
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
            
          ),
        );
      });
      final divided = tiles.isNotEmpty ? ListTile.divideTiles(tiles: tiles, context: context).toList() : <Widget>[];
      return Scaffold(
        appBar: AppBar(
          title:  Text(text.nextPageAppbarText,style: Theme.of(context).textTheme.headline6,),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }
}
