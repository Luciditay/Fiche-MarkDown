#!/bin/bash

# Paramètres 
# ==> 1 argument : Si fichier .cpp crée .h
# ==> Pas d'argument en lancant le script ==> Prend tous les fichiers .cpp du dossier et crée les fichiers .h 

creerPointH_depuisFichier(){ #récupere les fonctions d'un fichier .c et crée le .h correspondant
    if [ ! -e "$1" ]
    then #Si le fichier placé en argument n'existe pas
        echo "Fichier non existant : " $1
    else #on crée le point h correspondant 
        nomFichier=`echo "$1" | cut -d \. -f 1`
        echo ${nomFichier}".h"
        echo "#ifndef "${nomFichier^^}"_H" > ${nomFichier}".h" #ifndef "FICHIER_H"
        echo -e "#define "${nomFichier^^}"_H \n" >> ${nomFichier}".h" #define "FICHIER_H"

        grep -E "{" $1 | # On prend toute les lignes avec {,
        grep -E -v -i "(^[[:space:]] | "^if" | "^while" | "^do" | "^case" | "^for" | "^struct")" | # On enlève toute les lignes commencant par des espaces/for/while....
        sed -e 's/{/;{/g' | #On remplace { par ;{
        cut -d { -f 1 >> ${nomFichier}".h" # Il ne reste que les fonctions suivi d'un point virgule (Normalement ?) : on coupe tout ce qui vient après {, { compris

        echo -e "\n#endif" >> ${nomFichier}".h"
    fi
}


if [ "$#" -eq 1 ]
then
    creerPointH_depuisFichier $1
elif [ "$#" -eq 0 ]
then
    echo "Fichiers .h crées :"
    for fich in `ls | grep ".cpp$"`
    do 
        creerPointH_depuisFichier ${fich}
    done
fi
