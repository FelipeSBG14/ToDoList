import '../../core/database/sqlite_connection_factory.dart';
import './tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final SqliteConnectionFactory _sqLiteConnectionFactory;
  TasksRepositoryImpl(
      {required SqliteConnectionFactory sqLiteConnectionFactory})
      : _sqLiteConnectionFactory = sqLiteConnectionFactory;

  @override
  Future<void> save(DateTime date, String description) async {
    var conn = await _sqLiteConnectionFactory.openConnecction();
    await conn.insert(
      'todo',
      {
        'id': null,
        'descricao': description,
        'data_hora': date.toIso8601String(),
        'finalizado': 0,
      },
    );
  }
}
