function fish_title
    echo -n "$__fish_prompt_hostname"
    echo -n ": "
    echo -n (basename "$PWD")
end
