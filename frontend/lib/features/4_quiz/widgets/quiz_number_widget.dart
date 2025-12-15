import 'package:flutter/material.dart';
import 'package:frontend/features/4_quiz/utils/AgePickerController.dart';
import '../providers/quiz_provider.dart';

class AgePickerWheel extends StatefulWidget {
  final AgePickerController controller;
  final double height;
  final double itemExtent;
  final double highlightWidth;
  final double highlightHeight;

  const AgePickerWheel({
    super.key,
    required this.controller,
    this.height = 260,
    this.itemExtent = 72,
    this.highlightWidth = 260,
    this.highlightHeight = 110,
  });

  @override
  State<AgePickerWheel> createState() => _AgePickerWheelState();
}

class _AgePickerWheelState extends State<AgePickerWheel> {
  late final List<int> _ages;

  @override
  void initState() {
    super.initState();
    _ages = List.generate(
      widget.controller.max - widget.controller.min + 1,
      (i) => widget.controller.min + i,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.setAge(widget.controller.age.value, animate: false);
    });
  }

  TextStyle _styleFor(int age, int selected) {
    final diff = (age - selected).abs();
    if (diff == 0) {
      return const TextStyle(
        fontSize: 58,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      );
    } else if (diff == 1) {
      return const TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6B6259),
      );
    } else if (diff == 2) {
      return const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6B6259),
      );
    } else {
      return const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6B6259),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // highlight background
          IgnorePointer(
            child: Container(
              width: widget.highlightWidth,
              height: widget.highlightHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A48),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFDDE8D1), width: 3),
              ),
            ),
          ),

          ValueListenableBuilder<int>(
            valueListenable: widget.controller.age,
            builder: (_, selected, __) {
              return ListWheelScrollView.useDelegate(
                controller: widget.controller.scrollController,
                itemExtent: widget.itemExtent,
                physics: const FixedExtentScrollPhysics(),
                perspective: 0.003,
                diameterRatio: 2.0,
                onSelectedItemChanged: (index) {
                  final v = _ages[index];
                  widget.controller.age.value = v;
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _ages.length,
                  builder: (context, index) {
                    final age = _ages[index];
                    return Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 160),
                        style: _styleFor(age, selected),
                        child: Text("$age"),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Wrapper yang kompatibel dengan QuizScreen API
class QuizNumberWidget extends StatefulWidget {
  final int selected;
  final ValueChanged<int> onSelected;
  final int min;
  final int max;

  const QuizNumberWidget({
    super.key,
    required this.selected,
    required this.onSelected,
    this.min = 12,
    this.max = 99,
  });

  @override
  State<QuizNumberWidget> createState() => _QuizNumberWidgetState();
}

class _QuizNumberWidgetState extends State<QuizNumberWidget> {
  late AgePickerController _controller;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = AgePickerController(
      min: widget.min,
      max: widget.max,
      initialAge: widget.selected,
    );
    _listener = () => widget.onSelected(_controller.age.value);
    _controller.age.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant QuizNumberWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // selected changed -> scroll to that item
    if (oldWidget.selected != widget.selected) {
      _controller.setAge(widget.selected);
    }

    // range changed -> recreate controller safely
    if (oldWidget.min != widget.min || oldWidget.max != widget.max) {
      _controller.age.removeListener(_listener);
      _controller.dispose();

      _controller = AgePickerController(
        min: widget.min,
        max: widget.max,
        initialAge: widget.selected,
      );
      _controller.age.addListener(_listener);
    }
  }

  @override
  void dispose() {
    _controller.age.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AgePickerWheel(
        controller: _controller,
        height: 260,
        itemExtent: 72,
        highlightWidth: MediaQuery.of(context).size.width * 0.85,
        highlightHeight: 110,
      ),
    );
  }
}
