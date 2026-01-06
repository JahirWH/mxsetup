#  Path a Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

#  Tema moderno de prompt usando Starship (ignora ZSH_THEME)
ZSH_THEME=""

#  Plugins recomendados
plugins=(
  git
  z
  sudo
  command-not-found
  zsh-autosuggestions
)

#  Autocompletado avanzado
fpath=(~/.zsh/zsh-completions/src $fpath)
autoload -Uz compinit bashcompinit
compinit
bashcompinit

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

#  Carga Oh My Zsh
source $ZSH/oh-my-zsh.sh

#  Prompt bonito con íconos y colores
eval "$(starship init zsh)"

#  Mostrar info del sistema al iniciar
if [[ $TERM != "dumb" ]]; then
  neofetch
fi

# Idioma por defecto
export LANG=en_US.UTF-8

#  Añadir rutas personales al PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

#  Aliases útiles
alias ll="ls -lh"
alias la="ls -A"
alias l="ls -CF"
alias zshconfig="nvim ~/.zshrc"
alias reload="source ~/.zshrc"

#  Editor preferido
export EDITOR="micro"
eval "$(starship init zsh)"
export PATH=$PATH:/snap/bin

export DOCKER_HOST=unix:///var/run/docker.sock
