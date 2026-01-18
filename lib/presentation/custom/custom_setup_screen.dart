import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/custom_controller.dart';
import '../../controllers/counter_controller.dart';
import '../../widgets/add_zikr_dialog.dart';
import '../../widgets/zikr_card.dart';
import 'custom_counter_screen.dart';

class CustomSetupScreen extends StatelessWidget {
  const CustomSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomController(),
      child: const _CustomSetupBody(),
    );
  }
}

class _CustomSetupBody extends StatelessWidget {
  const _CustomSetupBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CustomController>();

    return Scaffold(
      appBar: AppBar(title: const Text('CUSTOM')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddZikrDialog(
            onAdd: (item) => controller.addZikr(item),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: controller.zikrs.isEmpty
                ? const Center(child: Text('No Zikr yet'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.zikrs.length,
                    itemBuilder: (_, i) {
                      final z = controller.zikrs[i];
                      return ZikrCard(
                        title: '${z.text} (${z.target}x)',
                        icon: Icons.drag_handle,
                        onTap: () {},
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: controller.zikrs.isEmpty
                  ? null
                  : () {
                      final counter = CounterController()
                        ..setZikrs(controller.zikrs);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomCounterScreen(counter: counter),
                        ),
                      );
                    },
              child: const Text('START'),
            ),
          ),
        ],
      ),
    );
  }
}
