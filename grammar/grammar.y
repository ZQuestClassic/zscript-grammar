Root <- skip Option* TopLevelStatement* eof

Class <- KEYWORD_class IDENTIFIER LBRACE Option* ClassStatement* RBRACE
Namespace <- KEYWORD_namespace ScopedIdentifier LBRACE Option* NamespaceStatement* RBRACE
Script <- AnnotationList? IDENTIFIER KEYWORD_script IDENTIFIER LBRACE Option* ScriptStatement* RBRACE

# *** Statements ***

TopLevelStatement
    <- Class
     / ConstAssert
     / Enum
     / Import
     / Function
     / Include
     / Namespace
     / Script
     / Typedef
     / UsingNamespace
     / VarListDeclStatement

ClassStatement
    <- ConstAssert
     / Enum
     / Constructor
     / Destructor
     / Function
     / Typedef
     / UsingNamespace
     / VarListDeclStatement

NamespaceStatement
    <- Class
     / ConstAssert
     / Enum
     / Function
     / Namespace
     / Script
     / Typedef
     / UsingNamespace
     / VarListDeclStatement

ScriptStatement
    <- ConstAssert
     / Enum
     / Function
     / Namespace
     / Typedef
     / UsingNamespace
     / VarListDeclStatement

Statement
    <- IfStatement
     # / LabeledStatement
     / VarListDeclStatement
     / VarDeclExprStatement
     / ConstAssert
     / SwitchStatement
     / LoopStatement
     / Block
     / Enum
     / UsingNamespace
     / KEYWORD_break BreakLabel? SEMICOLON
     / KEYWORD_continue BreakLabel? SEMICOLON
     / KEYWORD_return Expr? SEMICOLON
     / SEMICOLON

Block <- LBRACE Option* Statement* RBRACE
ConstAssert <- KEYWORD_constassert LPAREN ConstExpr COMMA STRINGLITERAL RPAREN SEMICOLON
Import <- KEYWORD_import STRINGLITERALSINGLE
Include <- POUND KEYWORD_include STRINGLITERALSINGLE
Option <- POUND KEYWORD_option IDENTIFIER IDENTIFIER
Typedef <- KEYWORD_typedef Type IDENTIFIER SEMICOLON
UsingNamespace <- KEYWORD_usingnamespace ScopedIdentifier SEMICOLON

Type <- KEYWORD_const? (IDENTIFIER / KEYWORD_auto)
Brackets <- LBRACKET RBRACKET
BracketsWithOptSize <- LBRACKET ConstExpr? RBRACKET
VarDeclProto <- IDENTIFIER BracketsWithOptSize? (EQUAL Expr)?
VarListDeclProto <- VarDeclProto (COMMA VarDeclProto)*
VarListDeclStatement <- Type Brackets? VarListDeclProto SEMICOLON


# TODO ! labels?
# LabeledStatement <- BlockLabel? (Block / LoopStatement)

# *** Conditionals ***

IfStatement <- (KEYWORD_if / KEYWORD_unless) LPAREN IfInner RPAREN Statement ( KEYWORD_else Statement )?
IfInner <- (Type Brackets? IDENTIFIER EQUAL Expr) / Expr

# *** Switch ***

SwitchStatement <- KEYWORD_switch LPAREN Expr RPAREN LBRACE SwitchCase* RBRACE

SwitchCaseValue <- ConstExpr (DOT3 ConstExpr)?
SwitchCase <- (KEYWORD_case SwitchCaseValue / KEYWORD_default) COLON Statement*
# StatementsMaybeInBlock <- Block / Statement+

# *** Loops ***

LoopStatement <- ForStatement / WhileStatement / UntilStatement / DoStatement / RepeatStatement

ForPrefix_c <- KEYWORD_for LPAREN Statement Expr SEMICOLON (AssignExpr COMMA)* AssignExpr? RPAREN
ForPrefix_iterator <- KEYWORD_for LPAREN IDENTIFIER COLON IDENTIFIER RPAREN
RepeatPrefix <- KEYWORD_repeat LPAREN Expr RPAREN
UntilPrefix <- KEYWORD_until LPAREN Expr RPAREN
WhilePrefix <- KEYWORD_while LPAREN Expr RPAREN

LoopElseSuffix <- KEYWORD_else Statement

DoStatement <- KEYWORD_do Statement (WhilePrefix / UntilPrefix) LoopElseSuffix?
ForStatement <- (ForPrefix_c / ForPrefix_iterator) Statement LoopElseSuffix?
RepeatStatement <- RepeatPrefix Statement
UntilStatement <- UntilPrefix Statement LoopElseSuffix?
WhileStatement <- WhilePrefix Statement LoopElseSuffix?

