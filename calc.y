%{
#include <stdio.h>
#include <stdlib.h>


extern int yyparse();
extern FILE* yyin;
extern int yylex();

extern int yylineno;

#include <string.h>
#define NSYMS 20   /* maximum number of symbols */

 typedef struct symtab {
      char name[100]; 
      float value;
	 };
	 
	 
//struct symtab *symlook();

//variables
int glb=0;
int alb=0;
int printcounter=0;
struct symtab smt[50];


//functions


float findval(char c[100]);
int insertval(char c[100],float val);
int updateval(char c[100],float val);

%}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_NUM TOK_PRINTLN TOK_FLOAT TOK_OPB TOK_CLB TOK_MN TOK_OCB TOK_CCB TOK_EQ TOK_ID TOK_FLX


%union{
         int int_val;
		float fl_val;
		float fla_val;
		
		char name_x[100];
		 

	    
}




%type <name_x> TOK_ID
%type <int_val> expr TOK_NUM
%type <fl_val> mexpr TOK_FLOAT
%type <fla_val> expfind


%left TOK_SUB
%left TOK_MUL




%%
 
main :
     |  TOK_MN TOK_OPB TOK_CLB TOK_OCB stmt TOK_CCB
	 
;

	 
stmt: 

	| expr_stmt TOK_SEMICOLON stmt
;	

expr_stmt: 

		| TOK_OCB expr_stmt TOK_CCB {printf("");} 
	   
	   
	   
	   | TOK_FLX 
	   
	   | TOK_FLX TOK_ID    { printf("\n"); }
	   
	   | TOK_FLX TOK_ID TOK_EQ TOK_FLOAT
	   
	   | TOK_ID TOK_EQ TOK_FLOAT 
	   { 
				
				int t;				
				
				int i=0;
				
				if(glb==0){
				
				strcpy(smt[i].name,$1);
			    smt[i].value=$3;
				glb++;
		
			}else{ 
			
			int res;
			res= insertval($1,$3);
					
				
			}
				
				
		 }
	   
	   
	   
	   | TOK_PRINTLN TOK_ID { 
			
			float fres;
			
			fres= findval($2);
			printf("%f\n",fres);
			printcounter++;
			}
	   
	   
	   | TOK_ID TOK_EQ expfind 
	   
	      { 
			int z;
			z=updateval($1,$3);
		  }
	    
	   | TOK_ID TOK_EQ mexpr
		{ 
			
			int t;
			t=insertval($1,$3);
		
		}
	  
	   
	   
	   | mexpr
		{
			fprintf(stdout, "the value is %f\n", $1);
		}
;

expfind: 
		TOK_ID TOK_SUB mexpr {  
	      float stval;
		  stval= findval($1);
		  $$= stval-$3;

		}
		
		|TOK_ID TOK_MUL mexpr {
		  float stval;
		  stval= findval($1);
		  $$= stval*$3;
		}
		
		|mexpr TOK_SUB TOK_ID { 
		  float stval;
		  stval= findval($3);
		  $$= $1-stval;
		}
		
		|mexpr TOK_MUL TOK_ID {
		  float stval;
		  stval= findval($3);
		  $$= stval*$1;

		}
;
mexpr: 
	   mexpr TOK_SUB mexpr      	     {               $$ = $1 - $3; }
	  | TOK_SUB mexpr TOK_SUB mexpr      {                $$ = -$2 - $4;}
	  | TOK_SUB mexpr TOK_MUL mexpr      {                $$ = -$2 * $4;}
	  | TOK_SUB expr TOK_SUB mexpr	     {                $$ = -$2 - $4;}
	  | TOK_SUB mexpr TOK_SUB expr	     {                $$ = -$2 - $4;}
	  | TOK_OPB mexpr TOK_MUL TOK_SUB mexpr TOK_CLB
										 {               $$ = $2 * -$5;}
	  | TOK_OPB mexpr TOK_MUL TOK_SUB expr TOK_CLB
										 {               $$ = $2 * -$5;}
      | TOK_OPB expr TOK_MUL TOK_SUB mexpr TOK_CLB
										 {                $$ = $2 * -$5;}

	  | mexpr TOK_SUB TOK_OPB TOK_SUB mexpr TOK_CLB
										 {				  $$= $1 + $5;}
										 
	  				 
	  
	  | mexpr TOK_MUL mexpr              {              $$ = $1 * $3; }
	  | expr TOK_SUB mexpr	 	         {              $$ = $1 - $3; }
	  | expr TOK_MUL mexpr 	             {              $$ = $1 * $3; }
	  | mexpr TOK_SUB expr      	 	 {              $$ = $1 - $3; }
	  | mexpr TOK_MUL expr 	             {              $$ = $1 * $3; }
	  | TOK_FLOAT                 		 {              $$ = $1; }
;



expr: 	 
	
	expr TOK_SUB expr
	  {
		printf("a");
		$$ = $1 - $3;
	  }
	| expr TOK_MUL expr
	  { 
	    printf("b");
		$$ = $1 * $3;
	  }
	| TOK_SUB expr TOK_SUB expr
		{
		printf("c");
		$$ = -$2 - $4; 
		}
	| TOK_SUB expr TOK_MUL expr
		{
		printf("d");
		$$ = -$2 * $4;
		}
	| TOK_OPB TOK_SUB expr TOK_MUL TOK_SUB expr TOK_CLB
		{
		printf("e");
		$$ = -$3 * -$6;
		}
	| TOK_OPB expr TOK_MUL TOK_SUB expr TOK_CLB
		{
		printf("f");
		$$ = $2 * -$5;
		}	
	/*| TOK_NUM
	  { 
        printf("i");	  
		$$ = $1;
	  }*/
	| TOK_FLOAT
		{
		printf("j");	  
		$$ = $1;
		}
/*	 
	| TOK_ID TOK_EQ expr	
	{
		printf("id1");
		$$ =$1->value; 
	//	printf("sha1 : %s\n", $1 );
	 } */
	 
;


%%


int updateval(char c[100],float val){

//printf("in updateval function");

int i=0;
				for(i=0;i<=glb;i++){
				
				
				if(strcmp(smt[i].name,c)==0){
				 
				 smt[i].value=val;
				 
				return 1; 
				}
				else{
				return -1;
				}
			}	
	return 0;			

}

int insertval(char c[100], float val){

//printf("in insertval function");

int i=0;
				for(i=0;i<=glb;i++){
				
			
				if(strcmp(smt[i].name,c)!=0){
				 strcpy(smt[i].name,c);
				 smt[i].value=val;
				 glb++;
				 alb++;
				 return 1;
				}
				else{
				glb++;
				alb--;
				strcpy(smt[i+1].name,c);
				smt[i+1].value=val;
				return -1;
				}
			}	
	return 0;			

}

float findval(char c[100]){



int i=0;


				for(i=0;i<=glb;i++){
				if(strcmp(smt[i].name,c)==0){
				 
				 return smt[i].value;
				}
				else{
				
				return 0.0;
				    } 
return 0.0;
}
}

		



int yyerror(char *s)
{
	printf(" Parsing Error at Line number %d\n", yylineno);
	
	return 0;
}

int main()
{

   yyparse();
   return 0;
}



