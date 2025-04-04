import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PoliglotaApp());
}

class PoliglotaApp extends StatelessWidget {
  const PoliglotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poliglota',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  String _originalText = '';
  String _outputText = '';
  List<String> _selectedLanguages = ['English'];
  final List<String> _availableLanguages = ['English', 'Español'];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Poliglota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Languages',
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_selectedLanguages.join(', ')),
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () async {
                      final result = await showDialog<List<String>>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Select Languages (Max 2)'),
                            content: StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _availableLanguages.map((language) {
                                    return CheckboxListTile(
                                      title: Text(language),
                                      value: _selectedLanguages.contains(language),
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          if (value) {
                                            if (_selectedLanguages.length < 2) {
                                              setState(() {
                                                _selectedLanguages.add(language);
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _selectedLanguages.remove(language);
                                            });
                                          }
                                        }
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(_selectedLanguages);
                                },
                              ),
                            ],
                          );
                        },
                      );
                      if (result != null) {
                        setState(() {
                          _selectedLanguages = result;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter text',
              ),
              onChanged: (text) {
                setState(() {
                  _originalText = text;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: _translateText,
                  child: const Text('Translate'),
                ),
                FilledButton.tonal(
                  onPressed: _copyOutput,
                  child: const Text('Copy Output'),
                ),
                TextButton(
                  onPressed: _clearText,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(_outputText),
          ],
        ),
      ),
    );
  }

  Future<void> _translateText() async {
    // Simulate an asynchronous translation process
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: actually translate the text

    String translatedText = _originalText.split('').reversed().join();
    setState(() {
      _outputText = [translatedText, _originalText].join('\n');
    });
  }

  Future<void> _copyOutput() async {
    await Clipboard.setData(ClipboardData(text: _outputText));
  }

  void _clearText() {
    _textController.clear();
    setState(() {
      _originalText = '';
      _outputText = '';
    });
  }
}
