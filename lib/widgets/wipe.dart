import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fractal_base/db.dart';

class WipeButton extends StatefulWidget {
  const WipeButton({super.key});

  @override
  State<WipeButton> createState() => _WipeButtonState();
}

class _WipeButtonState extends State<WipeButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        DBF.main.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('local DB was wiped out'),
            backgroundColor: Colors.green,
          ),
        );
        Timer(const Duration(seconds: 1), () {
          //Restart.restartApp();
        });
      },
      tooltip: 'Wipe local data',
      icon: const Icon(
        color: Colors.red,
        Icons.cleaning_services_rounded,
      ),
    );
  }
}
