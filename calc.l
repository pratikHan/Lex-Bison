/* THIS IS example to implement symbol table */

%{
#include <stdio.h>
#include "calc.tab.h"
#include <math.h>
#include <string.h>

#include <stdlib.h>
#define YYSTYPE char*


 
//extern YYSTYPE yylval;
  


#define NSYMS 20   /* maximum number of symbols */

struct symtab 
{      char *name; 
	 double value; 
	 }
	 symtab [NSYMS];
//struct symtab *symlook();

%}

digit	([0-9])
digitf ([0-9]+\.[0-9]+)
ID      ([a-z][a-z0-9]*)



%%
"print"       {       return(TOK_PRINTLN); }

"main"         {		return(TOK_MN);  }

"float"			{		return (TOK_FLX); }


{digit}+	{
			
	
		sscanf(yytext, "%d", &(yylval.int_val));
		return (TOK_NUM);
		}
		
{digitf}+   {
			yylval.fl_val = atof(yytext); return (TOK_FLOAT);
        }
		
{ID}+	     {
			
			sscanf(yytext, "%s", &(yylval.name_x));
		     return (TOK_ID);
			
			
			  
			}	

		
		
";"         {	return (TOK_SEMICOLON);} 
"-"		    {	return (TOK_SUB); }
"*"		    {	return (TOK_MUL); }
"("			{	return (TOK_OPB); } 
")"			{	return (TOK_CLB); }
"{"			{	return (TOK_OCB); }
"}"			{	return (TOK_CCB); }
"="			{	return (TOK_EQ);  }
"+"         {	printf( "Lexical Analysis error for +");}
"/"			{	printf( "Lexical Analysis error for /");}	

"\n"        {  yylineno++ ; }

[ \n\t]* 



.             { printf("Invalid character '%c', ignored\n",yytext[0]);}

%%		