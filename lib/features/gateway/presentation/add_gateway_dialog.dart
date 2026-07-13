import 'package:amiflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddGatewayDialog extends StatefulWidget {
  const AddGatewayDialog({super.key});

  @override
  State<AddGatewayDialog> createState() => _AddGatewayDialogState();
}

class _AddGatewayDialogState extends State<AddGatewayDialog> {
  final gatewayIdController = TextEditingController();
  final gatewayNameController = TextEditingController();

  @override
  void dispose() {
    gatewayIdController.dispose();
    gatewayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.router, color: AppColors.accent),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    "Add New Gateway",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _label("GATEWAY ID"),

            const SizedBox(height: 6),

            _textField(
              controller: gatewayIdController,
              hint: "Enter Gateway ID",
            ),

            const SizedBox(height: 18),

            _label("GATEWAY NAME"),

            const SizedBox(height: 6),

            _textField(
              controller: gatewayNameController,
              hint: "Enter Gateway Name",
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        final kode = gatewayIdController.text.trim();
                        final nama = gatewayNameController.text.trim();

                        // validasi sederhana: jangan kosong
                        if (kode.isEmpty || nama.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Isi semua field')),
                          );
                          return;
                        }

                        // kembalikan data ke halaman pemanggil
                        Navigator.pop(context, {'kode': kode, 'nama': nama});
                      },
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 11,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
      ),
    );
  }
}
