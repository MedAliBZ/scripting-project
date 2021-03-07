#!/bin/bash

args=(w u h help v m g) #list of options that needs only 1 argument
args2=(s o f)           #list of options that needs 2 arguments

#functions

function w() { #option w
    lshw
}

function u() { #option v
    lscpu
}

function help() { #option help and h
    file='/etc/help.txt'
    cat $file
}

function v() { #option v for version
    echo "version 0.0.1, crée par Mhedhbi Meriam et Bouzaiene Mohamed Ali"
}

function m() {
    trap '' 2
    while true; do
        clear
        echo "Menu"
        echo "------------------------"
        echo "1- Afficher les caracteristiques de votre PC"
        echo "2- Afficher les caracteristiques de votre cpu"
        echo "3- Page d'aide"
        echo "4- Afficher un menu graphique."
        echo "5- Sauvegarder les informations les plus pertinentes (en filtrant) dans un fichier"
        echo "6- Afficher la verion et les noms des auteurs"
        echo "7- Afficher les informations les plus pertinentes dans un fichier"
        echo "0- Quitter"
        echo "------------------------"
        echo "Ecrire votre choix"
        read reponse
        case "$reponse" in
        0) exit ;;
        1) w ;;
        2) u ;;
        3) help ;;
        6) v ;;
        esac
        read -p "Appuyez sur la touche Entrer pour continuer" out
    done
}

function g() {
    HEIGHT=200
    WIDTH=500
    CHOICE_HEIGHT=7
    TITLE="Menu"
    MENU="Choisir une option:"

    OPTIONS=(1 "Afficher les caracteristiques de votre PC"
        2 "Afficher les caracteristiques de votre cpu"
        3 "Page d'aide"
        4 "Sauvegarder les informations les plus pertinentes (en filtrant) dans un fichier"
        5 "Afficher la verion et les noms des auteurs"
        6 "Afficher les informations les plus pertinentes dans un fichier"
        0 "Quitter")

    CHOICE=$(dialog --clear \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >/dev/tty)

    clear
    case $CHOICE in
    0) exit ;;
    1) w ;;
    2) u ;;
    3) help ;;
    5) v ;;
    esac
}

#main work

if (test $# == 0); then #check if there is an argument or not
    echo "Erreur! pas d'argument"
elif [[ $(expr substr $1 1 1) != "-" ]]; then #check if first argument starts with -
    echo "Erreur! l'argument doit commencer par \"-\""
else
    arg1=$(expr substr $1 2 ${#1})         #first argument
    if [[ " ${args[@]} " =~ $arg1 ]]; then #check if the argument is inisde the first arguements list
        if [[ $# != 1 ]]; then             #check if there is more than 1 argument
            echo "Cette option prend seulement 1 argument en parametre"
        elif [[ $arg1 == h ]]; then
            help
        else
            $arg1
        fi
    elif [[ " ${args2[@]} " =~ $arg1 ]]; then #check if the argument is inisde the second arguements list
        if [[ $# != 2 ]]; then                #check if the arguments != 2
            echo "Cette option prend necessairement 2 arguments en parametre"
        fi
    else
        echo -e "Commande introuvable! Essayez hrc -h pour voir la liste des commandes"
    fi
fi
