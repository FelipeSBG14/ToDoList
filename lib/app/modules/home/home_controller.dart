// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/models/total_tasks_model.dart';
import 'package:todo_list_provider/app/models/week_task_model.dart';
import 'package:todo_list_provider/app/services/tasks/tasks_service.dart';
import '../../core/notifier/default_change_notifier.dart';
import '../../models/task_model.dart';

class HomeController extends DefaultChangeNotifier {
  final TasksService _tasksService;

  HomeController({required TasksService tasksService})
      : _tasksService = tasksService;

  var filterSelected = TaskFilterEnum.today;
  TotalTaskModel? todayTotalTasks;
  TotalTaskModel? tomorrowTotalTasks;
  TotalTaskModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? inititalDateOfWeek;
  DateTime? selectedDay;

  void loadTotalTasks() async {
    final allTaks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek(),
    ]);

    final todayTasks = allTaks[0] as List<TaskModel>;
    final tomorrowTasks = allTaks[1] as List<TaskModel>;
    final weekTasks = allTaks[2] as WeekTaskModel;

    todayTotalTasks = TotalTaskModel(
      totalTak: todayTasks.length,
      totalTaskFinish: todayTasks.where((task) => task.finished).length,
    );
    tomorrowTotalTasks = TotalTaskModel(
      totalTak: tomorrowTasks.length,
      totalTaskFinish: tomorrowTasks.where((task) => task.finished).length,
    );
    weekTotalTasks = TotalTaskModel(
      totalTak: weekTasks.tasks.length,
      totalTaskFinish: weekTasks.tasks.where((task) => task.finished).length,
    );
    notifyListeners();
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekModal = await _tasksService.getWeek();
        inititalDateOfWeek = weekModal.startDate;
        tasks = weekModal.tasks;
        break;
    }

    filteredTasks = tasks;
    allTasks = tasks;

    if (filter == TaskFilterEnum.week) {
      if (selectedDay != null) {
        filterByDay(selectedDay!);
      } else if (inititalDateOfWeek != null) {
        filterByDay(inititalDateOfWeek!);
      }
    } else {
      selectedDay = null;
    }

    hideLoading();
    notifyListeners();
  }

  Future<void> filterByDay(DateTime date) async {
    selectedDay = date;
    filteredTasks = allTasks.where((task) {
      return task.dateTime == date;
    }).toList();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    loadTotalTasks();
    notifyListeners();
  }
}
