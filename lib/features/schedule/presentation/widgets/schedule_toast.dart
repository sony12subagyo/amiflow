import 'dart:async';

import 'package:amiflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ScheduleToast {
  static OverlayEntry? _currentToast;
  static Timer? _timer;

  static void show(BuildContext context, {required String message}) {
    final overlay = Overlay.of(context);
    _currentToast?.remove();
    _timer?.cancel();

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return _ScheduleToastWidget(message: message);
      },
    );

    overlay.insert(entry);

    _timer = Timer(const Duration(milliseconds: 2500), () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }
}

class _ScheduleToastWidget extends StatefulWidget {
  final String message;

  const _ScheduleToastWidget({required this.message});

  @override
  State<_ScheduleToastWidget> createState() => _ScheduleToastWidgetState();
}

class _ScheduleToastWidgetState extends State<_ScheduleToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (!mounted) return;

      await _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 110,
      left: 30,
      right: 30,
      child: FadeTransition(
        opacity: _opacity,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.accent.withOpacity(.25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, color: AppColors.accent),

                  const SizedBox(width: 12),

                  Flexible(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
