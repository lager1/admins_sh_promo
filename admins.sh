#!/bin/bash
# © LAGer

# ========================================================================================
function logs()
{
  st[0]=' Looking up server ...';
  st[1]=' -!- : Not connected to server ...';
  st[2]=' -!- : Connecting to server [147.32.30.146] port 6667 ...';
  st[3]=' -!- : Connection to server established ...';
  st[4]=' !server *** Looking up your hostname ...';
  st[5]=' !server *** Checking Ident ...';
  st[6]=' !server *** No Ident response ...';
  st[7]=' !server *** Found your hostname ...';
  st[8]=' Received disconnect from 202.108.59.119: 11: disconnected by user';
  st[9]=' Connection closed by 147.32.127.234 [preauth]';
  st[10]=' pam_unix(cron:session): session opened for user root by (uid=0)';
  st[11]=' pam_unix(cron:session): session closed for user root';
  st[12]=' /dev/hvc0: No such file or directory';
  st[13]=' Failed password for kevin from 220.226.210.52 port 33836 ssh2';
  st[14]=' Connection from UDP: [147.32.30.184]:57960->[147.32.30.146]:161';
  st[15]=' init: Id "1" respawning too fast: disabled for 5 minutes';
  st[16]=' EXT4-fs (xvda1): mounting ext2 file system using the ext4 subsystem';
  st[17]=' EXT4-fs (xvda1): mounted filesystem without journal. Opts: (null)';
  st[18]=' reverse mapping checking failed - POSSIBLE BREAK-IN ATTEMPT!';
  st[19]=' pinger[28698]: segfault at 0 ip 00007fe9beafa26a';
  st[20]=' [sched_delayed] sched: RT throttling activated';
  st[21]=' Connection from UDP: [147.32.30.184]:51729->[147.32.30.146]:161';
  st[22]=' WARNING [ssh] Ban 43.229.53.24';
  st[23]=' WARNING [ssh] Ban 220.226.210.52';
  st[24]=' Invalid user ryan from 220.226.210.52';
  st[25]=' input_userauth_request: invalid user ryan [preauth]';
  
  declare -a out
  declare -a long
  local date_len=$(date "+%d-%m-%Y %H:%M:%S" | wc -c)
  ((date_len++))    # mezera

  i=0
  box_x=0   # urcime maximalni sirku okna podle nejdelsiho logu
  for ((i = 0; i < ${#st[@]}; i++)) 
  do
    # navic pocitame velikost pridaneho datumu
    if [[ $((${#st[$i]} + $date_len)) -gt $box_x ]]
    then
      box_x=$((${#st[$i]} + $date_len))
    fi
  done

  i=0 
  box_y=8           # vyska okna, kam vypisujeme logy
  pos_x=$(((`tput cols` - box_x) / 2));  # pocatecni pozice pro vykreslovani prazdneho obdelniku
  pos_y=$(((`tput lines` - ${#ins[@]}) / 2 + 8)); # vykresleny napis + 8

  # prazdne okno
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

  win_size=$box_y

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
      last=$((++j))
      ((i++))
      
      if [[ $last -eq ${#st[@]} ]]    # zaciname znova od zacatku
      then
        #last=0 # pro vypis od zacatku
        # koncime
        return
      fi
 
      if [[ $i -eq $win_size ]]
      then
        i=0
      fi
      
    done
  done
}
# ========================================================================================
function vertical()
{
  # pozadi - vertikalni vypis
  tput cup 0 0
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
}
# ========================================================================================
function horizontal()
{
  # pozadi - horizontalni vypis
  tput cup 0 0
  i=0 
  while [[ $i -lt `tput lines` ]];   # pres vsechny radky
  do 
    j=0; 
    while [[ $j -lt `tput cols` ]]; # pres vsechny sloupce
    do 
      echo -en "\e[1;32m#\e[0m"; 
      ((j++)); 
    done; 
    ((i++)); 
    if [[ $i -eq `tput lines` ]]
    then
      break
    fi

    echo -e "\e[1;32m\e[0m"; 
    #sleep 0.05; 
  done; 
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
  
  if [[ $vert -eq 1 ]]
  then
    vertical
    vert=0
  else
    horizontal
    vert=1
  fi

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
        tput cup $((pos_y + j)) $((pos_x + i)); 
        echo -en "\e[1;32m${ins[$j]:$i:1}\n\e[0m";
        ((j++));
      done;
      #sleep 0.05;
      ((i++));
    done;
  sleep 3;
}
# ========================================================================================
function clear_scr()
{
  tput cup `tput lines` `tput cols`
  for((i = $((`tput lines`)); i >= 0; i--))
  do
    for((j = $((`tput cols` - 1)); j >= 0; j--))
    do 
      tput cup $i $j
      echo -en "\e[1;32m \e[0m"; 
    done; 
  done; 
}
# ========================================================================================

  vert=1
  tput clear
  while :
  do
    main
    logs
    sleep 10
    clear_scr
  done

