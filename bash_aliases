
#standard shortcuts
        #allows for reverse ctrl+r with ctrl+s and a whole bunch of other things
        stty -ixon

	#general terminal laziness/movement shortcuts
        alias l="clear;ls"
        alias s="clear;ls -Alh"
        alias a="clear;ls -A"
        alias k="clear;ls -lh"
        alias j="cd ..; l"
        alias lh="clear; ls -Ad .*"

        #remove screenshots from home
        alias rmsc="rm './Screenshot from'*"

	#every usage of nano is (S)mooth scrolling and can use the (m)ouse to set cursor
        alias nano="nano -Sm"

        alias vbash="vim ~/Coding/Scripts/bash_aliases; src"
        alias open="xdg-open "

	#executes contents of the file passed as arguments, in the CURRENT shell
	alias src="source ~/.bashrc && source ~/.bash_aliases && source ~/Coding/Scripts/bash_aliases"

        #runs git pull/add/commit/push in one command with the $* argument used as the commit message
        function gitc() {  
                git pull; git add --all :/; git commit -m "$*"; git push
        } #gitc

        #automatically uses clear; ls; after "cd"ing. overrides cd
	function cd() { 
	    new_directory="$*";
	    if [ $# -eq 0 ]; then
	        new_directory=${HOME};
	        builtin cd "${new_directory}" && l;
	    fi;
	    if [ $# -eq 1 ]; then
	        new_directory=$1;
	        builtin cd "${new_directory}" && l;
	    fi;
        } #cd

        #same as cd but doesn't clear text
	function cs() { 
	    new_directory="$*";
	    if [ $# -eq 0 ]; then
	        new_directory=${HOME};
	        builtin cd "${new_directory}";
	    fi;
	    if [ $# -eq 1 ]; then
	        new_directory=$1;
	        builtin cd "${new_directory}";
	    fi;
        } #cs
	
	#used to modify the cheatsheet with additional params to automatically push with gitc
	function nbash() { 
	    if [ $# -eq 0 ]; then
	        nano ~/Coding/Scripts/bash_aliases; src;
	    fi;
	    if [ $# -eq 1 ]; then
	        if [ $1 -ne 2 ]; then
	            old_directory=$(pwd);
	            new_directory=$(cs ~/Coding/Scripts/; pwd);

	            cs $new_directory;
	            nano ~/Coding/Scripts/bash_aliases; src;

	            echo 'Enter gitc commit message'; read var1; gitc $var1;
	            cs $old_directory;
	        fi;
	        if [ $1 -eq 2 ]; then
	            old_directory=$(pwd);
	            new_directory=$(cs ~/Coding/Scripts/; pwd);
	            cs $new_directory;

	            echo 'Enter gitc commit message'; read var1; gitc $var1;
	            cs $old_director;
	        fi;
	    fi
	} #nbash

	#used to modify the cheatsheet with additional params to automatically push with gitc
	function ncheat() { 
	    if [ $# -eq 0 ]; then
	        nano ~/Coding/Scripts/linuxCheatSheet.txt;
	    fi;
	    if [ $# -eq 1 ]; then
	        if [ $1 -ne 2 ]; then
	            old_directory=$(pwd);
	            new_directory=$(cs ~/Coding/Scripts/; pwd);
	            cs $new_directory;

	            nano ~/Coding/Scripts/linuxCheatSheet.txt;

	            echo 'Enter gitc commit message'; read var1; gitc $var1;
	            cs $old_directory;
	        fi;
	        if [ $1 -eq 2 ]; then
	            old_directory=$(pwd);
	            new_directory=$(cs ~/Coding/Scripts/; pwd);
	            cs $new_directory;

	            echo 'Enter gitc commit message'; read var1; gitc $var1;
	            cs $old_directory;
	        fi;
	    fi
	} #ncheat

        #grep the cheat sheet (different arguments allow for more precise parsing)
        function gcheat() {
                if [ $# -eq 0 ]; then
                        cat ~/Downloads/cheats/acheatSheet.txt;
                fi;
                if [ $# -eq 1 ]; then
                        cat ~/Downloads/cheats/acheatSheet.txt | grep $1;
                fi;
                if [ $# -eq 2 ]; then
                        cat ~/Downloads/cheats/acheatSheet.txt | grep -A $2 $1;
                fi;
                if [ $# -eq 3 ]; then
                        if [ $3 -eq 0]; then
                                cat ~/Downloads/cheats/acheatSheet.txt | grep $1 $2;
                        fi;
                        if [ $# -ne 0 ]; then
                                cat ~/Downloads/cheats/acheatSheet.txt | grep $1;
                                cat ~/Downloads/cheats/acheatSheet.txt | grep $2;
                        fi;
                fi;
        } #gcheat
        #grep a functions full contents 
        function gf() {
                if [ $# -eq 0 ]; then
                        cat ~/Coding/Scripts/bash_aliases | grep -Po "^[ \t]*function() [\w\-]*\(\)";
                fi;
                if [ $# -eq 1 ]; then
                        cat ~/Coding/Scripts/bash_aliases | grep -Pzo "[ \t]*#.*?\n[\t ]*function $1[\S\s]*#$1\n";
                fi;
        } #gf
        #searches for a string in a pdf
        function gpdf() {
                if [ $# -eq 1 ]; then
                        find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color "$1"' \;
                fi;
                if [ $# -eq 2 ]; then
                        find $2 -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color "$1"' \;
                fi;
        } #gpdf
        #gman - searches a man page of a tool for a string
        function gman() {
                if [ $# -eq 2 ]; then
                        man $1 | grep "$2"
                fi;
                if [ $# -eq 3 ]; then
                        man $1 | grep $2 "$3"
                fi;
        } #gman
        #greps current directory for string (additional params will set directory and flags to grep)
        function gls() {
                if [ $# -eq 1 ]; then
                        ls | grep "$1"
                fi;
                if [ $# -eq 2 ]; then
                        ls | grep $1 "$2"
                fi;
                if [ $# -eq 3 ]; then
                        ls $3 | grep $1 "$2"
                fi;
        } #gls
#standard shortcuts
#misc
	#system stuff (uses Python file TODO: included in this repo)
        alias screenSize='cd /home/jared/Downloads/cheats/scripts; python3 screenSize.py'

	#irc 
        alias ebooks="cd /home/jared/snap/konversation/3/Downloads/; open .;"

	#elvis exit (i.e. slow exit)
        alias EXIT='echo ""; echo ""; echo "GEEZ, no need to yell ya know?"; echo ""; echo ""; sleep 2; exit;'

  #yt
	alias songLength='for i in *.mp3; do echo $(ffmpeg -i "$i" 2>&1 | grep -oP "(?<=Duration: )[0-9:]*"), >> test.txt; done'
	alias songRename='for i in *.mp3; do mv "$i" "`echo $i | sed "s/-[a-zA-Z0-9_]*.mp3/.mp3/"`"; done'

	#youtube-dl ##  --playlist-end ###
        function update-yt() {
                sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl;
                sudo chmod a+rx /usr/local/bin/youtube-dl;
        } #update-yt
        #automatically set playlist-end value through user input
        function yt() {
                cdyt
                if [ "$#" -eq 1 ]; then
                   sudo youtube-dl -U; youtube-dl --extract-audio --audio-format mp3 --playlist-start 1 --playlist-end ${1} https://www.youtube.com/playlist?list=PLw9tOEvRg20cBy10SEwKCClDm8ds3mrsi;
                elif [ "$#" -eq 2 ]; then
                   sudo youtube-dl -U; youtube-dl --extract-audio --audio-format mp3 --playlist-start ${1} --playlist-end ${2} https://www.youtube.com/playlist?list=PLw9tOEvRg20cBy10SEwKCClDm8ds3mrsi;          
                else
                   echo "Too many parameters. 1 parameter to set last song # in playlist, 2 parameters to set first and then last song";
                fi
        } #yt
  #yt
        #searches through a repository for all pdfs and returns the absolute path
        function itsbooktime() { 
                nice find /l/www/classes/ -type d ! \( -readable -executable \) -prune -o -name '*.pdf' | awk -F "/" '{ if(!seen[$NF]++) print $0 }' > paths.txt; }
#               ^easy on cpu              ^ avoids reading files without read permission^       ^any pdf      ^fields      ^if the last part of has not been seen (unique name)
#                                                                                                         are designated           then return the whole directory name
#                
                                                                                                 #by the "/" mark
        #itsbooktime
        #function to filter out all pdfs that contain any key words that grep picks up
        function bookfilter() { awk -F "/" '{print $NF}' paths.txt | grep -E '(exam|study|guide|final)'; } #bookfilter
#misc

#local bash shortcuts
        #classwork
        alias 100="cd /home/jared/Classwork/a100/"
                alias a100="cd /home/jared/Classwork/a100/"
        alias 204="cd /home/jared/Classwork/L204/"
                alias l204="cd /home/jared/Classwork/L204/"
                alias L204="cd /home/jared/Classwork/L204/"
                alias fa='cd /home/jared/Classwork/L204/papers/project'
        alias 290="cd /home/jared/Classwork/a290/"
                alias a290="cd /home/jared/Classwork/a290/"
        alias 311="cd /home/jared/Classwork/M311/"
        alias 335="cd /home/jared/Classwork/C335/C335-Spring2020"
                alias mb='clear; make clean; make download'
                alias md='clear; make download'
                alias ssr='cd /home/jared/Classwork/C335/C335-Spring2020/driver/src/'
                alias iinc='cd /home/jared/Classwork/C335/C335-Spring2020/driver/inc/'
                alias sr='cd /home/jared/Classwork/C335/galaga/driver/src'
                alias inc='cd /home/jared/Classwork/C335/galaga/driver/inc/'
                alias driver='cd /home/jared/Classwork/C335/C335-Spring2020/driver'
                alias drivers='cd /home/jared/Classwork/C335/C335-Spring2020/driver'
                alias lab='cd /home/jared/Classwork/C335/labs-hw'
                alias olab='open /home/jared/Classwork/C335/labs-hw'
                alias gal='cd /home/jared/Classwork/C335/galaga'
                alias gg='cd /home/jared/Classwork/C335/galaga/gg'
                alias pgal='cd /home/jared/Classwork/C335/galaga; git pull'
        alias 399="cd /home/jared/Classwork/y399/"
                alias deel="cd /home/jared/Classwork/y399/"
        alias 438="cd /home/jared/Classwork/P438/"
                alias p438="cd /home/jared/Classwork/P438/"
                alias P438="cd /home/jared/Classwork/P438/"
                alias net="cd /home/jared/Classwork/P438/Net-Fall20/src/py"
                alias fall="cd /home/jared/Classwork/P438/Net-Fall20/src/py"
                alias netfall="cd /home/jared/Classwork/P438/Net-Fall20/src/py"
        alias 555="cd /home/jared/Classwork/B555/"

        alias book="cd /home/jared/Downloads/Books"
                alias books="cd /home/jared/Downloads/Books; open .; exit"
        alias csc="cd /home/jared/Classwork/CSC/"
        alias ctf="cd /home/jared/Classwork/CSC/ctf"
        alias scripts="cd ~/Coding/Scripts"
                alias script="cd ~/Coding/Scripts"
                alias pgit="cd ~/Coding/Scripts"
        alias sheets="cd /home/jared/Downloads/SheetMusic/; open .; exit"
        alias syn="cd /home/jared/Classwork/synopsys"
#local bash shortcuts
