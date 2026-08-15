import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/models/task.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';
import 'package:gorev_takip_flutter/screens/Task_detail_screen.dart';


class TaskCard extends StatelessWidget {
  final Task task;
  final ApiService apiService;

  final Future<void> Function() onTaskUpdated;

  const TaskCard({
    super.key,
    required this.task,
    required this.apiService,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child:InkWell(
              onTap: () async{
                final result=await Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> TaskDetailScreen(task: task,),),);
                    if (result==true){
                      await onTaskUpdated();
                    }
              },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Checkbox(
                    value: task.completed,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),

                    fillColor:
                        WidgetStateProperty.resolveWith((states) {
                      if (states.contains(
                        WidgetState.selected,
                      )) {
                        return Colors.deepPurple;
                      }

                      return Colors.transparent;
                    }),

                    checkColor: Colors.white,

                    onChanged: (bool? value) async {
                      if (value != null) {
                        await apiService.updateTask(
                          task.id,
                          task.title,
                          task.description,
                          value,
                        );
                        await onTaskUpdated();
                      }
                    },
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: task.completed
                              ? Colors.grey
                              :Colors.black87,
                            decoration:
                                task.completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                task.completed
                                    ? Colors.grey
                                    : Colors.black87,
                           ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}