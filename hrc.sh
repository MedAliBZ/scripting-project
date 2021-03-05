#!/bin/bash

args=(w x s h) #list of arguments

#functions




#main work

if (test $# == 0); then #check if there is an argument or not
    echo "Erreur! pas d'argument"
elif [[ `expr substr $1 1 1` != "-" ]]; then #check if first argument starts with -
    echo "Erreur! l'argument doit commencer par \"-\""
else
    if [[ " ${args[@]} " =~ $(expr substr $1 2 ${#1}) ]]; then #check if the argument is inisde the arguements list
        #all the work must be done here
        echo hi
    else
        echo -e "Commande introuvable!\nEssayez hrc -h pour voir la liste des commandes"
    fi

fi
