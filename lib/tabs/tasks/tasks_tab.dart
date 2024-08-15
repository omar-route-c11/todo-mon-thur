import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: screenHeight * 0.16,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
            ),
            PositionedDirectional(
              top: 40,
              start: 20,
              child: Text(
                'ToDo List',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 22,
                      color: AppTheme.white,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(Duration(days: 365)),
                showTimelineHeader: false,
                onDateChange: (selectedDate) {
                  tasksProvider.changeSelectedDate(selectedDate);
                  tasksProvider.getTasks();
                },
                activeColor: AppTheme.white,
                dayProps: EasyDayProps(
                  height: 90,
                  width: 60,
                  dayStructure: DayStructure.dayNumDayStr,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 20),
            itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
            itemCount: tasksProvider.tasks.length,
          ),
        ),
      ],
    );
  }
}
