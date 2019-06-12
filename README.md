# Network Scan Automation using Openvas, Wapiti and Nmap

## Overview

This script focuses on creating a detailed network security report of the whole network it is assigned to search in. This 
focuses on using a open-source tool like openvas, wapiti and nmap to assess network vulnerability. However this is specifically used to run on Kali Linux which can be used to access older version of Openvas-CLI "omp" rather than "gvm-cli" which require the greenbone paid tool to access the GSA (Greenbone Security Assistant) - the GUI of Openvas. For the use of "gvm-cli" you need to install "gvm-tools" and "python-gvm" from git repositories through socket/ssh/tls connection. 

I would like to bring to your attention that openvas is results in broken installation a lot of time and gives traceback errors in your init file and python versioning errors. Proper installation of openvas through pip-env is recommended and avoid brokern installation. However openvas-check-status is not valid anymore and is not bering updated. 

Thus "omp" is recommended on Kali Linux. Read about "omp" through omp --help.

## Pre-Requisites

### Installing Openvas

To install openvas the following commands are recommended in KALI LINUX:
* sudo apt install openvas
* openvas-start
* greenbone-nvt-sync
* openvas --rebuild
* openvas --create-user="name_of_user" --new-password=pass --role=Admin
* greenbone-scapdata-sync
* greenbone-certdata-sync
* openvas-manage-certs -a
* gsad
* sudo apt install rpm
* sudo apt install nsis
* openvas-start : This gives the name of the server and port. However all services are not available on all interfaces thus     the following commands aree required.
* sed -e 's/127.0.0.1/0.0.0.0/g' greenbone-security-assistant.service openvas-manager.service openvas-scanner.service -i
* systemctl daemon-reload
* systemctl restart greenbone-security-assistant.service openvas-manager.service openvas-scanner.service
* The new GSa daemon should run on http://0.0.0.0:9392

### Understand Openvas

Greenbone is not Openas - This is the fundamental principle that has to be understood while playing with it. Greenbone is community which features a lot of categories and also supports all kinds of discussion in these areas in the greenbone community. Greenbone can be run on the following environments:
* Greenbone OS
* Kali Linux
* Other Linux Distributions

Openvas is a Vulnerability Scanner which consists of openvas-manager openvas-scanner and greenbone-security-assistant. When we start openvas these services can be used to scan network vulnerabilities. It consists of 3 parts mainly:
* Create a new target - Range of IPs to scan for in the network.
* Setting Scan configs - Type of scan (Scan Config)
* Create a new task from a target - Named/Unnamed target from this target and scan type.
* Start Scan and Provide Report - A report is created after the task is started and the scan is complete. This report is                                       available in many formats and has specific ID for the type.

Types of Scan (Scan Configs):
* Discovery - Only NVTs are used that provide the most possible information of the target system. No vulnerabilities are                   being detected.
* Host Discovery - Only NVTs are used that discover target systems. This scan only reports the list of systems discovered.
* System Discovery - Only NVTs are used that discover target systems including installed OSs and hardware in use.
* Full and Fast - This is the default and for many environments the best option to start with. This configuration is based on                   the information gathered in the prior port scan and uses almost all NVTs. Only NVTs are used that will not                   damage the target system. Plugins are optimized in the best possible way to keep the potential false                         negative rate especially low. The other configurations only provide more value only in rare cases but with                   much more required effort.
* Full and fast ultimate - This configuration expands the first configuration with NVTs that could disrupt services or                                  systems or even cause shut downs.
* Full and very deep - This configuration differs from the Full and Fast configuration in the results of the port scan not                          having an impact on the selection of the NVTs. Therefore NVTs will be used that will have to wait for                        a timeout. This scan is very slow.
* Full and very deep ultimate - This configuration adds the dangerous NVTs that could cause possible service or system                                       disruptions to the Full and very deep configuration.

### Basic OMP commands

The omp commands which ae required for basic used:
* omp --ping [checks if connection with the GSA can be established]
* omp --username *** --password *** -T [List of tasks]
* omp --username *** --password *** -g [List of scan configs]
* omp --username *** --password *** -C -c "$scan_id" --name $name_of_task --target="$target_id" [create task]
* omp --username *** --password *** --xml="<create_target> <name>"$name_of_target"</name> <hosts>"$host_IP"</hosts>             </create_target>" [Create a new task]
* omp --username subho --password zaq12wsx -S "$task_id" [Start task]
* omp -u *** -w *** -G [Check task progress]
* omp -u *** -w *** -F [Check task report formats]
* omp --username *** --password *** -R "$report_id" -f "$format_id" [Getting the report in the specified format]


* omp --username=" " --password=" " 
• OpenVAS http://www.openvas.org/
• NMAP https://nmap.org/
• Do what is necessary (post scripts, make configuration changes to the tool, use features of the
tool, etc) to allow us to meet the following requirements with the output from the tool.
• Ignore issues that we no longer want to see (because we’ve investigated or simply don’t
care about that particular issue) in future runs of the tool.
• No or limited manual steps should be involved in each run of the tool.
• Combine the data from the scanning tool with other data to form a more complete view of what
devices are on our networks. The ideal situation would be to have every IP address on each
VLAN with information as indicated below.
• IP address (NOC)
• MAC address (NOC)
• Date the IP was last seen on the network (NOC)
• Is it in DNS? (DNS lookup or some other way?)
• Is it in DHCP? (InfoBlox)
• If a windows machine, patches waiting to be installed in WSUS? (our server)
• Domain (AD and/or Ninite)
• OS version (WSUS and/or Ninite)
• OS build (Ninite)
• Ninite related updates (Ninite)
• Local IP (Ninite)
