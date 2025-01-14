import 'package:logger/logger.dart';

final logger = (Type type) => Logger(
  printer: CustomerPrinter(type.toString()),
  level: Level.verbose,
);

class CustomerPrinter extends LogPrinter {
  final String className;

  CustomerPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji $className: $message')];
  }
}