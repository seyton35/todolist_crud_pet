import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get todoList => 'Заметки';

  @override
  String get byTitleASC => 'по алфавиту ↓';

  @override
  String get bytitleDESC => 'по алфавиту ↑';

  @override
  String get createdAtASC => 'дата создания ↓';

  @override
  String get createdAtDESC => 'дата создания ↑';

  @override
  String get completed => 'выполненые ↓';

  @override
  String get uncompleted => 'выполненые ↑';

  @override
  String get archivedTodos => 'архив заметок';

  @override
  String get logOut => 'выход';

  @override
  String get makeUntil => 'сделать до';
}
