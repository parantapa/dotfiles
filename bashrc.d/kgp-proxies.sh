# Function to setup proxy for KGP systems
function set-proxy () {
    local proxies k

    proxies[245]=http://144.16.192.245:8080
    proxies[247]=http://144.16.192.247:8080
    proxies[213]=http://144.16.192.213:8080
    proxies[216]=http://144.16.192.216:8080
    proxies[217]=http://144.16.192.217:8080
    proxies[211]=http://10.3.100.211:8080
    proxies[212]=http://10.3.100.212:8080
    proxies[207]=http://10.3.100.207:8080
    
    proxies[0]=""

    k=${1-0}
    export http_proxy=${proxies[$k]}
    export https_proxy=${proxies[$k]}
    export no_proxy="localhost,127.0.0.1"
    echo "Proxy: $http_proxy"
}
