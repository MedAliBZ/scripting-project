#!/bin/bash

#functions

function hardware() { #option w
    lshw
}

function cpu() { #option v
    lscpu
}

function help() { #option help and h
    file='/etc/help.txt'
    cat $file
}

function version() { #option v for version
    echo "version 0.0.1, crée par Mhedhbi Meriam et Bouzaiene Mohamed Ali"
}

function menu() {
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
        1) hardware ;;
        2) cpu ;;
        3) help ;;
        4) graphic ;;
        6) version ;;
        esac
        read -p "Appuyez sur la touche Entrer pour continuer" out
    done
}

function graphic() {
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
    1) hardware ;;
    2) cpu ;;
    3) help ;;
    5) version ;;
    esac
}

function oAfficherFichier() {
    if [ -f $1 ]; then
        cat $1
        o=true
        fileF=$OPTARG
    else
        o=flase
        echo "le fichier n'existe pas"
    fi
}

function finding() {
    if [[ $o == true ]]; then
        echo "-----------------------------------------------"
        grep -i $1 $fileF
    else
        echo "l'option -f doit etre précedé par l'option -o bien fonctionel"
    fi
}

#main work

if (test $# == 0); then #check if there is an argument or not
    echo "Erreur! pas d'argument"
else
    if [ $(expr substr $1 2 ${#1}) == help ]; then
        help
    else
        while getopts "wuhvmgo:f:" option; do
            case $option in
            w) hardware ;;
            u) cpu ;;
            h) help ;;
            v) version ;;
            m) menu ;;
            g) graphic ;;
            o) oAfficherFichier $OPTARG ;;
            f) finding $OPTARG ;;
            *) echo "Commande introuvable! Essayez hrc -h pour voir la liste des commandes" ;;
            esac
        done
    fi
fi
