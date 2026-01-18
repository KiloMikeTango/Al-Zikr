import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/counter_controller.dart';
import '../../widgets/counter_display.dart';
import '../../widgets/tap_button.dart';

class CustomCounterScreen extends StatelessWidget {
  final CounterController counter;
  const CustomCounterScreen({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: counter,
      child: const _CustomCounterBody(),
    );
  }
}

class _CustomCounterBody extends StatelessWidget {
  const _CustomCounterBody();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();
    final zikr = c.currentZikr;

    return Scaffold(
      appBar: AppBar(title: const Text('CUSTOM')),
      body: Column(
        children: [
          const Spacer(),
          CounterDisplay(count: c.currentCount),
          const SizedBox(height: 32),
          TapButton(
            large: true,
            onTap: () => c.tap(),
          ),
          const SizedBox(height: 24),
          if (zikr != null)
            Text('${c.currentCount}/${zikr.target}x  ${zikr.text}'),
          const Spacer(),
        ],
      ),
    );
  }
}
