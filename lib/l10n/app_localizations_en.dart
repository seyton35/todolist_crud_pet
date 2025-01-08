import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get todoList => 'Todo list';

  @override
  String get byTitleASC => 'title ↓';

  @override
  String get bytitleDESC => 'title ↑';

  @override
  String get createdAtASC => 'creation date ↓';

  @override
  String get createdAtDESC => 'creation date ↑';

  @override
  String get completed => 'completed ↓';

  @override
  String get uncompleted => 'completed ↑';

  @override
  String get archivedTodos => 'archived todos';

  @override
  String get logOut => 'log out';

  @override
  String get makeUntil => 'make until';
}
