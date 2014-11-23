%{
#include "Type.h"
#include <stdlib.h>

extern void emit(const char *, ...);
%}

%union {
    Type typeval;
    int intval;
    double floatval;
    char *strval;   
}

%token MAIN
%token RETURN
%token NEWLINE
%token ARTICLE TYPENAME STAR
%token VARDECL ASSIGN
%token PRINT INPUT
%token ASSERT_BEGIN ASSERT_END
%token LOOP_BEGIN LOOP_CONDITION
%token BRANCH_CONDITION BRANCH_BEGIN BRANCH_ELSE BRANCH_END CASE_END
%token COLON COMMA LCURL RCURL
%token FUNDECL PARAMS FUNCALL
%token ABORT
%token ID NUMBER FLOAT

%left OP_LT OP_GT OP_LTE OP_GTE
%left OP_PLUS OP_MINUS
%left OP_TIMES OP_DIV
%left OP_SHL OP_SHR

%nonassoc LOWER_THAN_ELSE
%nonassoc BRANCH_ELSE

%start program

%type<intval> NUMBER;
%type<floatval> FLOAT;
%type<strval> ID;
%type<typeval> TYPENAME;

%%

program:
    fun_decls main fun_decls
;
fun_decls:
    /* epsilon */ | fun_decls fun_decl
;
fun_decl:
    FUNDECL ID args LCURL statements RCURL NEWLINE
;
args:
    /* epsilon */ | PARAMS arglist
;
arglist:
    ID | ID COMMA arglist
;
main:
    MAIN NEWLINE statements
;
statements:
    NEWLINE | statements statement NEWLINE
;
statement:
    var_decl | assign_stmt | print_stmt | input_stmt | return_stmt | 
    loop_stmt | branch_stmt | fun_call | abort_stmt | assert_stmt | 
    /* epsilon */
;
var_decl:
    VARDECL pointer ID COMMA TYPENAME var_init
;
pointer:
    /* epsilon */ | STAR
;
var_init:
    /* epsilon */ | ASSIGN numeric
;
numeric:
    NUMBER | FLOAT
;
variable:
    ID | ARTICLE ID
;
assign_stmt:
    ID ASSIGN expression
;
print_stmt:
    expression PRINT
;
input_stmt:
    INPUT variable
;
return_stmt:
    RETURN | RETURN expression
;
loop_stmt:
    LOOP_BEGIN statements LOOP_CONDITION expression
;
branch_stmt:
    BRANCH_CONDITION variable BRANCH_BEGIN
        branch_body
    BRANCH_END
;
branch_body:
    cases %prec LOWER_THAN_ELSE |
    cases BRANCH_ELSE COLON NEWLINE statements
;
cases:
    case_stmt | case_stmt cases
;
case_stmt:
    expression COLON NEWLINE statements CASE_END
;
fun_call:
    FUNCALL ID args
;
abort_stmt:
    ABORT
;
assert_stmt:
    ASSERT_BEGIN expression ASSERT_END
;
expression:
    numeric | 
    variable |
    expression OP_LT expression |
    expression OP_GT expression |
    expression OP_LTE expression |
    expression OP_GTE expression |
    expression OP_PLUS expression |
    expression OP_MINUS expression |
    expression OP_TIMES expression |
    expression OP_DIV expression |
    expression OP_SHL expression |
    expression OP_SHR expression
;

%%
