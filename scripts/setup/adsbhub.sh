#!/bin/bash
# ------------------------------------------------------------------
# www.adsbhub.org
# version: 1.06
# ------------------------------------------------------------------

ckey=""
#ckey=";h%#..xcrTH0fRf5?:iJ)rxl!7}ylTI[nxZAyrW|kV^>HPTSe?>X|8WO,VT(LSAlcR)-2YT!LsRX(;7W#5vKcGr|#^(<L5HoYgZi#h4"

# test
ckey_hyatt='k96R(6pPs,NgG{#OKp?6yr%o:q6WKPTK[tDVCE6T+~vW6~h81VNaX%a.]yp)[%^.Arym<G9T+^{kior+Y[^YEGdQ5s*7QI]_mE(ual;!V%V_Ql.jC'
ckey_cmu211='vF6u57HmHV9q>*gKn6Sc#;5=+;^kU{W(-gunVqN]Io,h]1-wQ?DS#)kIGZQkFC5-At6kkdw?k0W)2s8=Usb5EDj#bmn#bl_R'
ckey_cmu112='O-13R-(oiFP=ycT973^{C4krD<Sx3{q.O%h<axMIpJ~b:)]]Y{x1|vU5(c)RKPyzqi)u+-9Xeq])g4L_bM[BQ,r}g~,~%nE7zn6oE'
ckey_cmu213='DEO3V$E:)ykED6~H,7<}ty_h3adg]oKWn7sV1]<-;Xm?n[a$YK0#OWU-;2vdtJ~gvNHH1M%o6sM,Mab)3I%Tko=Irtv~pNX,k4eC;pu7]6j<5[KCXL${hP'
ckey_cmu209='to;77Zx$t!t=Jv;)_V7omG<M_d(hv7Aj[^Hdim!n}9?.,?lv4:gUw!rd5bQ-py1QNtZT.V5NGukMLLYYS.tQCvyHO0-l#N~h!ocDV_S'

cmd="nc -w 60 localhost 30002 | nc -w 60 data.adsbhub.org 5001"
#cmd="nc -w 60 localhost 30002 | nc -w 60 94.130.23.233 5001"
myip4="0.0.0.0"
myip6="::"
cmin=0

while true; do

    # Check connection and reconnect
    echo -n "$(date +%x\ %X) "
    check=`netstat -a | grep "adsbhub[.]org[.]5001 \|adsbhub[.]org:5001 \|data[.]adsbhub[.]org[.]5001 \|data[.]adsbhub[.]org:5001 "`
    #check=`netstat -an | grep "94[.]130[.]23[.]233[.]5001 \|94[.]130[.]23[.]233:5001 "`
    echo "$check"

    echo -n "$(date +%x\ %X) "
    if [ ${#check} -ge 10 ]
    then
      result="connected"
    else
      result="not connected"
      eval "${cmd}" &
    fi
    echo $result

    # Update IP if change
    #if [ -n "$ckey" ]
    #then
      cmin=$((cmin-1))
      if [ $cmin -le 0 ]
      then
        cmin=5
        currentip4=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://ip4.adsbhub.org/getmyip.php`
        currentip6=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://ip6.adsbhub.org/getmyip.php`

        if ( [ ${#currentip4} -ge 7 ] && [ "$currentip4" != "$myip4" ] ) || ( [ ${#currentip6} -ge 2 ] && [ "$currentip6" != "$myip6" ] )
        then
          skey=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://www.adsbhub.org/key.php`
          if [ ${#skey} -ge 33 ]
          then

            # set ckey accordingly
            if [ "${currentip4}" == "63.118.73.132" ]
            then
              ckey=${ckey_hyatt}
            elif [ "${currentip4}" == "128.237.82.211" ]
            then
                ckey=${ckey_cmu211}
            elif [ "${currentip4}" == "128.237.82.112" ]
            then
                ckey=${ckey_cmu112}
            elif [ "${currentip4}" == "128.237.82.213" ]
            then
                ckey=${ckey_cmu213}
            elif [ "${currentip4}" == "128.237.82.209" ]
            then
                ckey=${ckey_cmu209}
            fi
            echo "$(date +%x\ %X) ${currentip4} ${ckey}"

            ss=${skey: -1}
            skey=${skey::-1}
            md5=`echo -n $ckey$skey | md5sum | awk '{print $1}'`

            result=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- "https://www.adsbhub.org/updateip.php?sessid=$md5$ss&myip=$currentip4&myip6=$currentip6"`

            if [ "$result" == "$md5$ss" ]
            then
              myip4=$currentip4
              myip6=$currentip6
              echo -n "$(date +%x\ %X) Successfully update IP: ${myip4}, ${myip6},"
              echo "$result"
            fi
	  fi
	fi
      fi
    #fi

    sleep 60

done
