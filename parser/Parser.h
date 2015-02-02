// Generated by Bisonc++ V4.05.00 on Mon, 02 Feb 2015 05:50:45 +0530

#ifndef Parser_h_included
#define Parser_h_included

// $insert baseclass
#include "Parserbase.h"
// $insert scanner.h
#include "Scanner.h"
#include <iostream>
#include <fstream>
using namespace std;


#undef Parser
class Parser: public ParserBase
{
    // $insert scannerobject
    Scanner d_scanner;
        
    public:
        int parse();
        int node;
        ofstream dotfile;
        Parser(){
            node = 0;
            dotfile.open("dotfile.gv", ios::out | ios::trunc);
            dotfile << "strict digraph G{\n\trank=same"<<endl;
            dotfile.close();
            dotfile.open("dotfile.gv", ios::out | ios::app);
        }

        ~Parser(){
            dotfile << "}"<<endl;
            dotfile.close();
        }

    private:
        void error(char const *msg);    // called on (syntax) errors
        int lex();                      // returns the next token from the
                                        // lexical scanner. 
        void print();                   // use, e.g., d_token, d_loc

    // support functions for parse():
        void executeAction(int ruleNr);
        void errorRecovery();
        int lookup(bool recovery);
        void nextToken();
        void print__();
        void exceptionHandler__(std::exception const &exc);
};


#endif
