
# Bigger UPDATE InComing SaveSystem become Athena 
Athena is new version, full re-build 
COMING SOON

# SaveSystem

independent backup system for Linux (tested on Debian GNU / Linux 8.5 (jessie))

---
### Languages used
SaveSystem uses a single language:
 - Shell (100%)

---
### version
0.1.2

Of course this backup system is open source with a [public repository] [save] on GitHub.

---
### Installation

---
#### Getting the source:
To retrieve the source, type:
```sh
$ cd ~ /
$ git clone https://github.com/RootKitDev/SaveSystem.git SaveSystem
```

---
### Use

---
#### General operation
SaveSystem currently runs on the backup server and the script is designed to be
execute at least once a day.

SaveSystem done with any order of priority, the following safeguards:
 - Monthly (Full: e.g full backup of the system)
 - Hebdomadiare (Full: e.g full backup of user / application data)
 - Weekend (the Incremental Monthly: e.g every Saturday)
 - SQL (Full BDDs: e.g every Sunday)
 - Daily (Incremental the Hebdomadiare: the default action if no other backups have not triggered)

SaveSystem integrates a system of "flags" in ```sh /path/to/my/SaveSystem/Flags ```, which allows backup management.
The Flags are by default "arranged" in ```sh /path/to/my/SaveSystem/Flags/Block ``` so that the SaveSystem not interprete the flags by" mistake ".

The list of Flags:
WARNING: Pennants PS arbitrarily priority.
 - EX-000 ( "Exceptional  Backup": execute a backup Monthly out in the condition by default (every 1st of the month))
 - PS-000 ( "No Backup" (Super "No Backup") prevents any kind of backup (without indicating that there was no backup), to let the SQL backups occur )
 - PS-001 ( "No Monthly / Exceptional  Backup" historizes logs in the "No Backup")
 - PS-002 ( "No Hebdomadiare Backup" historizes logs in the "No Backup")
 - PS-003 ( "No Backup Weekend" historizes logs in the "No Backup")
 - PS-004 ( "No daily backup" historizes logs in the "No Backup")

The automatic use of this system requires crontab (or any other task scheduler)
Here is an example of crontab rule

```sh
# Starting the backup script data (Data_Save.sh) every day at 6 am
00 6 * * * /path/to/my/SaveSystem/Data_Save.sh >> /path/to/my/SaveSystem/Logs.d/Cron.log 2> & 1
```

The current system requires a host of reception, for outsourcing backups.

---
### Git Linked
HMI (Human Machine Interface) web is under developement integrating, displaying the backup logs asked CkeckSum display and volume
The [public repository] [HMI] IHM_SaveSystem

---
### Contribution

Want to contribute? Very good !

Send me your ideas and comments by mail: <rootkit.dev@gmail.com>.

---
### Licence

MIT

** Free Software, Hell Yeah! **

---

[Save]: <https://github.com/RootKitDev/SaveSystem>
[HMI]: <https://github.com/RootKitDev/IHM_SaveSystem>