# TODO ! loop, ranges

# An expression, assignment, or any destructure, as a statement.
VarDeclExprStatement
    <- VarListDeclProto SEMICOLON
     / Expr (AssignOp Expr / (COMMA (VarDeclProto / Expr))+ EQUAL Expr)? SEMICOLON

# *** Functions ***

Function <- FunctionProto (SEMICOLON / Block / COLON KEYWORD_default ConstExpr SEMICOLON)
FunctionProto <- Type IDENTIFIER (LARROW ScopedIdentifier RARROW)? LPAREN ParamDeclList RPAREN
ScopedIdentifier <- (doc_comment? IDENTIFIER COMMA)* (doc_comment? IDENTIFIER)?
ParamDeclList <- (ParamDecl COMMA)* ParamDecl? (DOT3 Type LBRACKET RBRACKET IDENTIFIER)?
ParamDecl <- doc_comment? Type Brackets? VarDeclProto

# *** Classes ***

Constructor <- IDENTIFIER LPAREN ParamDeclList RPAREN Block
Destructor <- TILDE IDENTIFIER LPAREN ParamDeclList RPAREN Block

# *** Enums ***

Enum <- KEYWORD_enum IDENTIFIER? LBRACE EnumMember? (COMMA EnumMember)* RBRACE SEMICOLON
EnumMember <- IDENTIFIER (EQUAL ConstExpr)?

# *** Expressions ***

Expr <- BoolOrExpr
ConstExpr <- Expr

BoolOrExpr <- BoolAndExpr (PIPE2 BoolAndExpr)*

BoolAndExpr <- CompareExpr (AMPERSAND2 CompareExpr)*

CompareExpr <- BitwiseExpr (CompareOp BitwiseExpr)?

BitwiseExpr <- BitShiftExpr (BitwiseOp BitShiftExpr)*

BitShiftExpr <- AdditionExpr (BitShiftOp AdditionExpr)*

AdditionExpr <- MultiplyExpr (AdditionOp MultiplyExpr)*

MultiplyExpr <- PrefixExpr (MultiplyOp PrefixExpr)*

PrefixExpr <- PrefixOp* PrimaryExpr

PrimaryExpr
    <- TypeCastExpr
     / CurlySuffixExpr (TernaryExpr / SingleAssignExpr)?

TypeCastExpr <- LARROW Type RARROW Expr
TernaryExpr <- QUESTIONMARK Expr COLON Expr
SingleAssignExpr <- AssignOp Expr
AssignExpr <- Expr (SingleAssignExpr / (COMMA Expr)+ EQUAL Expr)?

# TODO ! rename
CurlySuffixExpr <- SuffixExpr / InitList / KEYWORD_new IDENTIFIER FnCallArguments

InitList
    <- LBRACE Expr (COMMA Expr)* RBRACE
     / LBRACE RBRACE

SuffixExpr
    <- PrimaryTypeExpr (SuffixOp / FnCallArguments)*

PrimaryTypeExpr
    <- CHAR_LITERAL
     / GroupedExpr
     / IDENTIFIER
     / NUMBER
     / STRINGLITERAL

GroupedExpr <- LPAREN Expr RPAREN

# *** Other ***

ScopedIdentifier <- IDENTIFIER (COLON2 IDENTIFIER)*

BreakLabel <- COLON IDENTIFIER
BlockLabel <- IDENTIFIER COLON

Annotation <- "@" IDENTIFIER LPAREN (NUMBER / STRINGLITERAL) RPAREN
AnnotationList <- Annotation (COMMA Annotation)*

# *** Operations ***

# Operators
AssignOp
    <- ASTERISKEQUAL
     / SLASHEQUAL
     / PERCENTEQUAL
     / PLUSEQUAL
     / TILDEEQUAL
     / MINUSEQUAL
     / LARROW2EQUAL
     / RARROW2EQUAL
     / AMPERSANDEQUAL
     / CARETEQUAL
     / PIPEEQUAL
     / EQUAL

CompareOp
    <- EQUAL2
     / BANGEQUAL
     / LARROW
     / RARROW
     / LARROWEQUAL
     / RARROWEQUAL
     / CARET2

BitwiseOp
    <- AMPERSAND
     / CARET
     / PIPE

BitShiftOp
    <- LARROW2
     / RARROW2

AdditionOp
    <- PLUS
     / MINUS

MultiplyOp
    <- ASTERISK
     / SLASH
     / PERCENT

PrefixOp
    <- BANG
     / MINUS
     / TILDE
     / PLUS2
     / MINUS2

SuffixOp
    <- LBRACKET Expr RBRACKET
     / MINUSRARROW IDENTIFIER
     / COLON2 IDENTIFIER
     / "." IDENTIFIER
     / PLUS2
     / MINUS2

