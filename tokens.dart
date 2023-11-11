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
  GTE,
  LTE,
  EQEQ,
  NEQ,
  DOUBLE,
  NULL,
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
    'var': TokenType.LET,
    'si': TokenType.IF,
    'si_no': TokenType.ELSE,
    'regresa': TokenType.RETURN,
    'verdadero': TokenType.TRUE,
    'falso': TokenType.FALSE,
    'let': TokenType.LET
  };

  return keywords[literal] ?? TokenType.IDENTIFIER;
}

