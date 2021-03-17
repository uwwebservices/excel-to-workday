#Excel-to-Workday

Download WinSCP .Net Assembly from
https://winscp.net/eng/downloads.php#additional

Create a settings.txt file with the below structure. 

[FTP]
HostKeyFingerprint=ssh-rsa 2048 GcWRklZlfs0q1oNwzGuJ8oj/skf2s4yc3VSxIv6+r/c=
Server=sftp.finance.api.uw.edu
User=[yourusername]
KeyPath=[yourPPKfile]
Env=dev

[Locations]
WinSCPnet=[fullPathToWinSCPnet.dll]

