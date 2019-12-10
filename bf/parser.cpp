#include <bits/stdc++.h>

using namespace std;

int main(){
    char buffer[10000];
    int n = fread(buffer,sizeof(char),10000,stdin);
    int estado,i=0,contfwd,contrwd,continc,contdec;
    buffer[n]='\0';
    while(true){
        if(estado==0){
            if(buffer[i]=='\0')break;
            else if(buffer[i]=='.'){
                cout<<"write ";
                i++;
            }
            else if(buffer[i]==','){
                cout<<"read ";
                i++;
            }
            else if(buffer[i]=='['){
                cout<<"begin ";
                i++;
            }
            else if(buffer[i]==']'){
                cout<<"end ";
                i++;
            }
            else if(buffer[i]=='>'){
                contfwd=0;
                estado=1;
            }
            else if(buffer[i]=='<'){
                contrwd=0;
                estado=2;
            }
            else if(buffer[i]=='+'){
                continc=0;
                estado=3;
            }
            else if(buffer[i]=='-'){
                contdec=0;
                estado=4;
            }
            else{
                i++;
            }
        }
        else if(estado==1){
            if(buffer[i]=='>'){
                contfwd++;
                i++;
            }
            else{
                estado=0;
                cout<<(contfwd==1 ? "fwd ": "fwd "+to_string(contfwd)+" ");
            }
        }
        else if(estado==2){
            if(buffer[i]=='<'){
                contrwd++;
                i++;
            }
            else{
                estado=0;
                cout<<(contrwd==1 ? "rwd ": "rwd "+to_string(contrwd)+" ");
            }
        }
        else if(estado==3){
            if(buffer[i]=='+'){
                continc++;
                i++;
            }
            else{
                estado=0;
                cout<<(continc==1 ? "inc " : "inc "+to_string(continc)+" ");
            }
        }
        else if(estado==4){
            if(buffer[i]=='-'){
                contdec++;
                i++;
            }
            else{
                estado=0;
                cout<<(contdec==1 ? "dec ": "dec "+to_string(contdec)+" ");
            }
        }
    }
}