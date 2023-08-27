class TokenType {
  static const ASSIGN = "ASIGNACION";
  static const PLUS = "SUMA";
  static const EOF = "EOF";
  static const LPAREN = "PARENIZQ";
  static const RPAREN = "PARENDER";
  static const LBRACE = "LLAVEIZQ";
  static const RBRACE = "LLAVEDER";
  static const COMMA = "COMA";
  static const SEMICOLON = "PUNTOYCOMA";
  static const MINUS = "MENOS";
  static const DIVISION = "DIVISION";
  static const MULTIPLICATION = "MULTIPLICACION";
  static const LT = "LT";
  static const GT = "GT";
  static const NOT_EQ = "NO_EQ";
  static const NEGATION = "NEGACION";
  static const INT = "INT";
  static const ILLEGAL = "ILEGAL";
  static const FALSE = "FALSO";
  static const FUNCTION = "FUNCION";
  static const LET = "LET";
  static const TRUE = "VERDADERO";
  static const IF = "SI";
  static const ELSE = "SINO";
  static const RETURN = "RETORNAR";
  static const EQ = "EQ";
  static const STRING = "STRING";
  static const COLON = "COLON";
  static const IDENTIFIER = "IDENTIFICADOR";
}

class Token {
  final String type;
  final String literal;

  Token(this.type, this.literal);
}
