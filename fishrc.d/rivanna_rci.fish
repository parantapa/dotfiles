# Rivanna specific config

# /etc/profile.d/rci.sh
set -x PATH $PATH /opt/slurm/current/bin /opt/slurm/current/sbin /opt/singularity/current/bin /opt/rci/bin /opt/nhc/current/sbin /share/rci_apps/common/bin /share/resources/HPCtools/ /apps/resources/mam/current/bin
set -x MODULEPATH /apps/modulefiles/standard/core /apps/modulefiles/standard/toolchains /apps/modulefiles/vendor
set -x LD_LIBRARY_PATH /opt/slurm/current/lib /share/rci_apps/common/lib64
set -x LD_INCLUDE_PATH /opt/slurm/current/include /share/rci_apps/common/include

# /etc/profile.d/z00_lmod.sh
source /usr/share/lmod/lmod/init/fish
