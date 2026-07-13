import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/edit_node_result.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:flutter/material.dart';

class EditNodeBottomSheet extends StatefulWidget {
  final Node node;

  const EditNodeBottomSheet({super.key, required this.node});

  @override
  State<EditNodeBottomSheet> createState() => _EditNodeBottomSheetState();
}

class _EditNodeBottomSheetState extends State<EditNodeBottomSheet> {
  late TextEditingController ownerController;

  late int totalUsers;

  @override
  void initState() {
    super.initState();

    ownerController = TextEditingController(text: widget.node.owner);

    totalUsers = widget.node.totalUsers;
  }

  @override
  void dispose() {
    ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),

        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 22),

            const Row(
              children: [
                Icon(Icons.edit_outlined, color: AppColors.accent),

                SizedBox(width: 10),

                Text(
                  "Edit Node",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nama Pemilik",
                style: TextStyle(color: Colors.white.withOpacity(.7)),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: ownerController,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Jumlah Pengguna",
                style: TextStyle(color: Colors.white.withOpacity(.7)),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (totalUsers == 1) return;

                      setState(() {
                        totalUsers--;
                      });
                    },

                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.white,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "$totalUsers Orang",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        totalUsers++;
                      });
                    },

                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Digunakan sebagai acuan analisis Machine Learning.",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("Batal"),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),

                    onPressed: () {
                      Navigator.pop(
                        context,
                        EditNodeResult(
                          owner: ownerController.text.trim(),
                          totalUsers: totalUsers,
                        ),
                      );
                    },

                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
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
}
