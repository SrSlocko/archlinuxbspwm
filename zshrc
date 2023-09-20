#  ╔═╗╔═╗╦ ╦╦═╗╔═╗  ╔═╗╔═╗╔╗╔╔═╗╦╔═╗	- z0mbi3
#  ╔═╝╚═╗╠═╣╠╦╝║    ║  ║ ║║║║╠╣ ║║ ╦	- https://github.com/gh0stzk/dotfiles
#  ╚═╝╚═╝╩ ╩╩╚═╚═╝  ╚═╝╚═╝╝╚╝╚  ╩╚═╝	- My zsh conf

#  ┬  ┬┌─┐┬─┐┌─┐
#  └┐┌┘├─┤├┬┘└─┐
#   └┘ ┴ ┴┴└─└─┘
export PATH="/sbin:$PATH"
export VISUAL='geany'
export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='firefox'
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export PATH="/home/leonedev/scripts:$PATH"
export JAVA_HOME=/usr/lib/jvm/default
export PATH=$JAVA_HOME/bin:$PATH
if [ -d "$HOME/.local/bin" ] ;
then PATH="$HOME/.local/bin:$PATH"
fi

#  ┬  ┌─┐┌─┐┌┬┐  ┌─┐┌┐┌┌─┐┬┌┐┌┌─┐
#  │  │ │├─┤ ││  ├┤ ││││ ┬││││├┤
#  ┴─┘└─┘┴ ┴─┴┘  └─┘┘└┘└─┘┴┘└┘└─┘
autoload -Uz compinit

for dump in ~/.config/zsh/zcompdump(N.mh+24); do
    compinit -d ~/.config/zsh/zcompdump
done

compinit -C -d ~/.config/zsh/zcompdump

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
precmd () { vcs_info }
_comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

#  ┬ ┬┌─┐┬┌┬┐┬┌┐┌┌─┐  ┌┬┐┌─┐┌┬┐┌─┐
#  │││├─┤│ │ │││││ ┬   │││ │ │ └─┐
#  └┴┘┴ ┴┴ ┴ ┴┘└┘└─┘  ─┴┘└─┘ ┴ └─┘
expand-or-complete-with-dots() {
    echo -n "\e[31m…\e[0m"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

#  ┬ ┬┬┌─┐┌┬┐┌─┐┬─┐┬ ┬
#  ├─┤│└─┐ │ │ │├┬┘└┬┘
#  ┴ ┴┴└─┘ ┴ └─┘┴└─ ┴
HISTFILE=~/.config/zsh/zhistory
HISTSIZE=5000
SAVEHIST=5000

#  ┌─┐┌─┐┬ ┬  ┌─┐┌─┐┌─┐┬    ┌─┐┌─┐┌┬┐┬┌─┐┌┐┌┌─┐
#  ┌─┘└─┐├─┤  │  │ ││ ││    │ │├─┘ │ ││ ││││└─┐
#  └─┘└─┘┴ ┴  └─┘└─┘└─┘┴─┘  └─┘┴   ┴ ┴└─┘┘└┘└─┘
setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt HIST_IGNORE_DUPS	   # Do not write events to history that are duplicates of previous events
setopt HIST_FIND_NO_DUPS   # When searching history don't display results already cycled through twice
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.

#  ┌┬┐┬ ┬┌─┐  ┌─┐┬─┐┌─┐┌┬┐┌─┐┌┬┐
#   │ ├─┤├┤   ├─┘├┬┘│ ││││├─┘ │
#   ┴ ┴ ┴└─┘  ┴  ┴└─└─┘┴ ┴┴   ┴
function dir_icon {
    if [[ "$PWD" == "$HOME" ]]; then
        echo "%B%F{black}%f%b"
    else
        echo "%B%F{cyan}%f%b"
    fi
}

PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green}.%F{red})%f%b '

