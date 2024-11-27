import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serious_python/serious_python.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:local_assets_server/local_assets_server.dart';

class PythonCompilerScreen extends StatefulWidget {
  const PythonCompilerScreen({super.key});

  @override
  _PythonCompilerScreenState createState() => _PythonCompilerScreenState();
}

class _PythonCompilerScreenState extends State<PythonCompilerScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = '';
  late LocalAssetsServer _server;

  @override
  void initState() {
    super.initState();
    _initializePython();
    _startLocalServer();
  }

  // Initialize Python
  void _initializePython() async {
    final directory = await getApplicationDocumentsDirectory();
    final appZipPath = '${directory.path}/app.zip';
    final appZip = File(appZipPath);

    if (!appZip.existsSync()) {
      final byteData = await rootBundle.load('assets/app/app.zip');
      final buffer = byteData.buffer;
      await appZip.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }

    await SeriousPython.run(appZipPath);
  }

  // Start Local Server to handle requests
  void _startLocalServer() async {
    final directory = await getApplicationDocumentsDirectory();
    _server = LocalAssetsServer(
      address:
          InternetAddress.loopbackIPv4, // This binds to localhost (127.0.0.1)
      port: 5000,
      assetsBasePath: directory.path,
    );
    await _server.serve();
    print('Server running at: ${_server.address}');
  }

  // Execute Python Code via API Call
  void _executeCode() async {
    final code = _codeController.text;
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _output = result['output'];
        });
      } else {
        setState(() {
          _output = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
      });
    }
  }

  // Clear input and output
  void _clear() {
    setState(() {
      _codeController.clear();
      _output = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Python Compiler'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Python Compiler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Python code here...',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _executeCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Compile'),
                  ),
                  ElevatedButton(
                    onPressed: _clear,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _output,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
