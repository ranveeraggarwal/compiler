%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token NOT_OP ADD_OP SUB_OP MUL_OP DIV_OP LT_OP GL_OP LE_OP GE_OP EQ_OP NE_OP AND_OP OR_OP INC_OP STRING_LITERAL VOID INT FLOAT RETURN IF ELSE WHILE FOR IDENTIFIER FLOAT_CONSTANT INT_CONSTANT

%%
translation_unit: 
	  function_definition
	  {
	  	$$ = ++node;
	  	dotfile<<"\ttranslation_unit_"<<$$<<" [label=\"translation_unit\"]"<<endl;
		dotfile<<"\ttranslation_unit_"<<$$<<" -> function_definition_"<<$1<<endl;
	  }
	| translation_unit function_definition
	;

function_definition:
	  type_specifier fun_declarator compound_statement
	  {
			$$=++node;
			dotfile<<"function_definition_"<<$$<<" [label=\"function_definition\"]"<<endl;
			dotfile<<"function_definition_"<<$$<<" -> {type_specifier_"<<$1<<" fun_declarator_"<<$2<<" compound_statement_"<<$3<<"}"<<endl;
		}
	;

type_specifier:
	  VOID
	  {
	  		$$=++node;
			dotfile<<"type_specifier_"<<$$<<" [label=\"type_specifier\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"VOID\"]"<<endl;
			$1=node;
			dotfile<<"type_specifier_"<<$$<<" -> TERMINAL_"<<$1<<endl;
	  }
	| INT
	{
	  		$$=++node;
			dotfile<<"type_specifier_"<<$$<<" [label=\"type_specifier\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"INT\"]"<<endl;
			$1=node;
			dotfile<<"type_specifier_"<<$$<<" -> TERMINAL_"<<$1<<endl;
	  }
	| FLOAT
	{
	  		$$=++node;
			dotfile<<"type_specifier_"<<$$<<" [label=\"type_specifier\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"FLOAT\"]"<<endl;
			$1=node;
			dotfile<<"type_specifier_"<<$$<<" -> TERMINAL_"<<$1<<endl;
	  }
	;

fun_declarator:
	  IDENTIFIER '(' parameter_list ')'
	  {
	  	$$=++node;
			dotfile<<"fun_declarator_"<<$$<<" [label=\"fun_declarator\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"IDENTIFIER\"]"<<endl;
			$1=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"(\"]"<<endl;
			$2=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\")\"]"<<endl;
			$4=node;
			dotfile<<"fun_declarator_"<<$$<<" -> {TERMINAL_"<<$1<<" TERMINAL_"<<$2<<"  parameter_list_"<<$3<<" TERMINAL_"<<$4<<" }"<<endl;
		}
	| IDENTIFIER '(' ')'
	{
	
	  	$$=++node;
			dotfile<<"fun_declarator_"<<$$<<" [label=\"fun_declarator\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"IDENTIFIER\"]"<<endl;
			$1=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"(\"]"<<endl;
			$2=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\")\"]"<<endl;
			$3=node;
			//dotfile<<"fun_declarator_"<<$$<<" -> {TERMINAL_"<<$1<<" TERMINAL_"<<$2<<"  TERMINAL_"<<$3<<" }"<<endl;		
	}
	;

parameter_list:
	  parameter_declaration
	  {
			$$=++node;
			dotfile<<"parameter_list_"<<$$<<" [label=\"parameter_list\"]"<<endl;
			dotfile<<"parameter_list_"<<$$<<" -> parameter_declaration_"<<$1<<endl;
		}
	| parameter_list ',' parameter_declaration
	{
			$$=++node;
			dotfile<<"parameter_list_"<<$$<<" [label=\"parameter_list\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\",\"]"<<endl;
			$2=node;
			dotfile<<"parameter_list_"<<$$<<" -> {parameter_list_"<<$1<<" TERMINAL_"<<$2<<" parameter_declaration_"<<$3<<"}"<<endl;
		}
	;

