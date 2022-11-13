# USE MODE

You can start this program on your linux OS using

python3 nagios_help.py

the program will run forever and will check the hosts every 60 secconds

the log will be stored as yyyy-mm-dd-cpu* and yyyy-mm-dd-mem* each one with all hosts in this day.

in the hosts.csv file you need to specify the os and the ip of the host:

linux,10.10.10.10
windows,11.11.11.11

be carifult to not use any other line in the file.