FnCallArguments <- LPAREN ExprList RPAREN

ExprList <- (Expr COMMA)* Expr?

# *** Tokens ***
eof <- !.
bin <- [01]
bin_ <- '_'? bin
oct <- [0-7]
oct_ <- '_'? oct
hex <- [0-9a-fA-F]
hex_ <- '_'? hex
dec <- [0-9]
dec_ <- '_'? dec

bin_int <- bin bin_*
oct_int <- oct oct_*
dec_int <- dec dec_*
hex_int <- hex hex_*

ox80_oxBF <- [\200-\277]
oxF4 <- '\364'
ox80_ox8F <- [\200-\217]
oxF1_oxF3 <- [\361-\363]
oxF0 <- '\360'
ox90_0xBF <- [\220-\277]
oxEE_oxEF <- [\356-\357]
oxED <- '\355'
ox80_ox9F <- [\200-\237]
oxE1_oxEC <- [\341-\354]
oxE0 <- '\340'
oxA0_oxBF <- [\240-\277]
oxC2_oxDF <- [\302-\337]

# From https://lemire.me/blog/2018/05/09/how-quickly-can-you-check-that-a-string-is-valid-unicode-utf-8/
# First Byte      Second Byte     Third Byte      Fourth Byte
# [0x00,0x7F]
# [0xC2,0xDF]     [0x80,0xBF]
#    0xE0         [0xA0,0xBF]     [0x80,0xBF]
# [0xE1,0xEC]     [0x80,0xBF]     [0x80,0xBF]
#    0xED         [0x80,0x9F]     [0x80,0xBF]
# [0xEE,0xEF]     [0x80,0xBF]     [0x80,0xBF]
#    0xF0         [0x90,0xBF]     [0x80,0xBF]     [0x80,0xBF]
# [0xF1,0xF3]     [0x80,0xBF]     [0x80,0xBF]     [0x80,0xBF]
#    0xF4         [0x80,0x8F]     [0x80,0xBF]     [0x80,0xBF]

mb_utf8_literal <-
       oxF4      ox80_ox8F ox80_oxBF ox80_oxBF
     / oxF1_oxF3 ox80_oxBF ox80_oxBF ox80_oxBF
     / oxF0      ox90_0xBF ox80_oxBF ox80_oxBF
     / oxEE_oxEF ox80_oxBF ox80_oxBF
     / oxED      ox80_ox9F ox80_oxBF
     / oxE1_oxEC ox80_oxBF ox80_oxBF
     / oxE0      oxA0_oxBF ox80_oxBF
     / oxC2_oxDF ox80_oxBF

ascii_char_not_nl_slash_squote <- [\000-\011\013-\046\050-\133\135-\177]

