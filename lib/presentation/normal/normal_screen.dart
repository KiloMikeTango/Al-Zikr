import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/counter_controller.dart';
import '../../widgets/tap_button.dart';
import '../../widgets/counter_display.dart';
import '../../widgets/confirm_exit_dialog.dart';

class NormalScreen extends StatelessWidget {
  const NormalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterController()..setSingleMode(),
      child: const _NormalBody(),
    );
  }
}

class _NormalBody extends StatelessWidget {
  const _NormalBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CounterController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ConfirmExitDialog(
                          onConfirm: () => Navigator.pop(context),
                        ),
                      );
                    },
                  ),
                  const Text('NORMAL'),
                ],
              ),
            ),
            const Spacer(),
            CounterDisplay(count: controller.currentCount),
            const SizedBox(height: 32),
            TapButton(
              large: true,
              onTap: () => controller.tap(),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => controller.reset(),
              child: const Text('RESET'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
