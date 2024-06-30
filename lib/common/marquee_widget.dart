import 'dart:async';
import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final double scrollVelocity;

  const MarqueeWidget({
    Key? key,
    required this.child,
    this.scrollVelocity = 50.0, // pixels per second
  }) : super(key: key);

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController _scrollController;
  late Timer _timer;
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startScrolling();
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      double maxScrollExtent = _scrollController.position.extentTotal;
      double delta = widget.scrollVelocity * 20.0 / 1000.0; // pixels per frame
      setState(() {
        _offset += delta;
        if (_offset >= maxScrollExtent) {
          _offset -= maxScrollExtent;
        }
      });
      _scrollController.jumpTo(_offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          widget.child,
          SizedBox(width: MediaQuery.of(context).size.width), // Spacer
          widget.child, // Duplicate child to create illusion of infinite scroll
        ],
      ),
    );
  }
}
