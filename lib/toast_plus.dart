library toast_plus;

import 'package:flutter/material.dart';

enum ToastPosition {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class ToastPlus {
  static final List<OverlayEntry> _overlayQueue = [];

  static void show(
    BuildContext context, {
    required String message,
    required ToastPosition position,
    Color backgroundColor = Colors.black,
    Gradient? backgroundGradient,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    EdgeInsets padding = const EdgeInsets.all(16.0),
    EdgeInsets margin = const EdgeInsets.all(16.0),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    Duration duration = const Duration(seconds: 3),
    Duration delay = Duration.zero,
    bool isRTL = false,
    bool noClickOutside = false,
    bool isPopup = false,
    bool isFullWidth = false,
    bool isDarkMode = false,
    Widget? endTimeWidget,
    VoidCallback? onDismiss,
    Widget? icon,
    Widget? actionButton,
    Curve showCurve = Curves.easeIn,
    Curve hideCurve = Curves.easeOut,
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        position: position,
        backgroundColor: backgroundColor,
        backgroundGradient: backgroundGradient,
        textColor: textColor,
        fontSize: fontSize,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        duration: duration,
        isRTL: isRTL,
        noClickOutside: noClickOutside,
        isPopup: isPopup,
        isFullWidth: isFullWidth,
        isDarkMode: isDarkMode,
        endTimeWidget: endTimeWidget,
        onDismiss: onDismiss,
        icon: icon,
        actionButton: actionButton,
        showCurve: showCurve,
        hideCurve: hideCurve,
      ),
    );

    Future.delayed(delay, () {
      Overlay.of(context).insert(overlayEntry);
      _overlayQueue.add(overlayEntry);

      Future.delayed(duration, () {
        overlayEntry.remove();
        _overlayQueue.remove(overlayEntry);
        if (onDismiss != null) onDismiss();
      });
    });
  }

  static void dismissAll() {
    for (var entry in _overlayQueue) {
      entry.remove();
    }
    _overlayQueue.clear();
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastPosition position;
  final Color backgroundColor;
  final Gradient? backgroundGradient;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final Duration duration;
  final bool isRTL;
  final bool noClickOutside;
  final bool isPopup;
  final bool isFullWidth;
  final bool isDarkMode;
  final Widget? endTimeWidget;
  final Widget? icon;
  final Widget? actionButton;
  final Curve showCurve;
  final Curve hideCurve;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.position,
    required this.backgroundColor,
    this.backgroundGradient,
    required this.textColor,
    required this.fontSize,
    required this.padding,
    required this.margin,
    required this.borderRadius,
    required this.duration,
    required this.isRTL,
    required this.noClickOutside,
    required this.isPopup,
    required this.isFullWidth,
    required this.isDarkMode,
    this.endTimeWidget,
    this.icon,
    this.actionButton,
    required this.showCurve,
    required this.hideCurve,
    VoidCallback? onDismiss,
  }) : super(key: key);

  @override
  __ToastWidgetState createState() => __ToastWidgetState();
}

class __ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.showCurve,
      reverseCurve: widget.hideCurve,
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      _controller.reverse().then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Positioned(
        top: widget.position == ToastPosition.top ||
                widget.position == ToastPosition.topLeft ||
                widget.position == ToastPosition.topRight
            ? widget.margin.top
            : null,
        bottom: widget.position == ToastPosition.bottom ||
                widget.position == ToastPosition.bottomLeft ||
                widget.position == ToastPosition.bottomRight
            ? widget.margin.bottom
            : null,
        left: widget.position == ToastPosition.left ||
                widget.position == ToastPosition.topLeft ||
                widget.position == ToastPosition.bottomLeft
            ? widget.margin.left
            : null,
        right: widget.position == ToastPosition.right ||
                widget.position == ToastPosition.topRight ||
                widget.position == ToastPosition.bottomRight
            ? widget.margin.right
            : null,
        child: Align(
          alignment: _getAlignment(),
          child: GestureDetector(
            onTap: widget.noClickOutside
                ? () {}
                : () {
                    _controller.reverse().then((value) {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  },
            child: Material(
              color: Colors.transparent,
              child: FadeTransition(
                opacity: _animation,
                child: Container(
                  padding: widget.padding,
                  margin: widget.margin,
                  width: widget.isFullWidth ? double.infinity : null,
                  decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.grey[900]
                        : widget.backgroundColor,
                    gradient: widget.backgroundGradient,
                    borderRadius: widget.borderRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) widget.icon!,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: widget.textColor,
                                fontSize: widget.fontSize,
                              ),
                            ),
                            if (widget.endTimeWidget != null)
                              widget.endTimeWidget!,
                          ],
                        ),
                      ),
                      if (widget.actionButton != null) widget.actionButton!,
                      IconButton(
                        icon: Icon(Icons.close, color: widget.textColor),
                        onPressed: () {
                          _controller.reverse().then((value) {
                            if (mounted) {
                              setState(() {});
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    switch (widget.position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
      case ToastPosition.left:
        return Alignment.centerLeft;
      case ToastPosition.right:
        return Alignment.centerRight;
      case ToastPosition.topLeft:
        return Alignment.topLeft;
      case ToastPosition.topRight:
        return Alignment.topRight;
      case ToastPosition.bottomLeft:
        return Alignment.bottomLeft;
      case ToastPosition.bottomRight:
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }
}
