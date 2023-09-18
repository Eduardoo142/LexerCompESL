import 'dart:io';
import 'lexer.dart';
import 'tokens.dart';
import 'parser.dart';
import 'evaluator.dart';

void startRepl() {
  while (true) {
    
    stdout.write('>> ');
    final source = stdin.readLineSync().toString();

    if (source == 'salir()') {
      print("Adios!");
      break;
    }
    final Lexer lexer = Lexer(source);
    final parser = Parser(lexer);
    final program = parser.parseProgram();
    final evaluated = evaluate(program);
    if (evaluated.runtimeType.toString() != "Null") {
      print(evaluated!.inspect());
    }
  }
}

void main(List<String> args) {
  startRepl();
}