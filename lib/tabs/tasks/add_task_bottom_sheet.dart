import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/default_elevated_button.dart';
import 'package:todo/tabs/tasks/default_text_form_field.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                'Add new task',
                style: titleMediumStyle,
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: titleController,
                hintText: 'Enter task title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title can not be empty';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: descriptionController,
                hintText: 'Enter task description',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description can not be empty';
                  } else {
                    return null;
                  }
                },
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Text(
                'Select date',
                style: titleMediumStyle?.copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDate: selectedDate,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (dateTime != null) {
                    selectedDate = dateTime;
                    setState(() {});
                  }
                },
                child: Text(
                  dateFormat.format(selectedDate),
                  style: titleMediumStyle,
                ),
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                label: 'Submit',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    addTask();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    FirebaseFunctions.addTaskToFirestore(
      TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate,
      ),
      userId,
    ).then(
      (_) {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
          msg: 'Task added successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.green,
          textColor: Colors.white,
          fontSize: 16,
        );
      },
    ).catchError(
      (error) {
        Fluttertoast.showToast(
          msg: 'Something went wrong!',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      },
    );
  }
}
