# dmenu useful sctripts

<!-- vim-markdown-toc GFM -->

* [Get information with regux in chaos](#get-information-with-regux-in-chaos)
    * [Create file](#create-file)
    * [Get url head](#get-url-head)
    * [Get url tail](#get-url-tail)
    * [-o cut](#-o-cut)
    * [Get last command output with function of bindkey](#get-last-command-output-with-function-of-bindkey)
    * [For dir regux](#for-dir-regux)
    * [Get the path in the same way](#get-the-path-in-the-same-way)
* [Search by file](#search-by-file)
* [Build a script of search engines](#build-a-script-of-search-engines)

<!-- vim-markdown-toc -->
## Get information with regux in chaos
### Create file
```bash
#my file name is lstest
12321https://www.google.com/
123123
https://www.baidu.com/312321  123123
https://top.baidu.com/312321  123123
www.123.123/12312 adfasdf
321312
/home/tz/.config/nvim
123 /home/tz/ 12312312
123 /home/tz/.config
```
### Get url head
```bash
egrep '((http|https)://|www\.)' lstest #your file name
```
![avatar](/home/tz/md/Pictures/dmenu/1.png)

### Get url tail
```bash
egrep '((http|https)://|www\.)[a-zA-Z1-9.+-/]*' lstest
```
![avatar](/home/tz/md/Pictures/dmenu/2.png)

### -o cut
```bash
egrep -o '((http|https)://|www\.)[a-zA-Z1-9.+-/]*' lstest
```
![avatar](/home/tz/md/Pictures/dmenu/3.png)

### Get last command output with function of bindkey
```bash
# add function
function searchurl {
    $(history | tail -n 1 | awk '{$1="";print $0}') | egrep -o '((http|https)://|www\.)[a-zA-Z1-9.+-/]*' | dmenu -p "search url" -l 10 | xargs xdg-open &> /dev/null
}
# zsh bindkey
zle -N searchurl
# Alt + u
bindkey "^[u" searchurl
```

![avatar](/home/tz/md/Pictures/dmenu/4.gif)

### For dir regux
```bash
dir="bin|boot|dev|etc|home|lib|lib64|lost+found|mnt|opt|proc|root|run|sbin|srv|sys|tmp|usr|var"
egrep -o "/($dir)/[a-zA-Z0-9/.]*" lstest
```
![avatar](/home/tz/md/Pictures/dmenu/5.png)

### Get the path in the same way
```bash
function cpdir {
# set dir varible
    dir="bin|boot|dev|etc|home|lib|lib64|lost+found|mnt|opt|proc|root|run|sbin|srv|sys|tmp|usr|var"
    $(history | tail -n 1 | awk '{$1="";print $0}') | egrep -o "/($dir)/[a-zA-Z0-9/.]*" | dmenu -p "copy url" -l 10 | xclip -selection clipboard
}
```
![avatar](/home/tz/md/Pictures/dmenu/6.gif)

## Search by file
**Can search**
+ `XK`
+ `Port`
+ `other any file`
```bash
# It is realized by two-layer menu.
function checkfile {
    choices="XK\nport"
    chosen=$(echo -e "$choices" | dmenu -p "输入你的查找什么") #the one-layer

    #the two-layer by case realized
    case "$chosen" in
        XK) grep '^#' /usr/include/X11/keysymdef.h | dmenu -p "XK" -l 15 | awk '{ print $2 }' | xclip -selection clipboard ;;
        port) grep -v '^#' /etc/services | dmenu -p "port" -l 15 | awk '{ print $1 }' | xclip -selection clipboard;;
    esac
}
```
![avatar](/home/tz/md/Pictures/dmenu/7.gif)

## Build a script of search engines
This is a [script link](https://github.com/ztoiax/userfulscripts/blob/master/dmenu-search.sh
 "With a Title").

![avatar](/home/tz/md/Pictures/dmenu/8.gif)
