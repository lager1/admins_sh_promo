#!/bin//bash
# © LAGer

# ========================================================================================
function logs()
{

  # TODO
  # logy nesmi byt delsi nez window_size -> rozdelit na vice radek
  # nebo log vypisovat na vice radek ? :D
  # pokud to bude rozdelene, tak to bude na picu -> na konci kazdeho vypsaneho radku je pauza ... 
  # navic pred kazdy novy radek je pridavano aktualni datum
  # ale odmazavani casti radku bude dost problem :D
  # pridat nejake logy

  st[0]=' Looking up server ...';
  st[1]=' -!- : Not connected to server ...';
  st[2]=' -!- : Connecting to server [147.32.30.146] port 6667 ...';
  st[3]=' -!- : Connection to server established ...';
  st[4]=' !server *** Looking up your hostname ...';
  st[5]=' !server *** Checking Ident ...';
  st[6]=' !server *** No Ident response ...';
  st[7]=' !server *** Found your hostname ...';
  st[8]=' Received disconnect from 202.108.59.119: 11: disconnected by user';
  
  declare -a out
  declare -a long

  # prazdne okno
  i=0 
  box_x=60
  box_y=6
  pos_x=$(((`tput cols` - box_x) / 2));  # pocatecni pozice pro vykreslovani prazdneho obdelniku
  pos_y=$(((`tput lines` - ${#ins[@]}) / 2 + 8)); # vykresleny napis + 8

  while [[ $i -lt $box_x ]]
    do 
      j=0
      while [[ $j -lt $box_y ]]
      do 
        tput cup $((pos_y + j)) $((pos_x + 1 + i)); 
        echo -en " ";
        ((j++));
      done;
      #sleep 0.05;
      ((i++));
    done;
  sleep 3;

  setterm -cursor on
  tput cup $pos_y $((pos_x + 1))

  # TODO
  win_size=6   # prvni parametr

  # TODO
  # vypis logu
  #while :   # nekonecny cyklus - predelat na pocet logu
  while :
  do
    i=0

    # vypis uvodnich radek
    for((j = 0; j < ${#st[@]}; j++))
    do
      k=0
      out[$j]=$(date "+%d-%m-%Y %H:%M:%S")${st[$j]}    # update logu - pridame aktualni datum
      while [[ $k -lt ${#out[$j]} ]] # pres delku radku
      do
        #if [[ $k -eq $4 ]]  #   jsme na konci okna
        #then
        #   tput cup $((j + $1 + 1 + ind)) $2   # posun na dalsi radek
        #   ((ind++))
        #   long[$i]=1   # radek $i je vypsan na dalsi radek
        #fi

        echo -en "\e[1;31m${out[$j]:$k:1}\e[0m"; 
        sleep 0.05
        ((k++))
      done
      sleep 1.5
      tput cup $((j + pos_y + 1)) $((pos_x + 1))   # posun na dalsi radek
      ((i++))

      if [[ $i -eq $win_size ]]
      then
        last=$((++j))
        break
      fi
    done

    # cyklime donekoncena a mazeme nejstarsi radek
    i=0
    while :
    do
      if [[ $last -eq ${#st[@]} ]]    # zaciname znova od zacatku
      then
        last=0
      fi

      # odmazavat vypsane radky od prvniho od zadu - prepisovat nahodnymi znaky a pak mezerami
      for((l = ${#out[(($last - $win_size))]}; l >= 0; l--))
      do
        tput cup $((pos_y + i)) $((l + pos_x + 1))
        echo -en "\e[1;31m \e[0m"; 
        sleep 0.03
      done

      tput cup $((pos_y + i))  $((pos_x + 1))
      # vypis jedineho radku
      j=$last
      k=0
      out[$j]=$(date "+%d-%m-%Y %H:%M:%S")${st[$j]}    # update logu - pridame aktualni datum
      while [[ $k -lt ${#out[$j]} ]] # pres delku radku
      do
        echo -en "\e[1;31m${out[$j]:$k:1}\e[0m"; 
        sleep 0.05
        ((k++))
      done
      sleep 1.5
      echo -e "\e[1;31m\e[0m"; 
      last=$((++j))
      ((i++))

      if [[ $i -eq $win_size ]]
      then
        i=0
      fi
      
    done
  done

  sleep 10
}

# ========================================================================================
function main()
{
  ins[0]='                                                                                      '; 
  ins[1]='  $$$$$$\        $$\               $$\                            $$$$$$\  $$\   $$\  '; 
  ins[2]=' $$  __$$\       $$ |              \__|                          $$  __$$\ $$ |  $$ | '; 
  ins[3]=' $$ /  $$ | $$$$$$$ |$$$$$$\$$$$\  $$\ $$$$$$$\   $$$$$$$\       $$ /  \__|$$ |  $$ | '; 
  ins[4]=' $$$$$$$$ |$$  __$$ |$$  _$$  _$$\ $$ |$$  __$$\ $$  _____|      \$$$$$$\  $$$$$$$$ | '; 
  ins[5]=' $$  __$$ |$$ /  $$ |$$ / $$ / $$ |$$ |$$ |  $$ |\$$$$$$\         \____$$\ $$  __$$ | '; 
  ins[6]=' $$ |  $$ |$$ |  $$ |$$ | $$ | $$ |$$ |$$ |  $$ | \____$$\       $$\   $$ |$$ |  $$ | '; 
  ins[7]=' $$ |  $$ |\$$$$$$$ |$$ | $$ | $$ |$$ |$$ |  $$ |$$$$$$$  |      \$$$$$$  |$$ |  $$ | '; 
  ins[8]=' \__|  \__| \_______|\__| \__| \__|\__|\__|  \__|\_______/        \______/ \__|  \__| '; 
  ins[9]='                                                                                      '; 
  
  # pozadi - horizontalni vypis
  #i=0 
  #tput clear; 
  #while [[ $i -lt `tput lines` ]];   # pres vsechny radky
  #do 
  #  j=0; 
  #  while [[ $j -lt `tput cols` ]]; # pres vsechny sloupce
  #  do 
  #    #tput cup $j $i; 
  #    echo -en "\e[1;32m#\e[0m"; 
  #    ((j++)); 
  #  done; 
  #    echo -e "\e[1;32m\e[0m"; 
  #  #sleep 0.05; 
  #  ((i++)); 
  #done; 

  # pozadi - vertikalni vypis
  i=0 
  tput clear; 
  while [[ $i -lt `tput cols` ]];   # pres vsechny sloupce
  do 
    j=0; 
    while [[ $j -lt `tput lines` ]]; # pres vsechny radky
    do 
      tput cup $j $i; 
      echo -en "\e[1;32m#\e[0m"; 
      ((j++)); 
    done; 
    #sleep 0.05; 
    ((i++)); 
  done; 
  
  setterm -cursor off
  # napis
  pos_x=$(((`tput cols` - ${#ins[0]}) / 2));    # stred obrazovky
  pos_y=$(((`tput lines` - ${#ins[@]}) / 2 - 8)); # stred obrazovky - 8
  i=0 
  
  while [[ $i -lt ${#ins[0]} ]]
    do 
      j=0
      while [[ $j -lt $((${#ins[@]} + 1)) ]]
      do 
        tput cup $((pos_y + j)) $((pos_x + 1 + i)); 
        echo -en "\e[1;32m${ins[$j]:$i:1}\n\e[0m";
        ((j++));
      done;
      #sleep 0.05;
      ((i++));
    done;
  sleep 3;

  ## prazdne okno
  #i=0 
  #box_x=60
  #box_y=6
  #pos_x=$(((`tput cols` - box_x) / 2));  # pocatecni pozice pro vykreslovani prazdneho obdelniku
  #pos_y=$(((`tput lines` - ${#ins[@]}) / 2 + 8)); # vykresleny napis + 8

  #while [[ $i -lt $box_x ]]
  #  do 
  #    j=0
  #    while [[ $j -lt $box_y ]]
  #    do 
  #      tput cup $((pos_y + j)) $((pos_x + 1 + i)); 
  #      echo -en " ";
  #      ((j++));
  #    done;
  #    #sleep 0.05;
  #    ((i++));
  #  done;
  #sleep 3;

  #setterm -cursor on
  # nastavime kurzor na zacatek vypisu
  #tput cup $pos_y $((pos_x + 1))
  logs
}

# ========================================================================================

# TODO

  main

