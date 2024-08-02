import 'package:flutter/material.dart';

class ToastPlus {
  static void show(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 2),
    bool isRTL = false,
    ToastPosition position = ToastPosition.bottom,
    bool animatedIcon = false,
    IconData? customIcon,
    Color? customBackgroundColor,
    TextStyle? textStyle,
    double borderRadius = 8.0,
    UniqueKey? toastKey,
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: (position == ToastPosition.bottom && !isRTL) ? 0 : null,
        right: (position == ToastPosition.bottom && isRTL) ? 0 : null,
        bottom: position == ToastPosition.bottom ? 50 : null,
        top: position == ToastPosition.top ? 50 : null,
        child: ToastWidget(
          key: toastKey ?? UniqueKey(),
          message: message,
          type: type,
          duration: duration,
          isRTL: isRTL,
          animatedIcon: animatedIcon,
          customIcon: customIcon,
          customBackgroundColor: customBackgroundColor,
          textStyle: textStyle,
          borderRadius: borderRadius,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final bool isRTL;
  final bool animatedIcon;
  final IconData? customIcon;
  final Color? customBackgroundColor;
  final TextStyle? textStyle;
  final double borderRadius;

  ToastWidget({
    Key? key,
    required this.message,
    required this.type,
    required this.duration,
    this.isRTL = false,
    this.animatedIcon = false,
    this.customIcon,
    this.customBackgroundColor,
    this.textStyle,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _zoomAnimation;

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

    _zoomAnimation = Tween<double>(begin: -10, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // Smooth zoom effect
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(widget.duration, () {
        _controller.reverse().then((_) {
          if (mounted) {
            // Remove the toast from the overlay
            Overlay.of(context).dispose();
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
        child: Align(
          alignment:
              widget.isRTL ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 40,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: widget.customBackgroundColor ??
                  _getBackgroundColor(widget.type),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              mainAxisAlignment: widget.isRTL
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (widget.isRTL) ...[
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: widget.textStyle ?? TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildIcon(),
                ] else ...[
                  _buildIcon(),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: widget.textStyle ?? TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.type == ToastType.none) {
      return SizedBox.shrink();
    }

    Widget icon = Icon(
      widget.customIcon ?? _getIconData(widget.type),
      color: Colors.white,
      size: 24,
    );

    if (widget.animatedIcon) {
      icon = ScaleTransition(
        scale: _zoomAnimation,
        child: icon,
      );
    }

    return icon;
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

  IconData _getIconData(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.danger:
        return Icons.error;
      case ToastType.info:
        return Icons.info;
      case ToastType.warning:
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }
}

enum ToastType { success, danger, info, warning, none }

enum ToastPosition { top, bottom }
