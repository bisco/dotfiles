# path
set PATH /sbin /bin /usr/sbin /usr/local/sbin $PATH
if test -d $HOME/.bin
    set PATH $HOME/.bin $PATH
end

# fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showcolorhints 'yes'

# fish hilighting
set fish_color_redirection green --bold

# rename tmux window
function window_rename --on-event fish_preexec
    if test -n (echo $TERM | grep -e screen -e tmux)
        if test -n $argv[1]
            tmux rename-window (printf "%.16s" $argv[1])
        end
    end
end
