import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// create a global saved set
Set<WordPair> savedGlobal = new Set<WordPair>();

class RepositorioParPalavra {
  var listapair = [];
  int lenlista = 0;

  CreatePair() {
    for (int i = 0; i < 10; i++){
      WordPair wp = WordPair.random();
      String first = wp.first;
      String second = wp.second;
      listapair.add(first);
      listapair.add(second);
    }
    this.lenlista = listapair.length;
    return listapair;
  }
}

RepositorioParPalavra rep = RepositorioParPalavra();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primeiro App',
      home: DefaultTabController(
        length: 2,
        child: RandomWords(),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({ Key? key }) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  TextEditingController nameController = TextEditingController();
  var _suggestions = rep.CreatePair();
  var len = rep.lenlista;
  final isSelected = <bool>[true, false];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palavras em English'),
        bottom: TabBar(
          tabs: <Widget> [
            Tab(text: 'Lista Vertical'),
            Tab(text: 'Lista Grid'),
          ],
        ),
        actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'New Text',
                            ),
                            //onChanged: (name) => setState(() => _suggestions.insert(0,name))
                          ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  _suggestions.insert(0,nameController.text);
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                });
                              },
                              child: Text('Add')
                          )
                        ],
                      );
                    }
                  );
                },
                icon: Icon(Icons.add)),
            IconButton(
                icon: const Icon(Icons.list),
                onPressed: () {}),        ],
      ),
    body: TabBarView(
        children: <Widget> [
          _buildSuggestions(),
          _gridsuggestions(),
        ],
      ),
    );
  }

  Widget _buildSuggestions(){
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (BuildContext _context, i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return ListTile(
          title: Text(_suggestions[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.black,),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextFormField(
                            initialValue: _suggestions[index],
                            onChanged: (name) => setState(() => _suggestions[index] = name
                            )),
                        );
                      }
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red,),
                onPressed: () {
                  setState(() {
                    _suggestions.remove(_suggestions[index]);
                  });
                },
              ),
            ],
          ),          
        );
      }
    );
  }


  Widget _gridsuggestions() {
    return new GridView.builder(
      itemCount: 10,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: /*1*/ (BuildContext _context, i) {
        final index = i;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return ListTile(
          title: Text(_suggestions[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.black,),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextFormField(
                            initialValue: _suggestions[index],
                            onChanged: (name) => setState(() => _suggestions[index] = name
                            )),
                        );
                      }
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red,),
                onPressed: () {
                  setState(() {
                    _suggestions.remove(_suggestions[index]);
                  });
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
