#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Variables globales
main_url="https://htbmachines.github.io/bundle.js"

function ctrl_c(){
    echo -e "${redColour}[!] Saliendo... ${endColour}"
    exit 1 && tput cnorm
}

trap ctrl_c INT

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Menú de ayuda.${endColour}"
    echo -e "\t${purpleColour}h)${endColour}${yellowColour} Menú de ayuda.${endColour}"
    echo -e "\t${purpleColour}u)${endColour}${yellowColour} Comprobar actualizaciones.${endColour}"
    echo -e "\t${purpleColour}m)${endColour}${yellowColour} Buscar máquina por nombre.${endColour}"
    echo -e "\t${purpleColour}i)${endColour}${yellowColour} Buscar máquina por IP.${endColour}"
    echo -e "\t${purpleColour}y)${endColour}${yellowColour} Buscar URL de Youtube de resolución de máquina.${endColour}"
    echo -e "\t${purpleColour}d)${endColour}${yellowColour} Filtrar máquinas por nivel de dificultad.${endColour}"
    echo -e "\t${purpleColour}o)${endColour}${yellowColour} Filtrar máquinas por sistema operativo.${endColour}"
    echo -e "\t${purpleColour}s)${endColour}${yellowColour} Filtrar máquinas por skill.${endColour}"
    echo -e "\t${purpleColour}c)${endColour}${yellowColour} Filtrar por certificaciones.${endColour}"
}

function searchMachine(){
    machineName="$1"
    machineChecker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/:/ -> /')"
    if [[ -n "$machineChecker" ]]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando propiedades de la maquina${endColour} ${blueColour}$machineName${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/:/ -> /'
    else
        echo -e "\n${redColour}[+] La máquina introducida no existe.${endColour}"
    fi
}

function searchIP(){
    ipAddress="$1"
    ipChecker="$(cat bundle.js | grep "ip: \"$ipAddress\"")"
    if [[ -n "$ipChecker" ]]; then
        machineName=$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | head -n 1 | sed 's/^ *//' | tr -d '"' | tr -d ',' | awk '{print $NF}')
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} El nombre de la máquina con IP${endColour} ${blueColour}$ipAddress${endColour} ${grayColour}es${endColour} ${purpleColour}$machineName${endColour}\n"
    else
        echo -e "\n${redColour}[+] No hay ninguna máquina que corresponda a esa IP.${endColour}"
    fi
}

function youtubeLink(){
    machineName="$1"
    machineChecker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/:/ -> /')"
    if [[ -n "$machineChecker" ]]; then
        youtubeURL=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep "youtube" | sed 's/^ *//' | tr -d '"' | tr -d ',' | awk '{print $NF}')
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} El link de Youtube para la máquina${endColour} ${blueColour}$machineName${endColour} ${grayColour}es${endColour} ${purpleColour}$youtubeURL${endColour}\n"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} ¿Deseas abrir el link? (y/n)${endColour}"
        read -p " > " answer

        if [ "$answer" == "y" ]; then
            open "$youtubeURL"
        fi
    else
        echo -e "\n${redColour}[+] La máquina introducida no existe.${endColour}"
    fi
}

function filterDifficulty(){
    difficulty="$1"
    difficultyChecker=$( cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | tr -d ',' | tr -d '"' | grep "name: ")
    if [[ -n "$difficultyChecker" ]]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Las máquinas de dificultad${endColour} ${blueColour}$difficulty${endColour} ${grayColour}son: ${endColour}\n"
        cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | tr -d ',' | tr -d '"' | grep "name: " |sed 's/^ *//' | awk '{print $2}' | sort -u | column 
    else
        echo -e "\n${redColour}[+] No existen máquinas con esa dificultad.${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Las dificultades existentes son: ${endColour}\n"
        cat bundle.js | grep "dificultad:" | awk '{print $2}' | tr -d '"' | tr -d ',' | sort -u | column
    fi
}

function filterOS(){
    os="$1"
    osChecker=$(cat bundle.js | grep "so: \"$os\"" -B 4 | tr -d ',' | tr -d '"' | grep "name: ")
    if [[ -n "$osChecker" ]]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando máquinas con sistema operativo${endColour} ${blueColour}$os${endColour}${grayColour}: ${endColour}\n"
        cat bundle.js | grep "so: \"$os\"" -B 5 | tr -d ',' | tr -d '"' | grep "name: " | awk '{print $2}' | sort -u | column
    else 
        echo -e "\n${redColour}[+] No se han encontrado máquinas con ese sistema operativo.${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los sistemas operativos existentes son:${endColour}\n"
        cat bundle.js | grep "so:" | awk '{print $2}' | tr -d ',' | tr -d '"' | sed 's/^ */\t- /' | sort -u 
    fi
}

