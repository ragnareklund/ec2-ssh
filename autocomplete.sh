# Autocomplete for ssh (put in ~/.bashrc)

complete -o default -o nospace -W "$(grep -i -e '^Host ' ~/.ssh/config | awk '{print substr($0, index($0,$2))}' ORS=' ')" ssh scp sftp
