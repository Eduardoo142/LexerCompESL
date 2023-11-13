import 'objects.dart';
import 'tokens.dart';
import 'ast.dart' as ast;

final TRUE = Boolean(true);
final FALSE = Boolean(false);
final NULL = Null();

String _NOT_A_FUNCTION = 'No es una función';

Object _evaluateBangOperatorExpression(Object right) {
  if (right == TRUE) {
    return FALSE;
  } else if (right == FALSE || right == NULL) {
    return TRUE;
  } else {
    return FALSE;
  }
}

Object _toBooleanObject(bool value) {
  return value ? TRUE : FALSE;
}

Object _evaluateMinusOperatorExpression(Object right) {
  if (right is Integer) {
    final rightInt = right;
    return Integer(-rightInt.value);
  }
  return NULL;
  
}

Object _evaluatePrefixExpression(String operator, Object right) {
  if (operator == "!") {
    return _evaluateBangOperatorExpression(right);
  } else if (operator == "-") {
    return _evaluateMinusOperatorExpression(right);
  } else {
    return NULL;
  }
}
Object? _evaluateDoubleInfixExpression(
  String operator,
  Object left,
  Object right,
) {
  if (left is! Double || right is! Double) {
    return NULL;
  }

  final leftInt = left;
  final rightInt = right;

  switch (operator) {
    case "+":
      return Double(leftInt.value + rightInt.value);
    case "-":
      return Double(leftInt.value - rightInt.value);
    case "*":
      return Double(leftInt.value * rightInt.value);
    case "/":
      return Double(leftInt.value / rightInt.value);
    case "<":
      return _toBooleanObject(leftInt.value < rightInt.value);
    case "<=":
      return _toBooleanObject(leftInt.value <= rightInt.value);
    case ">":
      return _toBooleanObject(leftInt.value > rightInt.value);
    case ">=":
      return _toBooleanObject(leftInt.value >= rightInt.value);
    case "==":
      return _toBooleanObject(leftInt.value == rightInt.value);
    case "!=":
      return _toBooleanObject(leftInt.value != rightInt.value);
    default:
      return NULL;
  }
}

Object? _evaluateIntegerInfixExpression(
  String operator,
  Object left,
  Object right,
) {
  if (left is! Integer || right is! Integer) {
    return NULL;
  }

  final leftInt = left;
  final rightInt = right;

  switch (operator) {
    case "+":
      return Integer(leftInt.value + rightInt.value);
    case "-":
      return Integer(leftInt.value - rightInt.value);
    case "*":
      return Integer(leftInt.value * rightInt.value);
    case "/":
      return Integer(leftInt.value ~/ rightInt.value);
    case "<":
      return _toBooleanObject(leftInt.value < rightInt.value);
    case "<=":
      return _toBooleanObject(leftInt.value <= rightInt.value);
    case ">":
      return _toBooleanObject(leftInt.value > rightInt.value);
    case ">=":
      return _toBooleanObject(leftInt.value >= rightInt.value);
    case "==":
      return _toBooleanObject(leftInt.value == rightInt.value);
    case "!=":
      return _toBooleanObject(leftInt.value != rightInt.value);
    default:
      return NULL;
  }
}

Object? _evaluate_string_infix_expression(
  String operator,
  Object left,
  Object right,
) {
  if (left is StringObject && right is StringObject) {
    switch (operator) {
      case "+":
        return StringObject('${left.value}${right.value}');
      case "==":
        return _toBooleanObject(left.value == right.value);
      case "!=":
        return _toBooleanObject(left.value != right.value);
      default:
        return NULL;
    }
  }
  return NULL;
}

Object _evaluateInfixExpression(String operator, Object left, Object right) {
  if (left.type() == ObjectType.INTEGER && right.type() == ObjectType.INTEGER) {
    return _evaluateIntegerInfixExpression(operator, left, right) ?? NULL;
  } else if (left.type() == ObjectType.DOUBLE || right.type() == ObjectType.DOUBLE) {
    return _evaluateDoubleInfixExpression(operator, left, right) ?? NULL;
  } else if (left.type() == ObjectType.STRING || right.type() == ObjectType.STRING) {
    return _evaluate_string_infix_expression(operator, left, right) ?? NULL;
  } else if (operator == "==" && left == right) {
    return TRUE;
  } else if (operator == "!=" && left != right) {
    return TRUE;
  } else {
    return FALSE;
  }
}

