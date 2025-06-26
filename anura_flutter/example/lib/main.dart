import 'dart:developer';

import 'package:anura_flutter/anura_flutter.dart';
import 'package:anura_flutter/models/anura_scanned_data.dart';
import 'package:anura_flutter/models/anura_user_model.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AnuraScannedData? scannedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnuraFlutter Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (!context.mounted) return;
                try {
                  scannedData = await launchAnuraScanner(
                    AnuraUserModel(
                      partnerID: 'guest',
                      sex: AnuraUserModelSex.male,
                      height: 173,
                      age: 28,
                      weight: 98,
                    ),
                  );

                  log('got result');
                  // setState(() => _platformName = result);
                } catch (error, stack) {
                  log('error', stackTrace: stack, error: error);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Get Platform Name'),
            ),
            ElevatedButton(
              onPressed: () {
                log(scannedData.toString());
              },
              child: Text('print data'),
            ),
          ],
        ),
      ),
    );
  }
}
