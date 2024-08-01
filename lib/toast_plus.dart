import 'package:flutter/material.dart';

class ToastPlus {
  static void show(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 2),
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 0,
        right: 0,
        child: ToastWidget(
          message: message,
          type: type,
          duration: duration,
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;

  ToastWidget({
    required this.message,
    required this.type,
    required this.duration,
  });

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(widget.duration, () {
        _controller.reverse().then((_) {
          if (mounted) {
            // Remove the toast from the overlay
            Overlay.of(context)!.dispose();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _getBackgroundColor(widget.type),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getIcon(widget.type),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.danger:
        return Colors.red;
      case ToastType.info:
        return Colors.blue;
      case ToastType.warning:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _getIcon(ToastType type) {
    IconData icon;
    switch (type) {
      case ToastType.success:
        icon = Icons.check_circle;
        break;
      case ToastType.danger:
        icon = Icons.error;
        break;
      case ToastType.info:
        icon = Icons.info;
        break;
      case ToastType.warning:
        icon = Icons.warning;
        break;
      default:
        icon = Icons.help_outline;
    }

    return Icon(
      icon,
      color: Colors.white,
      size: 24,
    );
  }
}

enum ToastType { success, danger, info, warning }
