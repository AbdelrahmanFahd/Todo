import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {this.title = '( Unnamed Task )',
      this.description = 'No Description Added',
      this.time,
      Key? key})
      : super(key: key);
  final String? title;
  final String description;
  final String? time;

  @override
  Widget build(BuildContext context) {
    final formatDate =
        DateFormat.yMMMd().format(DateTime.parse(time.toString()));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toString(),
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF211551)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              description == 'null' ? 'No Description Added' : description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF86829D),
                height: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              formatDate,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF86829D),
                // height: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Todo extends StatelessWidget {
  const Todo({this.title = 'Unnamed Todo', required this.isDone, Key? key})
      : super(key: key);
  final String? title;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Icon(
              isDone ? Icons.check_box : Icons.check_box_outline_blank_rounded,
              size: 24,
              color:
                  isDone ? const Color(0xFF7349FE) : const Color(0xFF86829D)),
        ),
        Flexible(
          child: Text(title.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: isDone ? FontWeight.w600 : FontWeight.w500,
                color:
                    isDone ? const Color(0xFF211551) : const Color(0xFF86829D),
              )),
        ),
      ]),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
