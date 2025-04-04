import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:poliglota/language_dialog.dart';
import 'dart:convert';

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
      body: ListView(
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
                _clearText();
                setState(() {
                  _selectedLanguages = result;
                });
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              spacing: 8,
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
          // TODO: show a loading indicator while the translation is in progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(_outputText),
          ),
        ],
      ),
    );
  }

  Future<void> _translateText() async {
    String translatedText = await fetchTranslation(
      _selectedLanguages,
      _originalText,
    );
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

Future<String> fetchTranslation(
  List<String> languages,
  String originalText,
) async {
  // TODO: allow the user to specify their own API key and URL
  const apiKey = String.fromEnvironment("OPEN_ROUTER_API_KEY");
  const baseUrl = 'https://openrouter.ai/api/v1';

  final response = await http.post(
    Uri.parse('$baseUrl/chat/completions'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode({
      "model": "google/gemini-2.0-flash-001",
      "messages": [
        {
          "role": "system",
          "content":
              "The user is having a bilingual conversation between ${languages[0]} and ${languages[1]}.",
        },
        {
          "role": "system",
          "content":
              "Please translate anything the users says, without any extra characters. Keep your translation short and informal. Keep emojis as-is. Use the latin script for any translated text.",
        },
        {"role": "user", "content": originalText},
      ],
    }),
  );

  if (response.statusCode == 200) {
    // The utf8 decoding is VERY important, otherwise it default to latin-1 for some reason.
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data['choices'][0]['message']['content'];
  } else {
    print('Failed to fetch completion: ${response.statusCode}');
    return 'ERROR';
  }
}