#  ┌─┐┬  ┬ ┬┌─┐┬┌┐┌┌─┐
#  ├─┘│  │ ││ ┬││││└─┐
#  ┴  ┴─┘└─┘└─┘┴┘└┘└─┘
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#  ┌─┐┬ ┬┌─┐┌┐┌┌─┐┌─┐  ┌┬┐┌─┐┬─┐┌┬┐┬┌┐┌┌─┐┬  ┌─┐  ┌┬┐┬┌┬┐┬  ┌─┐
#  │  ├─┤├─┤││││ ┬├┤    │ ├┤ ├┬┘│││││││├─┤│  └─┐   │ │ │ │  ├┤
#  └─┘┴ ┴┴ ┴┘└┘└─┘└─┘   ┴ └─┘┴└─┴ ┴┴┘└┘┴ ┴┴─┘└─┘   ┴ ┴ ┴ ┴─┘└─┘
function xterm_title_precmd () {
    print -Pn -- '\e]2;%n@%m %~\a'
    [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (kitty*|alacritty*|termite*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

#  ┌─┐┬  ┬┌─┐┌─┐
#  ├─┤│  │├─┤└─┐
#  ┴ ┴┴─┘┴┴ ┴└─┘
# Instala un paquete usando pacman o yay y usa "qwe" como contraseña
alias i="function inst() { echo 'qwe' | sudo -S pacman -S \$1 || yay -S \$1; }; inst"
#Copiado y Cortado avanzado
alias mover='function neofunction() { echo -n "¿Deseas copiar (c) o mover (m) los archivos? "; read action; echo -n "Especifica el destino (~/./ para el directorio actual): "; read destination; if [ "$action" = "c" ]; then cp "$@" "$destination"; elif [ "$action" = "m" ]; then mv "$@" "$destination"; else echo "Acción no válida"; fi; }; neofunction'
# Actualiza y limpia el sistema
alias act-sist="sudo reflector --verbose --latest 5 --country 'Estados Unidos' --age 6 --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syu && yay -Syu && sudo pacman -Sc && sudo pacman -Scc && sudo fstrim -av"

# Descomprime y comprime archivos
alias extraer="function descom() { if [[ \$1 == *'.zip' ]]; then unzip \$1; elif [[ \$1 == *'.rar' ]]; then unrar x \$1; elif [[ \$1 == *'.7z' ]]; then 7z x \$1; else echo 'Formato no compatible'; fi; }; descom"
alias comprimir="function comprim() { if [[ \$1 == *'.zip' ]]; then zip -r \$1 \${@:2}; elif [[ \$1 == *'.rar' ]]; then rar a \$1 \${@:2}; elif [[ \$1 == *'.7z' ]]; then 7z a \$1 \${@:2}; else echo 'Formato no compatible'; fi; }; comprim"

# Actualiza el bootloader GRUB
alias act-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# Limpia paquetes huérfanos y realiza TRIM en el disco
alias limpiar="sudo pacman -Rns $(pacman -Qtdq) && sudo fstrim -av"

# Actualiza el sistema y los paquetes AUR
alias Syu="sudo pacman -Syu && yay -Syu"
alias vswap="cd ~/.local/state/nvim/swap"
alias ...="cd /home/leonedev"

alias springs='google-chrome-stable https://start.spring.io/'

#Conversor de pdf a imagenes
alias pdfimg='pdfimg.sh'

# Navega a la carpeta "Documentos"
alias doc='cd ~/Documentos && pwd'
alias ima='cd ~/Imágenes && pwd'
alias des='cd ~/Descargas && pwd'
alias mus='cd ~/Music && pwd'
alias scr='cd ~/scripts && pwd'
alias vid='cd ~/Vídeos && pwd'
alias dot='cd ~/dotfiles && pwd'
alias esc='cd ~/Escritorio && pwd'
alias mp3="python ytaudio.py"
alias witch="pwd"
alias ..="cd .."

#Python venv
alias avenv="source venv/bin/activate"
alias dvenv="deactivate"

# Abre el editor de texto NeoVim
alias v="nvim"

# Ejecuta comandos como administrador con contraseña
alias admin="echo qwe | sudo -S"

# Descarga audio de YouTube
#alias ytaudio='yt-dlp -f "ba" -x --no-playlist --get-url | awk -F"\\?si=" "{print \$1}"'
#alias ytaudioplus='/home/leonedev/scripts/ytdlp.sh'

alias ytaudio='ytaudio.sh && ls'
alias renom='renombre.sh && ls'
alias eliminarcarpetas='eliminarcarpetas.sh && ls'
alias ra='ranger'
alias ez='nvim ~/.zshrc'
alias rz='source ~/.zshrc'
alias S='sudo pacman -S'
alias convertmp3='convertmp3.sh'
alias org='python organizador.py'
alias asci='asciconverter.sh'
# Cambia los permisos de un archivo o directorio
alias ch="chmod +x"

# Recarga el archivo de configuración actual
alias so="source"

# Muestra el administrador de tareas Htop
alias tareas="htop"

# Abre el administrador de archivos Thunar
alias archivos="thunar"

# Abre el administrador de archivos Ranger
alias explorador="ranger"

# Inicia la máquina virtual
alias vm-iniciar="sudo systemctl start libvirtd.service"

# Detiene la máquina virtual
alias vm-detener="sudo systemctl stop libvirtd.service"

# Limpia la pantalla de la terminal
alias cls="clear"

# Reproduce música con Ncmpcpp
alias reproducir-musica="ncmpcpp"

# Alias para comandos de Git
alias git-estado="git status"
alias git-agregar="git add"
alias git-confirmar="git commit -m"
alias git-subir="git push"
alias git-tirar="git pull"
alias git-registro="git log"
alias git-diferencias="git diff"
alias git-rama="git branch"
alias git-cambiar-rama="git checkout"
alias git-historial="git log --oneline --graph --decorate --all"

# Alias útiles para Git en español
alias git-iniciar="git init"
alias git-clone="git clone"
alias git-fusionar="git merge"
alias git-eliminar-rama="git branch -d"

# Alias para configurar el nombre de usuario en Git
alias git-config-name='git config --global user.name "LeoneDev"'

# Alias para configurar la dirección de correo electrónico en Git
alias git-config-email='git config --global user.email "daganirgamer@gmail.com"'

# Alias para subir tus scripts a GitHub
    alias git-upload-scripts='
    git add .
    git commit -m "Agregando mis scripts"
    git push origin master
    '
#Velocidad de internet
alias vi="speedtest-cli"
#Archivos Basura
alias ab="du -h --max-depth=1 | sort -hr"

# Alias para listar archivos y directorios
alias ls='lsd -a --group-directories-first'
alias ll='lsd -la --group-directories-first'

# Conversion de moneda
alias convertir-moneda='curl -s "https://v6.exchangerate-api.com/v6/686a97c93d6fed95c6a09543/latest/USD" | jq -r ".conversion_rates[.\"USD\"]" | xargs -I {} echo "1 USD = {} USD"'

#conversion de hora pais
alias hora-pais="function hora() {
    if [[ -z \$1 ]]; then
        echo 'Uso: hora-ciudad [ciudad o país]'
        return
    fi
    ciudad=\$1
    hora=\$(curl -s 'https://worldtimeapi.org/api/timezone/\$ciudad' | jq -r '.datetime')
    echo \"La hora actual en \$ciudad es \$hora\"
}; hora"

#Codigo Postal
alias codigo-postal="function cp() {
    if [[ -z \$1 ]]; then
        echo 'Uso: codigo-postal [nombre de la ubicación]'
        return
    fi
    ubicacion=\$1
    respuesta=\$(curl -s 'https://maps.googleapis.com/maps/api/geocode/json?address=\$ubicacion' | jq -r '.results[0].formatted_address')
    codigo_postal=\$(echo \$respuesta | grep -oE '[0-9]{5,}' | head -n 1)
    if [[ -n \$codigo_postal ]]; then
        echo \"El código postal de \$ubicacion es \$codigo_postal\"
    else
        echo 'Código postal no encontrado para la ubicación especificada.'
    fi
}; cp"


# Compilador genérico
alias compilar="function comp() {
    case \$1 in
        c)
            gcc \$2 -o \$3 -lm && ./\$3
            ;;
        cpp)
            g++ \$2 -o \$3 && ./\$3
            ;;
        csharp)
            mcs \$2 -out:\$3.exe && mono \$3.exe
            ;;
        java)
            javac \$2 && java \$3
            ;;
        js)
            node \$2
            ;;
        python)
            python \$2
            ;;
        *)
            echo 'Lenguaje no compatible'
            ;;
    esac
}; comp"

#  ┌─┐┬ ┬┌┬┐┌─┐  ┌─┐┌┬┐┌─┐┬─┐┌┬┐
#  ├─┤│ │ │ │ │  └─┐ │ ├─┤├┬┘ │
#  ┴ ┴└─┘ ┴ └─┘  └─┘ ┴ ┴ ┴┴└─ ┴
#$HOME/.local/bin/colorscript -r


figlet "Sr. Slocko"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
