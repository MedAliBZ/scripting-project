#!/bin/bash

#functions

function hardware() { #option -w
    lshw
}

function cpu() { #option -v
    lscpu
}

function help() { #option -help and -h
    file='/etc/help.txt'
    cat $file
}

function version() { #option -v for version
    echo -e "La version du systeme: "
    cat /etc/os-release
    echo -e "------------------------------------"
    echo -e "La version de l'application et ces auteurs: "
    echo "version 0.0.1, crée par Mhedhbi Meriam et Bouzaiene Mohamed Ali"
}

function menu() { #option -m for textual menu
    trap '' 2
    while true; do
        clear
        echo "Menu"
        echo "------------------------"
        echo "1- Afficher les caracteristiques de votre PC"
        echo "2- Afficher les caracteristiques de votre cpu"
        echo "3- Page d'aide"
        echo "4- Sauvegarder les informations les plus pertinentes (en filtrant) dans un fichier"
        echo "5- Afficher la verion et les noms des auteurs"
        echo "6- Afficher les informations les plus pertinentes dans un fichier"
        echo "7- Afficher les caracteristiques hardware sous format json"
        echo "0- Quitter"
        echo "------------------------"
        echo "Ecrire votre choix"
        read reponse
        case "$reponse" in
        0) exit ;;
        1) hardware ;;
        2) cpu ;;
        3) help ;;
        4) sauvegarder ;;
        5) version ;;
        6) oAfficherFichier ;;
        7) json ;;
        esac
        read -p "Appuyez sur la touche Entrer pour continuer" out
    done
}

function graphic() { #option -g for graphical menu
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
        7 "Afficher les caracteristiques hardware sous format json"
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
    4) sauvegarder ;;
    5) version ;;
    6) oAfficherFichier ;;
    7) json ;;
    esac

    read -p "Appuyez sur la touche Entrer pour continuer" out
    graphic
}

function oAfficherFichier() { #option -o pour afficher le contenu d'un fichier
    if [[ $# == 0 ]]; then    #if the option is called from a menu
        read -p "Ecrire le nom d'un fichier: " fichier
        oAfficherFichier $fichier
        if [[ $o == true ]]; then
            read -p "Voulez vous chercher un mot specifique dans ce dossier ? [N/y] " res
            if [[ $res == 'y' ]]; then
                read -p "Ecrire le mot à chercher: " mot
                fileF=$fichier
                finding $mot
            fi
        fi
    elif [ -f $1 ]; then #check if it's a file and exist
        cat $1
        o=true
        fileF=$OPTARG #when using -f function to save the file
    else
        o=false
        echo "Le fichier n'existe pas"
    fi

}

function finding() { #option -f to print lines with a specific word
    if [[ $o == true ]]; then
        echo "-----------------------------------------------"
        grep -i $1 $fileF
    else
        echo "L'option -f doit etre précedé par l'option -o bien fonctionel"
    fi
}

function sauvegarder() { #option -s pour sauvegrader les information de la commande lshw -short dans un fichier
    if [ $# == 0 ]; then #if the option is called from a menu
        read -p "Ecrire le nom d'un fichier: " fichier
    else
        fichier=$1
    fi
    sudo lshw -short >$fichier #short form of lshw
}

function json() { #option -j pour afficher les caracteristiques hardware sous format json
    lshw -json
}

#main work

if (test $# == 0); then #check if there is an argument or not
    echo "Erreur! pas d'argument"
else
    if [ $(expr substr $1 2 ${#1}) == help ]; then #exception for help
        help
    else
        o=false
        while getopts "wuhvmgjs:o:f:" option; do
            case $option in
            w) hardware ;;
            u) cpu ;;
            h) help ;;
            v) version ;;
            m) menu ;;
            g) graphic ;;
            s) sauvegarder $OPTARG ;; #passer l'argument
            o) oAfficherFichier $OPTARG ;;
            f) finding $OPTARG ;;
            j) json ;;
            *) echo "Commande introuvable! Essayez hrc -h pour voir la liste des commandes" ;;
            esac
        done
    fi
fi