parameter_declaration:
	  type_specifier declarator
	  {
			$$=++node;
			dotfile<<"parameter_declaration_"<<$$<<" [label=\"parameter_declaration\"]"<<endl;
			dotfile<<"parameter_declaration_"<<$$<<" -> {type_specifier_"<<$1<<" declarator_"<<$2<<"}"<<endl;
		}
	;

declarator:
	  IDENTIFIER
	  {
			$$=++node;
			dotfile<<"declarator_"<<$$<<" [label=\"declarator\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"IDENTIFIER\"]"<<endl;
			$1=node;
			dotfile<<"declarator_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
	| declarator '[' constant_expression ']'
	{
			$$=++node;
			dotfile<<"declarator_"<<$$<<" [label=\"declarator\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"[\"]"<<endl;
			$2=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"]\"]"<<endl;
			$4=node;
			dotfile<<"declarator_"<<$$<<" -> {declarator_"<<$1<<" TERMINAL_"<<$2<<" constant_expression_"<<$3<<" TERMINAL_"<<$4<<"}"<<endl;
		}
	;

constant_expression: 
	  INT_CONSTANT
	  {
			$$=++node;
			dotfile<<"constant_expression_"<<$$<<" [label=\"constant_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"INT_CONSTANT\"]"<<endl;
			$1=node;
			dotfile<<"constant_expression_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
    | FLOAT_CONSTANT
    {
			$$=++node;
			dotfile<<"constant_expression_"<<$$<<" [label=\"constant_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"FLOAT_CONSTANT\"]"<<endl;
			$1=node;
			dotfile<<"constant_expression_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
    ;

compound_statement:
	  '{' '}'
	  {
			$$=++node;
			dotfile<<"compound_statement_"<<$$<<" [label=\"compound_statement\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"{\"]"<<endl;
			$1=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"}\"]"<<endl;
			$2=node;
			dotfile<<"compound_statement_"<<$$<<" -> {TERMINAL_"<<$1<<" TERMINAL_"<<$2<<"}"<<endl;
		}
	| '{' statement_list '}'
	{
			$$=++node;
			dotfile<<"compound_statement_"<<$$<<" [label=\"compound_statement\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"{\"]"<<endl;
			$1=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"}\"]"<<endl;
			$3=node;
			dotfile<<"compound_statement_"<<$$<<" -> {TERMINAL_"<<$1<<" statement_list_"<<$2<<" TERMINAL_"<<$3<<"}"<<endl;
		}
    | '{' declaration_list statement_list '}'
    {
			$$=++node;
			dotfile<<"compound_statement_"<<$$<<" [label=\"compound_statement\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"{\"]"<<endl;
			$1=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"}\"]"<<endl;
			$4=node;
			dotfile<<"compound_statement_"<<$$<<" -> {TERMINAL_"<<$1<<" declaration_list_"<<$2<<" statement_list_"<<$3<<" TERMINAL_"<<$4<<"}"<<endl;
		}
	;

statement_list:
	  statement
	  {
			$$=++node;
			dotfile<<"statement_list_"<<$$<<" [label=\"statement_list\"]"<<endl;
			dotfile<<"statement_list_"<<$$<<" -> statement_"<<$1<<""<<endl;
		}
	| statement_list statement
	{
			$$=++node;
			dotfile<<"statement_list_"<<$$<<" [label=\"statement_list\"]"<<endl;
			dotfile<<"statement_list_"<<$$<<" -> {statement_list_"<<$1<<" statement_"<<$2<<"}"<<endl;
		}
	;

statement: 
	  compound_statement
	  {
			$$=++node;
			dotfile<<"statement_"<<$$<<" [label=\"statement\"]"<<endl;
			dotfile<<"statement_"<<$$<<" -> compound_statement_"<<$1<<""<<endl;
		}
	| selection_statement
	{
			$$=++node;
			dotfile<<"statement_"<<$$<<" [label=\"statement\"]"<<endl;
			dotfile<<"statement_"<<$$<<" -> selection_statement_"<<$1<<""<<endl;
		}
	| iteration_statement
	{
			$$=++node;
			dotfile<<"statement_"<<$$<<" [label=\"statement\"]"<<endl;
			dotfile<<"statement_"<<$$<<" -> iteration_statement_"<<$1<<""<<endl;
		}
	| assignment_statement
	{
			$$=++node;
			dotfile<<"statement_"<<$$<<" [label=\"statement\"]"<<endl;
			dotfile<<"statement_"<<$$<<" -> assignment_statement_"<<$1<<""<<endl;
		}
    | RETURN expression ';'
    {
			$$=++node;
			dotfile<<"statement_"<<$$<<" [label=\"statement\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"RETURN\"]"<<endl;
			$1=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\";\"]"<<endl;
			$3=node;
			dotfile<<"statement_"<<$$<<" -> {TERMINAL_"<<$1<<" expression_"<<$2<<" TERMINAL_"<<$3<<"}"<<endl;
		}
	;

assignment_statement:
	  ';'
	  {
			$$=++node;
			dotfile<<"assignment_statement_"<<$$<<" [label=\"assignment_statement\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\";\"]"<<endl;
			$1=node;
			dotfile<<"assignment_statement_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
	| l_expression '=' expression ';'
	{
			$$=++node;
			dotfile<<"assignment_statement_"<<$$<<" [label=\"assignment_statement\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"=\"]"<<endl;
			$2=node;
			dotfile<<"TERMINAL_"<<++node<<" [label=\";\"]"<<endl;
			$4=node;
			dotfile<<"assignment_statement_"<<$$<<" -> {l_expression_"<<$1<<" TERMINAL_"<<$2<<" expression_"<<$3<<" TERMINAL_"<<$4<<" }"<<endl;
		}
	;

expression:
	  logical_and_expression
	  {
			$$=++node;
			dotfile<<"expression_"<<$$<<" [label=\"expression\"]"<<endl;
			dotfile<<"expression_"<<$$<<" -> logical_and_expression_"<<$1<<""<<endl;
		}
	| expression OR_OP logical_and_expression
	{
			$$=++node;
			dotfile<<"expression_"<<$$<<" [label=\"expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"OR_OP\"]"<<endl;
			$2=node;
			dotfile<<"expression_"<<$$<<" -> {expression_"<<$1<<" TERMINAL_"<<$2<<" logical_and_expression_"<<$3<<"}"<<endl;
		}

	;

logical_and_expression:
	  equality_expression
	  {
			$$=++node;
			dotfile<<"logical_and_expression_"<<$$<<" [label=\"logical_and_expression\"]"<<endl;
			dotfile<<"logical_and_expression_"<<$$<<" -> equality_expression_"<<$1<<""<<endl;
		}
	| logical_and_expression AND_OP equality_expression
	{
			$$=++node;
			dotfile<<"logical_and_expression_"<<$$<<" [label=\"logical_and_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"AND_OP\"]"<<endl;
			$2=node;
			dotfile<<"logical_and_expression_"<<$$<<" -> {logical_and_expression_"<<$1<<" TERMINAL_"<<$2<<" equality_expression_"<<$2<<"}"<<endl;
		}
	;

equality_expression:
	  relational_expression
	  {
			$$=++node;
			dotfile<<"equality_expression_"<<$$<<" [label=\"equality_expression\"]"<<endl;
			dotfile<<"equality_expression_"<<$$<<" -> relational_expression_"<<$1<<""<<endl;
		}
	| equality_expression EQ_OP relational_expression
	{
			$$=++node;
			dotfile<<"equality_expression_"<<$$<<" [label=\"equality_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"EQ_OP\"]"<<endl;
			$2=node;
			dotfile<<"equality_expression_"<<$$<<" -> {equality_expression_"<<$1<<" TERMINAL_"<<$2<<" relational_expression_"<<$3<<"}"<<endl;
		}
	| equality_expression NE_OP relational_expression
	{
			$$=++node;
			dotfile<<"equality_expression_"<<$$<<" [label=\"equality_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"NE_OP\"]"<<endl;
			$2=node;
			dotfile<<"equality_expression_"<<$$<<" -> {equality_expression_"<<$1<<" TERMINAL_"<<$2<<" relational_expression_"<<$3<<"}"<<endl;
		}
	;
relational_expression:
	  additive_expression
	  {
			$$=++node;
			dotfile<<"relational_expression_"<<$$<<" [label=\"relational_expression\"]"<<endl;
			dotfile<<"relational_expression_"<<$$<<" -> additive_expression_"<<$1<<""<<endl;
		}
	| relational_expression '<' additive_expression
	{
			$$=++node;
			dotfile<<"relational_expression_"<<$$<<" [label=\"relational_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"<\"]"<<endl;
			$2=node;
			dotfile<<"relational_expression_"<<$$<<" -> {relational_expression_"<<$1<<" TERMINAL_"<<$2<<" additive_expression_"<<$3<<"}"<<endl;
		}
	| relational_expression '>' additive_expression
	{
			$$=++node;
			dotfile<<"relational_expression_"<<$$<<" [label=\"relational_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\">\"]"<<endl;
			$2=node;
			dotfile<<"relational_expression_"<<$$<<" -> {relational_expression_"<<$1<<" TERMINAL_"<<$2<<" additive_expression_"<<$3<<"}"<<endl;
		}
	| relational_expression LE_OP additive_expression
	{
			$$=++node;
			dotfile<<"relational_expression_"<<$$<<" [label=\"relational_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"LE_OP\"]"<<endl;
			$2=node;
			dotfile<<"relational_expression_"<<$$<<" -> {relational_expression_"<<$1<<" TERMINAL_"<<$2<<" additive_expression_"<<$3<<"}"<<endl;
		}
	| relational_expression GE_OP additive_expression
	{
			$$=++node;
			dotfile<<"relational_expression_"<<$$<<" [label=\"relational_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"GE_OP\"]"<<endl;
			$2=node;
			dotfile<<"relational_expression_"<<$$<<" -> {relational_expression_"<<$1<<" TERMINAL_"<<$2<<" additive_expression_"<<$3<<"}"<<endl;
		}
	;

additive_expression:
	  multiplicative_expression
	  {
			$$=++node;
			dotfile<<"additive_expression_"<<$$<<" [label=\"additive_expression\"]"<<endl;
			dotfile<<"additive_expression_"<<$$<<" -> multiplicative_expression_"<<$1<<""<<endl;
		}
	| additive_expression '+' multiplicative_expression
	{
			$$=++node;
			dotfile<<"additive_expression_"<<$$<<" [label=\"additive_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"+\"]"<<endl;
			$2=node;
			dotfile<<"additive_expression_"<<$$<<" -> {additive_expression_"<<$1<<" TERMINAL_"<<$2<<" multiplicative_expression_"<<$3<<"}"<<endl;
		}
	| additive_expression '-' multiplicative_expression
	{
			$$=++node;
			dotfile<<"additive_expression_"<<$$<<" [label=\"additive_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"-\"]"<<endl;
			$2=node;
			dotfile<<"additive_expression_"<<$$<<" -> {additive_expression_"<<$1<<" TERMINAL_"<<$2<<" multiplicative_expression_"<<$3<<"}"<<endl;
		}
	;

multiplicative_expression:
	  unary_expression
	  {
			$$=++node;
			dotfile<<"multiplicative_expression_"<<$$<<" [label=\"multiplicative_expression\"]"<<endl;
			dotfile<<"multiplicative_expression_"<<$$<<" -> unary_expression_"<<$1<<""<<endl;
		}
	| multiplicative_expression '*' unary_expression
	{
			$$=++node;
			dotfile<<"multiplicative_expression_"<<$$<<" [label=\"multiplicative_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"*\"]"<<endl;
			$2=node;
			dotfile<<"multiplicative_expression_"<<$$<<" -> {multiplicative_expression_"<<$1<<" TERMINAL_"<<$2<<" unary_expression_"<<$3<<"}"<<endl;
		}
	| multiplicative_expression '/' unary_expression
	{
			$$=++node;
			dotfile<<"multiplicative_expression_"<<$$<<" [label=\"multiplicative_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<++node<<" [label=\"/\"]"<<endl;
			$2=node;
			dotfile<<"multiplicative_expression_"<<$$<<" -> {multiplicative_expression_"<<$1<<" TERMINAL_"<<$2<<" unary_expression_"<<$3<<"}"<<endl;
		}
	;
unary_expression:
	  postfix_expression
	  {
			$$=++node;
			dotfile<<"unary_expression_"<<$$<<" [label=\"unary_expression\"]"<<endl;
			dotfile<<"unary_expression_"<<$$<<" -> postfix_expression_"<<$1<<""<<endl;
		}
	| unary_operator postfix_expression
	{
			$$=++node;
			dotfile<<"unary_expression_"<<$$<<" [label=\"unary_expression\"]"<<endl;
			dotfile<<"unary_expression_"<<$$<<" -> {unary_operator_"<<$1<<" postfix_expression_"<<$2<<"}"<<endl;
		}
	;

postfix_expression:
	  primary_expression
	  {
			$$=++node;
			dotfile<<"postfix_expression_"<<$$<<" [label=\"postfix_expression\"]"<<endl;
			dotfile<<"postfix_expression_"<<$$<<" -> primary_expression_"<<$1<<""<<endl;
		}
	| IDENTIFIER '(' ')'
	{
			$$=++node;
			$1=++node;
			$2=++node;
			$3=++node;
			dotfile<<"postfix_expression_"<<$$<<" [label=\"postfix_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<$1<<" [label=\"IDENTIFIER\"]"<<endl;
			dotfile<<"TERMINAL_"<<$2<<" [label=\"(\"]"<<endl;
			dotfile<<"TERMINAL_"<<$3<<" [label=\")\"]"<<endl;
			dotfile<<"postfix_expression_"<<$$<<" -> {TERMINAL_"<<$1<<" TERMINAL_"<<$2<<" TERMINAL_"<<$3<<"}"<<endl;
		}
	| IDENTIFIER '(' expression_list ')'
	{
			$$=++node;
			$1=++node;
			$2=++node;
			$4=++node;
			dotfile<<"postfix_expression_"<<$$<<" [label=\"postfix_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<$1<<" [label=\"IDENTIFIER\"]"<<endl;
			dotfile<<"TERMINAL_"<<$2<<" [label=\"(\"]"<<endl;
			dotfile<<"TERMINAL_"<<$4<<" [label=\")\"]"<<endl;
			dotfile<<"postfix_expression_"<<$$<<" -> {TERMINAL_"<<$1<<" TERMINAL_"<<$2<<" expression_list_"<<$3<<" TERMINAL_"<<$4<<"}"<<endl;
		}
	| l_expression INC_OP
	{
			$$=++node;
			dotfile<<"postfix_expression_"<<$$<<" [label=\"postfix_expression\"]"<<endl;
			$2=++node;
			dotfile<<"TERMINAL_"<<$2<<" [label=\"INC_OP\"]"<<endl;
			dotfile<<"postfix_expression_"<<$$<<" -> {l_expression_"<<$1<<" TERMINAL_"<<$2<<"}"<<endl;
		}
	;

primary_expression:
	  l_expression
	  {
			$$=++node;
			dotfile<<"primary_expression_"<<$$<<" [label=\"primary_expression\"]"<<endl;
			dotfile<<"primary_expression_"<<$$<<" -> l_expression_"<<$1<<""<<endl;
		}
	| INT_CONSTANT
	{
			$$=++node;
			$1=++node;
			dotfile<<"primary_expression_"<<$$<<" [label=\"primary_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<$1<<" [label=\"INT_CONSTANT\"]"<<endl;
			dotfile<<"primary_expression_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
	| FLOAT_CONSTANT
	{
			$$=++node;
			$1=++node;
			dotfile<<"TERMINAL_"<<$1<<" [label=\"FLOAT_CONSTANT\"]"<<endl;
			dotfile<<"primary_expression_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
    | STRING_LITERAL
    {
			$$=++node;
			$1=++node;
			dotfile<<"TERMINAL_"<<$1<<" [label=\"STRING_LITERAL\"]"<<endl;
			dotfile<<"primary_expression_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
	| '(' expression ')'
	{
			$$=++node;
			$1=++node;
			$3=++node;
			dotfile<<"TERMINAL_"<<$1<<" [label=\"(\"]"<<endl;
			dotfile<<"TERMINAL_"<<$3<<" [label=\")\"]"<<endl;
			dotfile<<"primary_expression_"<<$$<<" -> { TERMINAL_"<<$1<<" expression_"<<$2<<" TERMINAL_"<<$3<<" }"<<endl;
		}
	;

l_expression: 
	  IDENTIFIER
	  {
			$$=++node;
			$1=++node;
			dotfile<<"l_expression_"<<$$<<" [label=\"l_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<$1<<" [label=\"IDENTIFIER\"]"<<endl;
			dotfile<<"l_expression_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
    | l_expression '[' expression ']' 
    {
			$$=++node;
			$2=++node;
			$4=++node;
			dotfile<<"l_expression_"<<$$<<" [label=\"l_expression\"]"<<endl;
			dotfile<<"TERMINAL_"<<$2<<" [label=\"[\"]"<<endl;
			dotfile<<"TERMINAL_"<<$4<<" [label=\"]\"]"<<endl;
			dotfile<<"l_expression_"<<$$<<" { l_expression_"<<$1<<" TERMINAL_"<<$2<<" expression_"<<$3<<" TERMINAL_"<<$4<<" }-> "<<endl;
		}
    ;
expression_list: 
	  expression
	  {
			$$=++node;
			dotfile<<"expression_list_"<<$$<<" [label=\"expression_list\"]"<<endl;
			dotfile<<"expression_list_"<<$$<<" -> expression_"<<$1<<""<<endl;
		}
    | expression_list ',' expression
    {
			$$=++node;
			$2=++node;
			dotfile<<"expression_list_"<<$$<<" [label=\"expression_list\"]"<<endl;
			dotfile<<"TERMINAL_"<<$2<<" [label=\",\"]"<<endl;
			dotfile<<"expression_list_"<<$$<<" -> {expression_list_"<<$1<<" TERMINAL_"<<$2<<" expression_"<<$3<<" }"<<endl;
		}
    ;

unary_operator: 
	  '-'
	  {
		    $$=++node;
		    $1=++node;
		    dotfile<<"TERMINAL_"<<$1<<" [label=\"-\"]"<<endl;
		    dotfile<<"unary_operator_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
	| '!'
	{
		    $$=++node;
		    $1=++node;
		    dotfile<<"TERMINAL_"<<$1<<" [label=\"!\"]"<<endl;
		    dotfile<<"unary_operator_"<<$$<<" -> TERMINAL_"<<$1<<""<<endl;
		}
	;

selection_statement: 
	  IF '(' expression ')' statement ELSE statement
	  {
		    $$=++node;
		    $1=++node;
		    $2=++node;
		    $4=++node;
		    $6=++node;
		    dotfile<<"selection_statement_"<<$$<<" [label=\"selection_statement\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$1<<" [label=\"IF\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$2<<" [label=\"(\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$4<<" [label=\")\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$6<<" [label=\"ELSE\"]"<<endl;
		    
		    dotfile<<"selection_statement_"<<$$<<" -> { TERMINAL_"<<$1<<" TERMINAL_"<<$2<<" expression_"<<$3<<" TERMINAL_"<<$4<<" statement_"<<$5<<" TERMINAL_"<<$6<<" statement_"<<$7<<"}"<<endl;
	    }
	;

iteration_statement:
	  WHILE '(' expression ')' statement
	  {
		    $$=++node;
		    $1=++node;
		    $2=++node;
		    $4=++node;
		    dotfile<<"iteration_statement_"<<$$<<" [label=\"iteration_statement\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$1<<" [label=\"WHILE\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$2<<" [label=\"(\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$4<<" [label=\")\"]"<<endl;
		    
		    dotfile<<"iteration_statement_"<<$$<<" -> { TERMINAL_"<<$1<<" TERMINAL_"<<$2<<" expression_"<<$3<<" TERMINAL_"<<$4<<" statement_"<<$5<<"}"<<endl;
	    }
	| FOR '(' assignment_statement expression ';' assignment_statement ')' statement
	{
		    $$=++node;
		    $1=++node;
		    $2=++node;
		    $5=++node;
		    $7=++node;
		    dotfile<<"iteration_statement_"<<$$<<" [label=\"iteration_statement\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$1<<" [label=\"FOR\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$2<<" [label=\"(\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$5<<" [label=\";\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$7<<" [label=\")\"]"<<endl;
		    
		    dotfile<<"iteration_statement_"<<$$<<" -> { TERMINAL_"<<$1<<" TERMINAL_"<<$2
		    <<" assignment_statement_"<<$3<<" expression_"<<$4<<" TERMINAL_"<<$5
		    <<" assignment_statement_"<<$6<<" TERMINAL_"<<$7<<" statement_"<<$8<<"}"<<endl;
		}
	;

declaration_list:
	  declaration
	  {
		    $$=++node;
		    dotfile<<"declaration_list_"<<$$<<" [label=\"declaration_list\"]"<<endl;
		    
		    dotfile<<"declaration_list_"<<$$<<" -> declaration_"<<$1<<""<<endl;
	    }
	| declaration_list declaration
	{
		    $$=++node;
		    dotfile<<"declaration_list_"<<$$<<" [label=\"declaration_list\"]"<<endl;
		    
		    dotfile<<"declaration_list_"<<$$<<" -> { declaration_list_"<<$1<<" declaration_"<<$2<<"}"<<endl;
		}
	;

declaration:
	  type_specifier declarator_list';'
	  {
		    $$=++node;
		    $3=++node;
		    dotfile<<"declaration_"<<$$<<" [label=\"declarator_list\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$3<<" [label=\";\"]"<<endl;
		    
		    dotfile<<"declaration_"<<$$<<" -> { type_specifier_"<<$1<<" declarator_list_"<<$2<<" TERMINAL_"<<$3<<"}"<<endl;
	    }
	;

declarator_list:
	  declarator
	  {
		    $$=++node;
		    dotfile<<"declarator_list_"<<$$<<" [label=\"declarator_list\"]"<<endl;
		    
		    dotfile<<"declarator_list_"<<$$<<" -> declarator_"<<$1<<""<<endl;
		}
	| declarator_list ',' declarator
	{
		    $$=++node;
		    $2=++node;
		    dotfile<<"declarator_list_"<<$$<<" [label=\"declarator_list\"]"<<endl;
		    dotfile<<"TERMINAL_"<<$2<<" [label=\",\"]"<<endl;
		    
		    dotfile<<"declarator_list_"<<$$<<" -> { declarator_list_"<<$1<<" TERMINAL_"<<$2<<" declarator_"<<$3<<"}"<<endl;
	    }
	;