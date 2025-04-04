import 'package:flutter/material.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({
    super.key,
    required this.selectedLanguages,
    required this.availableLanguages,
  });

  final List<String> selectedLanguages;
  final List<String> availableLanguages;

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late List<String> _selectedLanguages;

  @override
  void initState() {
    super.initState();
    _selectedLanguages = List.from(widget.selectedLanguages);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Select Two Languages'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children:
          widget.availableLanguages
              .map(
                (language) => CheckboxListTile(
                  title: Text(language),
                  value: _selectedLanguages.contains(language),
                  onChanged: (bool? value) {
                    if (value != null) {
                      if (value) {
                        setState(() {
                          _selectedLanguages.add(language);
                        });
                      } else {
                        setState(() {
                          _selectedLanguages.remove(language);
                        });
                      }
                    }
                  },
                ),
              )
              .toList(),
    ),
    actions: <Widget>[
      TextButton(
        onPressed:
            _selectedLanguages.length == 2
                ? () {
                  Navigator.of(context).pop(_selectedLanguages);
                }
                : null,
        child: const Text('OK'),
      ),
    ],
  );
}
