#!/bin/bash

args=(w u h help v)            #list of arguments
arg1=$(expr substr $1 2 ${#1}) #first argument

#functions
function help() {
    file='/etc/help.txt'
    echo -e "-w pour la commande lshw
            \n-u pour la commande lscpu
            \n-h ou –help pour afficher le help à partir d’un fichier texte
            contenant la description de l’application et ses options
            \n-g pour afficher un menu graphique
            \n-m pour afficher un menu textuel
            \n-s FICHIER pour sauvegarder les informations les plus pertinentes (en filtrant) dans un fichier passé en argument
            \n-v affiche la verion et les noms des auteurs
            \n-o FICHIER pour afficher les informations les plus pertinentes dans un fichier passé en argument
            \n-f MOT_CLE pour afficher les lignes contenant le MOT_CLE à partir d’ un fichier. Cette option doit etre utilisé avec l’option -o" >$file
    echo "visiter le fichier /etc/help.txt"
}

function version() {
    echo "version 0.0.1, crée par Mhedhbi Meriam et Bouzaiene Mohamed Ali"
}

#main work

if (test $# == 0); then #check if there is an argument or not
    echo "Erreur! pas d'argument"
elif [[ $(expr substr $1 1 1) != "-" ]]; then #check if first argument starts with -
    echo "Erreur! l'argument doit commencer par \"-\""
else
    if [[ " ${args[@]} " =~ $arg1 ]]; then #check if the argument is inisde the arguements list
        #all the work must be done here
        case $arg1 in
        w) lshw ;;
        u) lscpu ;;
        h) help ;;
        help) help ;;
        v) version ;;
        esac

    else
        echo -e "Commande introuvable!\nEssayez hrc -h pour voir la liste des commandes"
    fi

fi
