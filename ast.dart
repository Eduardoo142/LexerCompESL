import 'tokens.dart';

abstract class ASTNode {
  String tokenLiteral();
  String toString();
}

class Statement extends ASTNode {
  final Token token;

  Statement(this.token);

  @override
  String tokenLiteral() {
    return token.literal;
  }

  @override
  String toString() {
    return token.literal;
  }
}

class Expression extends ASTNode {
  final Token token;

  Expression(this.token);

  @override
  String tokenLiteral() {
    return token.literal;
  }

  @override
  String toString() {
    return token.literal;
  }
}

class Program extends ASTNode {
  final List<Statement> statements;

  Program(this.statements);

  @override
  String tokenLiteral() {
    if (statements.isNotEmpty) {
      return statements[0].tokenLiteral();
    }
    return '';
  }

  @override
  String toString() {
    return statements.map((statement) => statement.toString()).join('');
  }
}
