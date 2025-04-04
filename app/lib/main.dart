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
  String _selectedLanguage = 'English';

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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Language',
              ),
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(
                  value: 'English',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'Español',
                  child: Text('Español'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
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
