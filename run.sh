DIR="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"
docker run --rm --privileged   -it  --name buydomains-ci4-container   -p 91:443 -v "/sys/fs/cgroup:/sys/fs/cgroup:ro" -v "$DIR/build:/var/www/html" -i -t buydomains-ci4-img