Object? evaluate(ast.ASTNode node, [Environment? env]) {
  if (node is ast.Program) {
    return _evaluate_program(node, env);
  } else if (node is ast.ExpressionStatement) {
    if (node.expression != null) {
      return evaluate(node.expression!, env);
    }
  } else if (node is ast.Call) {
    final temp=env?.get(node.function.token.literal);
    if(temp is Functions){
      List<ast.Identifier> identifiers = temp.parameters.map((value) => ast.Identifier(Token(TokenType.IDENTIFIER, value.toString()), value.toString())).toList();
      final name=ast.Identifier(Token(TokenType.IDENTIFIER, temp.name!.value), temp.name!.value);
      final fun=ast.Functions(Token(TokenType.FUNCTION, 'funcion'));
      fun.name=name;
      fun.parameters=identifiers;
      fun.body=temp.body;
      node.function=fun;
    }
    final function = evaluate(node.function, env);
    final args = _evaluate_expression(node.arguments ?? [], env);
    List<Object> argsObj = List<Object>.from(args);
    return _apply_function(function!, argsObj);
  } else if (node is ast.Integer) {
    return Integer(node.value as int);
  } else if (node is ast.Double) {
    return Double(node.value as double);
  } else if (node is ast.Boolean) {
    return _toBooleanObject(node.value as bool);
  } else if (node is ast.Prefix) {
    final right = evaluate(node.right as ast.ASTNode, env);
    if (right != null) {
      return _evaluatePrefixExpression(node.operator, right);
    }
  } else if (node is ast.Infix) {
    final left = evaluate(node.left, env);
    final right = evaluate(node.right as ast.ASTNode, env);
    if (left != null && right != null) {
      return _evaluateInfixExpression(node.operator, left, right);
    }
  } else if (node is ast.Block) {
    return _evaluate_block_statement(node, env);
  } else if (node is ast.If) {
    return _evaluateIfExpression(node, env);
  } else if (node is ast.ReturnStatement) {
    final returnValues = evaluate(node.returnValue as ast.ASTNode, env);
    if (returnValues != null) {
      return Return(returnValues);
    } else {
      throw Exception('Return value cannot be null');
    }
  } else if (node is ast.LetStatement) {
    if (node.value != null) {
      final value = evaluate(node.value!, env);
      if (value != null) {
        env!.set(node.name!.value, value);
      }
    }
  } else if (node is ast.Identifier) {
    return _evaluate_identifier(node, env);
  } else if (node is ast.Functions) {
    final name = node.name;
    final parameters = node.parameters;
    final body = node.body;
    List<String> identifiersValues = parameters.map((identifier) => identifier.value).toList();
    final funcion=Functions(name, identifiersValues, body!, env!);
    env.set(node.name!.value, funcion);
    return funcion;
  } else if (node is ast.StringLiteral) {
    return StringObject(node.value as String);
  }

  return NULL;
}

Object _evaluate_identifier(ast.Identifier node, [Environment? env]) {
  final value = env?.get(node.value);
  if (value != null) {
    return value;
  }
  throw Exception('Variable ${node.value} not found in the environment');
}

Object? _evaluateStatements(List<ast.Statement> statements, [Environment? env]) {
  Object? result = NULL;
  for (final statement in statements) {
    result = evaluate(statement, env);
  }
  return result;
}

bool _isTruthy(Object obj) {
  return obj != NULL && obj != FALSE;
}

Object? _evaluateIfExpression(ast.If ifExpression, [Environment? env]) {
  final condition = evaluate(ifExpression.condition as ast.ASTNode, env);
  if (_isTruthy(condition!)) {
    return _evaluateStatements(ifExpression.consequence!.statements, env);
  } else if (ifExpression.alternative != null) {
    return _evaluateStatements(ifExpression.alternative!.statements, env);
  }
  return NULL;
}

Object? _evaluate_program(ast.Program program, [Environment? env]) {
  Object? result;
  for (final statement in program.statements) {
    result = evaluate(statement, env);

    if (result != null && result.type() == ObjectType.RETURN) {
      return (result as Return).value;
    }
  }
  return result;
}


Object? _evaluate_block_statement(ast.Block block, [Environment? env]) {
  Object? result;
  for (final statement in block.statements) {
    result = evaluate(statement, env);

    if (result != null && (result.type() == ObjectType.RETURN)) {
      return result;
    }
  }
  return result;
}

Object _unwrap_Return_Value(Object obj) {
  if (obj is Return) {
    return obj.value;
  }
  return obj;
}

List _evaluate_expression(List expression, [Environment? env]) {
  List resultados = [];
  for (final exp in expression) {
    final evaluated = evaluate(exp, env);
    if (evaluated != null) {
      resultados.add(evaluated);
    }
  }
  return resultados;
}

Environment _extend_function_env(
  Functions fn,
  List<Object> args,
) {
  final env = Environment(fn.env.store);

  for (var i = 0; i < fn.parameters.length; i++) {
    env.set(fn.parameters[i], args[i]);
  }

  return env;
}

Object _apply_function(Object fn, List<Object> args) {
  if (fn is Functions) {
    final extendedEnv = _extend_function_env(fn, args);
    final evaluated = evaluate(fn.body, extendedEnv);
    return _unwrap_Return_Value(evaluated!);
  }
  return _new_error(_NOT_A_FUNCTION, [fn.type().toString()]);
}

Object _new_error(String not_a_function, List<String> list) {
  throw Exception('Error: $not_a_function, $list');
}