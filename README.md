# My Dwm Statusbar #
This is the repo of my dwm status bar script.
<img src='./.img/showoff.jpg'/>
<img src='./.img/showoff0.jpg'/>

Usage
---
Clone the repo with command below in your terminal
```
$ git clone https://github.com/Lew1s777/dwm-statusbar.git
```
Then start your [dwm](https://dwm.suckless.org/) and run
```
$ bash ./dwm-status.sh
```
To auto start at the dwm launch,patch your dwm an autostart patch and add the status bar script to your autostart script.

To avoid ```xsetroot``` command spawning too many PIDs,I use a C program and pipe statusbar content in it instead.Use the command below to compile it.
```
gcc ./src/dwm-setstatus.c -lX11 -o ./bin/dwm-setstatus -O3
```

Troublem Shooting
---

#### no emoji ####
make sure ur dwm have font ```monospace```
