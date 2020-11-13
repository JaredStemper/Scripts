#aliases
	#runs command into non-interactive shell after logging in
	alias iussh='ssh jaastemp@silo.soic.indiana.edu -t "source ~/.bashrc && source ~/.bash_aliases; bash"'
	
	#executes contents of the file passed as arguments, in the CURRENT shell
	alias src="source ~/.bashrc && source ~/.bash_aliases"

#functions
        #runs git pull/add/commit/push in one command with the $* argument used as the commit message
        function gitc() {  
                git pull; git add --all :/; git commit -m "$*"; git push
        } #gitc
        #automatically uses ls after "cd"ing. overrides cd
        function cd() {
                new_directory="$*";
                if [ $# -eq 0 ]; then 
                        new_directory=${HOME};
                fi;
                builtin cd "${new_directory}" && l
        } #cd
        #same as cd but uses ls instead
        function cs() {
                new_directory="$*";
                if [ $# -eq 0 ]; then
                        new_directory=${HOME};
                fi;
                builtin cd "${new_directory}" && ls
        } #cs
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
        #greps current directory for string (additional parasm will set directory and flags to grep)
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
        #like pizza time, only so much better
        function itsbooktime() { 
                nice find /l/www/classes/ -type d ! \( -readable -executable \) -prune -o -name '*.pdf' | awk -F "/" '{ if(!seen[$NF]++) print $0 }' > paths.txt; }
#               ^easy on cpu              ^ avoids reading files without read permission^       ^any pdf     ^fields    ^if the last part of has not been seen (unique name)
#                                                                                                         are designated          then return the whole directory name
#                
                                                                                                 #by the "/" mark
        #itsbooktime
        #function to filter out all pdfs that contain any key words that grep picks up
        function bookfilter() { awk -F "/" '{print $NF}' paths.txt | grep -E '(exam|study|guide|final)'; } #bookfilter