function filterDifficultyOS(){
    difficulty="$1"
    os="$2"
    difficultyChecker=$( cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | tr -d ',' | tr -d '"' | grep "name: ")
    osChecker=$(cat bundle.js | grep "so: \"$os\"" -B 4 | tr -d ',' | tr -d '"' | grep "name: ")
    if [[ -n "$difficultyChecker" ]] && [[ -n "$osChecker" ]]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando máquinas${endColour} ${blueColour}$os${endColour} ${grayColour}de dificultad${endColour} ${purpleColour}$difficulty${endColour}${grayColour}: ${endColour}\n"
        cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | tr -d '"' | tr -d ',' | awk '{print $NF}' | sort -u | column
    else
        echo -e "\n${redColour}[+] No existen máquinas con esa configuración.${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Las dificultades existentes son:${endColour}\n"
        cat bundle.js | grep "dificultad:" | awk '{print $2}' | tr -d '"' | tr -d ',' | sed 's/^ */\t- /' | sort -u
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los sistemas operativos existentes son:${endColour}\n"
        cat bundle.js | grep "so:" | awk '{print $2}' | tr -d ',' | tr -d '"' | sed 's/^ */\t- /' | sort -u 
    fi
}

function filterSkill(){
    skill="$1"
    skillChecker=$(cat bundle.js | grep "skills:" -B 6 | grep "$skill" -w -i -B 6 | grep "name:" | tr -d ',' | tr -d '"' | awk '{print $NF}' | sort -u)
    if [[ -n "$skillChecker" ]]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando maquinas con skill${endColour} ${blueColour}$skill${endColour}${grayColour}: ${endColour}\n"
        cat bundle.js | grep "skills:" -B 6 | grep "$skill" -w -i -B 6 | grep "name:" | tr -d ',' | tr -d '"' | awk '{print $NF}' | sort -u | column
    else
        echo -e "\n${redColour}[+] No existen máquinas con esa skill.${endColour}"
    fi
}

function filterCert(){
    cert="$1"
    certChecker=$(cat bundle.js | grep "like:" -B 6 | grep "$cert" -w -i -B 6 | grep "name:" | tr -d ',' | tr -d '"' | awk '{print $NF}' | sort -u)
    if [[ -n "$certChecker" ]]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando máquinas con certificación${endColour} ${blueColour}$cert${endColour}${grayColour}: ${endColour}\n"
        cat bundle.js | grep "like:" -B 6 | grep "$cert" -w -i -B 6 | grep "name:" | tr -d ',' | tr -d '"' | awk '{print $NF}' | sort -u | column
    else
        echo -e "\n${redColour}[+] No existen máquinas con esa certificación.${endColour}"
    fi
}

function updateFiles(){
    tput civis

    if [ ! -f bundle.js ]; then
        echo -e "\n${redColour}[+] El archivo no existe.${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos...${endColour}"
        
        curl -s $main_url > bundle.js
        js-beautify bundle.js | sponge bundle.js
        
        echo -e "\n${greenColour}[+] Archivos descargados correctamente.${endColour}"
    else
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} El archivo ya existe.${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando actualizaciones pendientes...${endColour}"
        
        curl -s $main_url > bundle_temp.js
        js-beautify bundle_temp.js | sponge bundle_temp.js
        md5_original=$(md5sum bundle.js | awk '{print $1}')
        md5_temp=$(md5sum bundle_temp.js | awk '{print $1}')

        if [ "$md5_original" == "$md5_temp" ]; then
            echo -e "\n${greenColour}[+] No hay actualizaciones disponibles.${endColour}"
            rm bundle_temp.js
        else
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han detectado actualizaciones pendientes.${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalando actualizaciones...${endColour}"
            rm bundle.js && mv bundle_temp.js bundle.js
            echo -e "\n${greenColour}[+] Actualizaciones completadas correctamente.${endColour}"
        fi

    fi
    tput cnorm
}

#Indicadores
declare -i parameter_counter=0
declare -i difficulty_counter=0
declare -i os_counter=0

while getopts "m:ui:y:d:o:s:c:h" arg; do 
    case $arg in
        m) machineName=$OPTARG; let parameter_counter+=2;;
        h) ;;
        u) let parameter_counter+=1;;
        i) ipAddress=$OPTARG; let parameter_counter+=3;;
        y) machineName=$OPTARG; let parameter_counter+=4;;
        d) difficultyName=$OPTARG; difficulty_counter=1; let parameter_counter+=5;;
        o) operatingSystem=$OPTARG; os_counter=1; let parameter_counter+=6;;
        s) skillName=$OPTARG; let parameter_counter+=7;;
        c) certName=$OPTARG; let parameter_counter+=8;;
    esac
done


if [ "$parameter_counter" -eq 0 ]; then
    helpPanel
elif [ "$parameter_counter" -eq 1 ]; then
    updateFiles
elif [ "$parameter_counter" -eq 2 ]; then
    searchMachine "$machineName"
elif [ "$parameter_counter" -eq 3 ]; then
    searchIP "$ipAddress"
elif [ "$parameter_counter" -eq 4 ]; then
    youtubeLink "$machineName"
elif [ "$parameter_counter" -eq 5 ]; then
    filterDifficulty "$difficultyName"
elif [ "$parameter_counter" -eq 6 ]; then
    filterOS "$operatingSystem"
elif [ "$difficulty_counter" -eq 1 ] && [ "$os_counter" -eq 1 ]; then
    filterDifficultyOS "$difficultyName" "$operatingSystem"
elif [ "$parameter_counter" -eq 7 ]; then
    filterSkill "$skillName"
elif [ "$parameter_counter" -eq 8 ]; then
    filterCert "$certName"
else
    echo -e "\n${redColour}[+] Parámetro incorrecto.${endColour}"
fi
