import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';

class AddNodeDialog extends StatefulWidget {
  const AddNodeDialog({super.key});

  @override
  State<AddNodeDialog> createState() => _AddNodeDialogState();
}

class _AddNodeDialogState extends State<AddNodeDialog> {
  final nodeIdController = TextEditingController();
  final nodeNameController = TextEditingController();
  final ownerController = TextEditingController();
  final userController = TextEditingController(text: "0");

  @override
  void dispose() {
    nodeIdController.dispose();
    nodeNameController.dispose();
    ownerController.dispose();
    userController.dispose();
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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white12,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER
            Row(
              children: [

                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    "Add New Node",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 24),

            _label("NODE ID (E.G., LORA-7724)"),

            const SizedBox(height: 8),

            _field(
              controller: nodeIdController,
              hint: "Enter Node ID",
            ),

            const SizedBox(height: 18),

            _label("NODE NAME (E.G., NODE 01)"),

            const SizedBox(height: 8),

            _field(
              controller: nodeNameController,
              hint: "Enter Node Name",
            ),

            const SizedBox(height: 18),

            _label("OWNER NAME (NAMA PEMILIK)"),

            const SizedBox(height: 8),

            _field(
              controller: ownerController,
              hint: "Enter name",
            ),

            const SizedBox(height: 18),

            _label("NUMBER OF USERS (JUMLAH USER)"),

            const SizedBox(height: 8),

            _field(
              controller: userController,
              hint: "0",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 28),

            Row(
              children: [

                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff44474F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {

                        /// TODO
                        /// Simpan Node

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        elevation: 6,
                        shadowColor: AppColors.accent.withOpacity(.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "SAVE/ADD",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            )
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
          color: Colors.white70,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: .5,
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white38,
        ),
        filled: true,
        fillColor: const Color(0xff3A3D43),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}