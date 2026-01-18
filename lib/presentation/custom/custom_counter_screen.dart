// lib/presentation/custom/custom_counter_screen.dart
import 'package:al_zikr/controllers/counter_controller.dart';
import 'package:al_zikr/widgets/counter_display.dart';
import 'package:al_zikr/widgets/tap_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCounterScreen extends StatelessWidget {
  final CounterController counter;
  final String title; // <-- add

  const CustomCounterScreen({
    super.key,
    required this.counter,
    this.title = 'CUSTOM', // default when used from Custom mode
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: counter,
      child: _CustomCounterBody(title: title),
    );
  }
}

class _CustomCounterBody extends StatelessWidget {
  final String title;
  const _CustomCounterBody({required this.title});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();
    final zikr = c.currentZikr;

    return Scaffold(
      appBar: AppBar(
        title: Text(title), // <-- shows preset name or "CUSTOM"
      ),
      body: Column(
        children: [
          const Spacer(),
          CounterDisplay(count: c.currentCount),
          const SizedBox(height: 32),
          TapButton(large: true, onTap: () => c.tap()),
          const SizedBox(height: 24),
          if (zikr != null)
            Text('${c.currentCount}/${zikr.target}x  ${zikr.text}'),
          const Spacer(),
        ],
      ),
    );
  }
}
