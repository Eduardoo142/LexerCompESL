//class TokenType {
//  static const ASSIGN = "ASIGNACION";
//  static const PLUS = "SUMA";
//  static const EOF = "EOF";
//  static const LPAREN = "PARENIZQ";
//  static const RPAREN = "PARENDER";
//  static const LBRACE = "LLAVEIZQ";
//  static const RBRACE = "LLAVEDER";
//  static const COMMA = "COMA";
//  static const SEMICOLON = "PUNTOYCOMA";
//  static const MINUS = "MENOS";
//  static const DIVISION = "DIVISION";
//  static const MULTIPLICATION = "MULTIPLICACION";
//  static const LT = "LT";
//  static const GT = "GT";
//  static const NOT_EQ = "NO_EQ";
//  static const NEGATION = "NEGACION";
//  static const INT = "INT";
//  static const ILLEGAL = "ILEGAL";
//  static const FALSE = "FALSO";
//  static const FUNCTION = "FUNCION";
//  static const LET = "LET";
//  static const TRUE = "VERDADERO";
//  static const IF = "SI";
//  static const ELSE = "SINO";
//  static const RETURN = "RETORNAR";
//  static const EQ = "EQ";
//  static const STRING = "STRING";
//  static const COLON = "COLON";
//  static const IDENTIFIER = "IDENTIFICADOR";
//}

enum TokenType {
  ASSIGN,
  PLUS,
  EOF,
  LPAREN,
  RPAREN,
  LBRACE,
  RBRACE,
  COMMA,
  SEMICOLON,
  MINUS,
  DIVISION,
  MULTIPLICATION,
  LT,
  GT,
  NOT_EQ,
  NEGATION,
  INT,
  ILLEGAL,
  FALSE,
  FUNCTION,
  LET,
  TRUE,
  IF,
  ELSE,
  RETURN,
  EQ,
  STRING,
  COLON,
  IDENTIFIER,
  DIF,
  INTEGER,
}

class Token {
  final TokenType token_type;
  final String literal;

  Token(this.token_type, this.literal);
  @override
  String toString() {
    return 'Type: $token_type, Literal $literal';
  }
}

TokenType lookupTokenType(String literal) {
  final keywords = {
    'funcion': TokenType.FUNCTION,
    'variable': TokenType.LET,
    'si': TokenType.IF,
    'si_no': TokenType.ELSE,
    'regresa': TokenType.RETURN,
    'verdadero': TokenType.TRUE,
    'falso': TokenType.FALSE,
  };

  return keywords[literal] ?? TokenType.IDENTIFIER;
}

