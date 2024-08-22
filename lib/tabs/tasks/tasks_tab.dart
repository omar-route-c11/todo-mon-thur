import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTasks = true;

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    if (shouldGetTasks) {
      final userId = Provider.of<UserProvider>(context).currentUser!.id;
      tasksProvider.getTasks(userId);
      shouldGetTasks = false;
    }

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
                AppLocalizations.of(context)!.todoList,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 22,
                      color: AppTheme.white,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(const Duration(days: 365)),
                showTimelineHeader: false,
                onDateChange: (selectedDate) {
                  tasksProvider.changeSelectedDate(selectedDate);
                  tasksProvider.getTasks(
                      Provider.of<UserProvider>(context, listen: false)
                          .currentUser!
                          .id);
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
                  todayStyle: DayStyle(
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
            padding: const EdgeInsets.only(top: 20),
            itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
            itemCount: tasksProvider.tasks.length,
          ),
        ),
      ],
    );
  }
}
