import 'package:flutter/material.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/widgets/task_status/task_status_widget.dart';

class StatusWidget extends StatelessWidget {
  final Function(TaskStatus)? onTap;
  const StatusWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    List<TaskStatus> status = [...TaskStatus.values];
    status.sort((a, b) => a.order.compareTo(b.order));
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Center(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: status.length,
          itemBuilder: (BuildContext context, int index) {
            return TaskStatusWidget(status: status[index], onTap: (status) => onTap?.call(status));
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
        ),
      ),
    );
  }
}
