import 'package:codelet/python_compiler_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness:
                  themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              primaryColor: themeProvider.isDarkMode
                  ? Colors.black
                  : Colors.blue.shade800,
              scaffoldBackgroundColor:
                  themeProvider.isDarkMode ? Colors.black : Colors.white,
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
                bodyMedium: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            home: PythonCompilerScreen(),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Python Compiler',
          theme: ThemeData(
            brightness:
                themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.blue,
          ),
          home: PythonCompilerScreen(),
        );
      },
    );
  }
}
