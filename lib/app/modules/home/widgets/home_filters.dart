import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/models/total_tasks_model.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';
import 'package:todo_list_provider/app/modules/home/widgets/todo_card_filter.dart';

class HomeFilters extends StatelessWidget {
  const HomeFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILTROS',
          style: context.titleStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TodoCardFilter(
                label: 'HOJE',
                taskFilter: TaskFilterEnum.today,
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.today,
                totalTaskModel: context.select<HomeController, TotalTaskModel?>(
                  (controller) => controller.todayTotalTasks,
                ),
              ),
              TodoCardFilter(
                label: 'AMANHÃ',
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.tomorrow,
                taskFilter: TaskFilterEnum.tomorrow,
                totalTaskModel: context.select<HomeController, TotalTaskModel?>(
                  (controller) => controller.tomorrowTotalTasks,
                ),
              ),
              TodoCardFilter(
                label: 'SEMANA',
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.week,
                taskFilter: TaskFilterEnum.week,
                totalTaskModel: context.select<HomeController, TotalTaskModel?>(
                  (controller) => controller.weekTotalTasks,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