char_escape
    <- "\\x" hex hex
     / "\\u{" hex+ "}"
     / "\\" [nr\\t'"]
char_char
    <- mb_utf8_literal
     / char_escape
     / ascii_char_not_nl_slash_squote

string_char
    <- char_escape
     / [^\\"\n]

# TODO !
doc_comment <- skip
line_comment <- '//' [^\n]*
block_comment <- '/*' (!'*/' .)* '*/'
skip <- ([ \r\n\t] / line_comment / block_comment)*

CHAR_LITERAL <- "'" char_char "'" skip
FLOAT
    <- "0x" hex_int "." hex_int skip
     /      dec_int? "." dec_int skip
INTEGER
    <- "0b" bin_int 'L'? skip
     / "0o" oct_int 'L'? skip
     / "0x" hex_int 'L'? skip
     /      bin_int 'b' 'L'? skip
     /      oct_int 'o' 'L'? skip
     /      bin_int 'L'? 'b' skip
     /      oct_int 'L'? 'o' skip
     /      dec_int 'L'? skip
NUMBER <- FLOAT / INTEGER
STRINGLITERALSINGLE <- "\"" string_char* "\"" skip
STRINGLITERAL <- STRINGLITERALSINGLE+
IDENTIFIER <- !keyword [A-Za-z_] [A-Za-z0-9_]* skip


AMPERSAND            <- '&'      ![=&]     skip
AMPERSAND2           <- '&&'               skip
AMPERSANDEQUAL       <- '&='               skip
ASTERISK             <- '*'      ![=]      skip
ASTERISKEQUAL        <- '*='               skip
BANG                 <- '!'      ![=]      skip
BANGEQUAL            <- '!='               skip
CARET                <- '^'      ![=^]     skip
CARET2               <- '^^'               skip
CARETEQUAL           <- '^='               skip
COLON                <- ':'      ![:]      skip
COLON2               <- '::'               skip
COMMA                <- ','                skip
DOT2                 <- '..'     ![.]      skip
DOT3                 <- '...'              skip
EQUAL                <- '='      ![=]      skip
EQUAL2               <- '=='               skip
LARROW               <- '<'      ![<=]     skip
LARROW2              <- '<<'     ![=]      skip
LARROW2EQUAL         <- '<<='              skip
LARROWEQUAL          <- '<='               skip
LBRACE               <- '{'                skip
LBRACKET             <- '['                skip
LPAREN               <- '('                skip
MINUS                <- '-'      ![-=>]    skip
MINUS2               <- '--'               skip
MINUSEQUAL           <- '-='               skip
MINUSRARROW          <- '->'               skip
PERCENT              <- '%'      ![=]      skip
PERCENTEQUAL         <- '%='               skip
PIPE                 <- '|'      ![|=]     skip
PIPE2                <- '||'               skip
PIPEEQUAL            <- '|='               skip
PLUS                 <- '+'      ![+=]     skip
PLUS2                <- '++'               skip
PLUSEQUAL            <- '+='               skip
POUND                <- '#'                skip
QUESTIONMARK         <- '?'                skip
RARROW               <- '>'      ![>=]     skip
RARROW2              <- '>>'     ![=]      skip
RARROW2EQUAL         <- '>>='              skip
RARROWEQUAL          <- '>='               skip
RBRACE               <- '}'                skip
RBRACKET             <- ']'                skip
RPAREN               <- ')'                skip
SEMICOLON            <- ';'                skip
SLASH                <- '/'      ![=]      skip
SLASHEQUAL           <- '/='               skip
TILDE                <- '~'      ![=]      skip
TILDEEQUAL           <- '~='               skip

end_of_word <- ![a-zA-Z0-9_] skip
KEYWORD_auto        <- 'auto'        end_of_word
KEYWORD_break       <- 'break'       end_of_word
KEYWORD_case        <- 'case'        end_of_word
KEYWORD_catch       <- 'catch'       end_of_word
KEYWORD_class       <- 'class'       end_of_word
KEYWORD_const       <- 'const'       end_of_word
KEYWORD_constassert <- 'CONST_ASSERT'end_of_word
KEYWORD_continue    <- 'continue'    end_of_word
KEYWORD_default     <- 'default'     end_of_word
KEYWORD_do          <- 'do'          end_of_word
KEYWORD_else        <- 'else'        end_of_word
KEYWORD_enum        <- 'enum'        end_of_word
KEYWORD_export      <- 'export'      end_of_word
KEYWORD_for         <- 'for'         end_of_word
KEYWORD_if          <- 'if'          end_of_word
KEYWORD_import      <- 'import'      end_of_word
KEYWORD_include     <- 'include'     end_of_word
KEYWORD_inline      <- 'inline'      end_of_word
KEYWORD_loop        <- 'loop'        end_of_word
KEYWORD_namespace   <- 'namespace'   end_of_word
KEYWORD_new         <- 'new'         end_of_word
KEYWORD_option      <- 'option'      end_of_word
KEYWORD_repeat      <- 'repeat'      end_of_word
KEYWORD_return      <- 'return'      end_of_word
KEYWORD_script      <- 'script'      end_of_word
KEYWORD_switch      <- 'switch'      end_of_word
KEYWORD_try         <- 'try'         end_of_word
KEYWORD_typedef     <- 'typedef'     end_of_word
KEYWORD_unless      <- 'unless'      end_of_word
KEYWORD_until       <- 'until'       end_of_word
KEYWORD_usingnamespace <- 'using namespace' end_of_word
KEYWORD_var         <- 'var'         end_of_word
KEYWORD_while       <- 'while'       end_of_word

keyword
    <- KEYWORD_auto
     / KEYWORD_break
     / KEYWORD_case
     / KEYWORD_catch
     / KEYWORD_class
     / KEYWORD_const
     / KEYWORD_constassert
     / KEYWORD_continue
     / KEYWORD_default
     / KEYWORD_do
     / KEYWORD_else
     / KEYWORD_enum
     / KEYWORD_export
     / KEYWORD_for
     / KEYWORD_if
     / KEYWORD_import
     / KEYWORD_include
     / KEYWORD_inline
     / KEYWORD_loop
     / KEYWORD_namespace
     / KEYWORD_new
     / KEYWORD_option
     / KEYWORD_repeat
     / KEYWORD_return
     / KEYWORD_script
     / KEYWORD_switch
     / KEYWORD_try
     / KEYWORD_typedef
     / KEYWORD_unless
     / KEYWORD_until
     / KEYWORD_usingnamespace
     / KEYWORD_var
     / KEYWORD_while
