import 'package:flutter/material.dart';

class AnimatedMove extends StatefulWidget {
  final Offset initialOffset;
  final Duration duration;
  final Widget child;
  final bool scale;

  const AnimatedMove({
    super.key,
    required this.initialOffset,
    required this.duration,
    required this.child,
    this.scale = true,
  });

  @override
  State<AnimatedMove> createState() => _AnimatedMoveState();
}

class _AnimatedMoveState extends State<AnimatedMove>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration, // Adjust animation duration
    );
    _offsetAnimation = Tween<Offset>(
      begin: widget.initialOffset,
      end: const Offset(0, 0),
    ).animate(_controller);
    if (widget.scale) {
      _scaleAnimation = Tween<double>(
        begin: 0.8, // Adjust initial scale
        end: 1.0, // Adjust end scale
      ).animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.reset();
    _controller.forward();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: widget.scale
              ? Transform.scale(
                  scale: _scaleAnimation.value,
                  child: widget.child,
                )
              : widget.child,
        );
      },
      child: widget.child,
    );
  }
}
