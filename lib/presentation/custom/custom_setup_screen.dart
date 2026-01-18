// lib/presentation/custom/custom_setup_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/custom_controller.dart';
import '../../widgets/add_zikr_dialog.dart';
import '../../widgets/zikr_card.dart';
import '../../core/constants/colors.dart';
import '../../core/responsive/responsive_layout.dart';
import 'custom_counter_screen.dart';

class CustomSetupScreen extends StatefulWidget {
  const CustomSetupScreen({super.key});

  @override
  State<CustomSetupScreen> createState() => _CustomSetupScreenState();
}

class _CustomSetupScreenState extends State<CustomSetupScreen> {
  final CustomController _controller = CustomController();

  void _addZikr() {
    showDialog(
      context: context,
      builder: (_) => AddZikrDialog(onAdd: (zikr) => _controller.addZikr(zikr.text, zikr.target)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      floatingActionButton: FloatingActionButton(
        onPressed: _addZikr,
        backgroundColor: AppColors.accentGreen,
        child: const Icon(Icons.add, color: AppColors.primaryBlack),
      ),
      body: Column(
        children: [
          Expanded(
            child: _controller.zikrs.isEmpty
                ? Center(
                    child: Text(
                      'Add your first Zikr',
                      style: TextStyle(color: AppColors.textWhite.withOpacity(0.7)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: _controller.zikrs.length,
                    itemBuilder: (context, index) {
                      final zikr = _controller.zikrs[index];
                      return ZikrCard(
                        title: '${zikr.text} (${zikr.target}x)',
                        icon: Icons.check,
                        isDesktop: ResponsiveLayout.isDesktop(context),
                        onTap: () {}, // List only
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _controller.zikrs.isNotEmpty
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomCounterScreen(controller: _controller),
                          ),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Start Counting', style: TextStyle(color: AppColors.primaryBlack, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
