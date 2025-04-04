import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poliglota/language_dialog.dart';

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
  List<String> _selectedLanguages = ['English', 'Español'];
  final List<String> _availableLanguages = ['English', 'Español', 'اردو'];

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
      body: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            title: const Text('Languages'),
            subtitle: Text(_selectedLanguages.join(', ')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final result = await showDialog<List<String>>(
                context: context,
                builder:
                    (BuildContext context) => LanguageDialog(
                      selectedLanguages: _selectedLanguages,
                      availableLanguages: _availableLanguages,
                    ),
              );
              if (result != null) {
                setState(() {
                  _selectedLanguages = result;
                });
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilledButton(
                  onPressed: _translateText,
                  child: const Text('Translate'),
                ),
                FilledButton.tonal(
                  onPressed: _copyOutput,
                  child: const Text('Copy Output'),
                ),
                TextButton(onPressed: _clearText, child: const Text('Clear')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_outputText),
          ),
        ],
      ),
    );
  }

  Future<void> _translateText() async {
    // Simulate an asynchronous translation process
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: actually translate the text

    String translatedText = _originalText.split('').reversed.join();
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
