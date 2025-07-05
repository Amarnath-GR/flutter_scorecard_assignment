import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ScoreCardApp());
}

class ScoreCardApp extends StatelessWidget {
  const ScoreCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScoreCardForm(),
    );
  }
}

class ScoreCardForm extends StatefulWidget {
  const ScoreCardForm({super.key});

  @override
  State<ScoreCardForm> createState() => _ScoreCardFormState();
}

class _ScoreCardFormState extends State<ScoreCardForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stationController = TextEditingController();
  DateTime? _selectedDate;

  final List<String> _parameters = [
    'Platform Cleanliness',
    'Urinals Condition',
    'Waiting Room Cleanliness',
    'Drinking Water Booth',
    'Dustbin Availability',
    'Track Cleanliness',
    'Foot Over Bridge Cleanliness',
    'Lighting Condition',
    'Toilet Maintenance',
    'Waste Segregation',
  ];

  Map<String, int?> _scores = {};
  Map<String, String?> _remarks = {};

  @override
  void initState() {
    super.initState();
    for (var param in _parameters) {
      _scores[param] = null;
      _remarks[param] = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'station': _stationController.text,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'parameters': _parameters.map((param) => {
          'name': param,
          'score': _scores[param],
          'remark': _remarks[param],
        }).toList()
      };

      final uri = Uri.parse('https://httpbin.org/post');
      try {
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(formData),
        );

        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Submitted'),
            content: const Text('Form submitted successfully to API!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
      } catch (e) {
        debugPrint('Submission failed: $e');
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to submit form: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Score Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _stationController,
                decoration: const InputDecoration(labelText: 'Station Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Pick Date'),
                  )
                ],
              ),
              const SizedBox(height: 24),
              for (var param in _parameters) ...[
                Text(param, style: const TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<int>(
                  value: _scores[param],
                  items: List.generate(11, (index) => index)
                      .map((val) => DropdownMenuItem(
                            value: val,
                            child: Text(val.toString()),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _scores[param] = val;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Score (0–10)'),
                  validator: (val) => val == null ? 'Please select a score' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Remarks (optional)'),
                  onChanged: (val) {
                    _remarks[param] = val;
                  },
                ),
                const SizedBox(height: 24),
              ],
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
