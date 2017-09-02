# Function to setup proxy for KGP systems
function set-proxy
    if test (count $argv) -eq 0
        set -e http_proxy
        set -e https_proxy
        return
    end

    switch $argv[1]
    case '207'
        set proxy "http://10.3.100.207:8080"
    case '*'
        echo "Unknown proxy" $argv[1]
        return
    end

    set -xg http_proxy $proxy
    set -xg https_proxy $proxy
    set -xg no_proxy "localhost,127.0.0.1"
    echo "Proxy: $http_proxy"
end
