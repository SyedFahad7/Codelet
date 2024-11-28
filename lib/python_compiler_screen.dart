import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serious_python/serious_python.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'select_avatar_screen.dart';
import 'constants/app_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class PythonCompilerScreen extends StatefulWidget {
  @override
  _PythonCompilerScreenState createState() => _PythonCompilerScreenState();
}

class _PythonCompilerScreenState extends State<PythonCompilerScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = '';
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _initializePython();
    loadSelectedAvatar();
  }

  Future<void> loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar =
          prefs.getString('selectedAvatar') ?? 'assets/images/dummy.png';
    });
  }

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

  void _executeCode() async {
    final code = _codeController.text;
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.169:5000/execute'), // Using your local IP here
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

  void _clear() {
    setState(() {
      _codeController.clear();
      _output = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor:
            themeProvider.isDarkMode ? Colors.black : Colors.blue.shade800,
        scaffoldBackgroundColor:
            themeProvider.isDarkMode ? Colors.black : Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          bodyMedium: TextStyle(
              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 16.0, right: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: themeProvider.isDarkMode
                      ? Colors.black
                      : Colors.blue.shade800,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectAvatarScreen(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              selectedAvatar = result;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('selectedAvatar', result);
                          }
                        },
                        child: CircleAvatar(
                          radius: 23.0,
                          backgroundImage: AssetImage(
                              selectedAvatar ?? 'assets/images/dummy.png'),
                        ),
                      ),
                      const Spacer(),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                          child: Text(
                            'Python Compiler',
                            style: TextStyle(
                              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                        child: IconButton(
                          icon: Icon(themeProvider.isDarkMode
                              ? Icons.wb_sunny
                              : Icons.nights_stay),
                          onPressed: () {
                            themeProvider.toggleTheme();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final backgroundColor = themeProvider.isDarkMode
                                    ? Colors.black
                                    : Colors.white;
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  Navigator.of(context).pop(true);
                                });
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: AlertDialog(
                                      title: Text(
                                        themeProvider.isDarkMode
                                            ? 'Dark Mode'
                                            : 'Light Mode',
                                        style: TextStyle(
                                          fontFamily: AppFonts
                                              .fontFamilyPlusJakartaSans,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      content: Text(
                                        'You have switched to ${themeProvider.isDarkMode ? 'Dark' : 'Light'} Mode.',
                                        style: TextStyle(
                                          fontFamily: AppFonts
                                              .fontFamilyPlusJakartaSans,
                                          fontSize: 14.0,
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Python Compiler',
                  style: TextStyle(
                    fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _codeController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    hintText: 'Enter Python code here...',
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                      color: themeProvider.isDarkMode
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  cursorColor:
                      themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _executeCode,
                      child: const Text('Compile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _clear,
                      child: const Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Colors.grey[900]
                        : Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Output:',
                        style: TextStyle(
                          fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _output,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                          color: Colors.yellow,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
