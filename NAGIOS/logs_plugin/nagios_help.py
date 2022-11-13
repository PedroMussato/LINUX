# used libraries
import os
import csv
import time
import datetime

while True: # this program will run forever, you can make it a service on linux to help its management
    # first we will get the time
    date = str(datetime.datetime.now())
    year_month_day = date[:10]
    hour_minute = date[11:19]

    with open("hosts.csv", "r") as hosts_file: # open the hosts file 
        hosts_list = csv.reader(hosts_file)
        for host in hosts_list: # get line by line of the hosts file

            if host[0] == 'linux': # is the host is a linux os
                host_ip = host_ip[1] # get this ip
                mem = []
                # this scrp is the scrap of the memory returned by the check_nrpe and it will be mined to log on csv file
                scrp = str(os.popen(f"/usr/local/nagios/libexec/check_nrpe -H {host_ip} -c check_mem").read())
                # here we get the cpu percent 1,5 and 15 minute, this is already mined
                cpu = str(os.popen(f"/usr/local/nagios/libexec/check_nrpe -H {host_ip} -c check_load").read()).split("|")[0].split(" ")[6:]

                if "[MEMORY] Total: " in scrp and "load average per CPU" in cpu:
                    mem.append(scrp[:-1].split("|")[0].split(" ")[2]) # total host memory
                    mem.append(scrp[:-1].split("|")[0].split(" ")[6]) # total utilized host memory
                    mem.append(scrp[:-1].split("|")[0].split(" ")[9][:-1]) # percent in use

                    with open(f"var/{year_month_day}-cpu_db.csv", "a+") as db: # log on the cpu csv file
                        db.writelines(f"{hour_minute},linux,{host_ip},{cpu[0][:-1]},{cpu[1][:-1]},{cpu[2]}\n")

                    with open(f"var/{year_month_day}-mem_db.csv", "a+") as db: # log on the memory csv file
                        db.writelines(f"{hour_minute},linux,{host_ip},{mem[0]},{mem[1]},{mem[2]}\n")

            # the same will repeat to windows hosts, but with the check nt command
            elif host[0] == 'windows':
                host_ip = host[1]
                scrp = str(os.popen(f"/usr/local/nagios/libexec/check_nt -H {host_ip} -p 12489 -v CPULOAD -l 1,80,90").read())

                if "CPU Load " in scrp:
                    cpu = [
                        int(scrp.split(" ")[2][:-1])/100,
                        int(scrp.split(" ")[2][:-1])/100,
                        int(scrp.split(" ")[2][:-1])/100
                    ]

                scrp = os.popen(f"/usr/local/nagios/libexec/check_nt -H {host_ip} -p 12489 -v MEMUSE -w 85 -c 90").read()
                if "Memory usage: " in scrp:
                    mem = [
                        int(float(scrp.split("|")[0].split(" ")[2].split(":")[1])),
                        int(float(scrp.split("|")[0].split(" ")[6])),
                        int(float(scrp.split("|")[0].split(" ")[8][1:-2]))
                    ]

                    with open(f"var/{year_month_day}-cpu_db.csv", "a+") as db:
                        db.writelines(f"{hour_minute},windows,{host_ip},{cpu[0]},{cpu[1]},{cpu[2]}\n")

                    with open(f"var/{year_month_day}-mem_db.csv", "a+") as db:
                        db.writelines(f"{hour_minute},windows,{host_ip},{mem[0]},{mem[1]},{mem[2]}\n")

    time.sleep(60) # this check will occur every 60 minutes.
