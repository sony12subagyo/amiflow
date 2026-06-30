import 'package:amiflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddNodeDialog extends StatefulWidget {
  const AddNodeDialog({super.key});

  @override
  State<AddNodeDialog> createState() => _AddNodeDialogState();
}

class _AddNodeDialogState extends State<AddNodeDialog> {
  final TextEditingController nodeController = TextEditingController();
  final TextEditingController loraController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();

  String status = "ONLINE";
  String battery = "Full (100%)";

  @override
  void dispose() {
    nodeController.dispose();
    loraController.dispose();
    ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xff2B2D31),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white70,
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// HEADER
              Row(
                children: [

                  const Expanded(
                    child: Text(
                      "Add New IoT Node",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  )

                ],
              ),

              const SizedBox(height: 24),

              _label("NODE NAME"),

              const SizedBox(height: 6),

              _textField(
                controller: nodeController,
                hint: "e.g. Node 06",
              ),

              const SizedBox(height: 16),

              _label("LORA ID"),

              const SizedBox(height: 6),

              _textField(
                controller: loraController,
                hint: "e.g. 9022",
              ),

              const SizedBox(height: 16),

              _label("OWNER NAME"),

              const SizedBox(height: 6),

              _textField(
                controller: ownerController,
                hint: "e.g. Alex Rivers",
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _label("INITIAL STATUS"),

                        const SizedBox(height: 6),

                        _dropdown(
                          value: status,
                          items: const [
                            "ONLINE",
                            "OFFLINE",
                            "MAINTENANCE"
                          ],
                          onChanged: (value) {
                            setState(() {
                              status = value!;
                            });
                          },
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _label("BATTERY POWER"),

                        const SizedBox(height: 6),

                        _dropdown(
                          value: battery,
                          items: const [
                            "Full (100%)",
                            "75%",
                            "50%",
                            "25%",
                            "Low"
                          ],
                          onChanged: (value) {
                            setState(() {
                              battery = value!;
                            });
                          },
                        ),

                      ],
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 28),

              Row(
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3B3D42),
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
                          style: TextStyle(
                            color: Colors.white,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {

                          /// TODO
                          /// Simpan ke Database/API

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "ADD NODE",
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
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white38,
        ),
        filled: true,
        fillColor: const Color(0xff232428),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white30,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xff232428),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white30,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xff2B2D31),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          isExpanded: true,
          onChanged: onChanged,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}