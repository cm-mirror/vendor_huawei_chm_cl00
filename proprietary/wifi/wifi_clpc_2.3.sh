
#!/bin/sh

LOG_TAG="Wifi_clpc_mt"
LOG_NAME="${0}:"
n_check=4
n_count=5
# DTS2015091006056 chenjinchao 20150910 begin
n_channel=$1
n_power=$2
# DTS2015091006056 chenjinchao 20150910 end
logi ()
{
    /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

if [ ! -d /data/misc ]; then
    logi "the directory does not exist"
fi

while(($n_check>0))
do
    wifi_status=`getprop wifi.initialize.status`
    if [ "$wifi_status" = "running" ]; then
        logi "wifi.initialize.status is running and n_check is :$n_check"
        n_check=$(($n_check-1))
        sleep 1
    else
        n_check=0
    fi
done

#/system/bin/wlan_detect
setprop wifi.mt.status running
stop wpa_supplicant
if [ "$?" == "0" ]; then
    logi "stop wpa_supplicant success"
else
    logi "stop wpa_supplicant failed."
fi
stop p2p_supplicant
if [ "$?" == "0" ]; then
    logi "stop p2p_supplicant success"
else
    logi "stop p2p_supplicant failed."
fi
ifconfig p2p0 down

ifconfig wlan0 down
while(($n_count>0))
do
    rmmod wlan
    if [ "$?" == "0" ]; then
        logi "rmmod wlan success"
    else
        logi "rmmod wlan failed."
    fi
    insmod /system/lib/modules/wlan.ko con_mode=5
    if [ "$?" == "0" ]; then
        logi "insmod wlan success"
        n_count=0
    else
        logi "insmod wlan failed and n_count is :$n_count"
        n_count=$(($n_count-1))
        sleep 1
    fi
done
#ptt_socket_app
iwpriv wlan0 ftm 1
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 ftm 1 success"
else
    logi "iwpriv wlan0 ftm 1 failed."
fi
iwpriv wlan0 ena_chain 2
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 ena_chain 2 success"
else
    logi "iwpriv wlan0 ena_chain 2 failed."
fi

iwpriv wlan0 set_cb 0 
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 set_cb 0 success"
else
    logi "iwpriv wlan0 set_cb 0 failed."
fi

# DTS2015091006056 chenjinchao 20150910 begin
iwpriv wlan0 set_channel $n_channel
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 set_channel $n_channel success"
else
    logi "iwpriv wlan0 set_channel $n_channel failed."
fi
# DTS2015091006056 chenjinchao 20150910 end

iwpriv wlan0 pwr_cntl_mode 2
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 pwr_cntl_mode 2 success"
else
    logi "iwpriv wlan0 pwr_cntl_mode 2 failed."
fi

iwpriv wlan0 set_txrate 11B_LONG_11_MBPS
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 set_txrate 11B_LONG_11_MBPS success"
else
    logi "iwpriv wlan0 set_txrate 11B_LONG_11_MBPS failed"
fi

iwpriv wlan0 set_txpktcnt 0
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 set_txpktcnt 0 success"
else
    logi "iwpriv wlan0 set_txpktcnt 0 failed."
fi

iwpriv wlan0 set_txpktlen 1500
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 set_txpktlen 1500 success"
else
    logi "iwpriv wlan0 set_txpktlen 1500 failed."
fi

iwpriv wlan0 set_txifs 100
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 set_txifs 100 success"
else
    logi "iwpriv wlan0 set_txifs 100 failed."
fi

# DTS2015091006056 chenjinchao 20150910 begin
iwpriv wlan0 set_txpower $n_power 
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 set_txpower $n_power  success"
else
    logi "iwpriv wlan0 set_txpower $n_power  failed."
fi
# DTS2015091006056 chenjinchao 20150910 end

iwpriv wlan0 tx 1
if [ "$?" == "0" ]; then
    logi "iwpriv wlan0 tx 1  success"
else
    logi "iwpriv wlan0 tx 1  failed."
fi



