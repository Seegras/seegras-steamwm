#!/bin/bash
# 
# Wrapper to force steam to use steamwm.so
# 
[ -z "${STEAMWM_FORCE_BORDERS}"   ] && export STEAMWM_FORCE_BORDERS=1
[ -z "${STEAMWM_PREVENT_MOVE}"    ] && export STEAMWM_PREVENT_MOVE=1
[ -z "${STEAMWM_FIX_NET_WM_NAME}" ] && export STEAMWM_FIX_NET_WM_NAME=0
[ -z "${STEAMWM_GROUP_WINDOWS}"   ] && export STEAMWM_GROUP_WINDOWS=1
[ -z "${STEAMWM_SET_WINDOW_TYPE}" ] && export STEAMWM_SET_WINDOW_TYPE=1
[ -z "${STEAMWM_SET_FIXED_SIZE}"  ] && export STEAMWM_SET_FIXED_SIZE=0
[ -z "${STEAMWM_MANAGE_ERRORS}"   ] && export STEAMWM_MANAGE_ERRORS=1

export LD_PRELOAD="steamwm.so:${LD_PRELOAD}"
export LD_LIBRARY_PATH="${HOME}/lib/lib32:${HOME}/lib/lib64:${LD_LIBRARY_PATH}"
# export STEAM_RUNTIME=0
export STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1

move_registry_to_tmpfs () {
    ### For huge steam libraries, it's necessary to move the registry
    ### to a RAM-based tmpfs during start, as it's written thousands
    ### of times(!) during startup. 
    ### See https://github.com/ValveSoftware/steam-for-linux/issues/7117

    STEAM_HOME=~

    export VDF_LINK=$STEAM_HOME/.steam/registry.vdf
    export VDF_BACKUP=$STEAM_HOME/.steam/registry.vdf.tmpfs
    export VDF_TMP=/dev/shm/registry.vdf

    ### If registry.vdf is not in our tmpfs folder then copy it there from our backup.
    if [ ! -f $VDF_TMP ]; then
        echo "$VDF_TMP not found. Copying from $VDF_BACKUP"
        cp $VDF_BACKUP $VDF_TMP
    fi

    ### If registry.vdf symlink is not in steam folder, create it.
    if [ ! -L $VDF_LINK ]; then
        echo "$VDF_LINK symlink not found. Creating symlink to $VDF_TMP."
        ln -s $VDF_TMP $VDF_LINK
    fi
}

backup_registry_from_tmpfs () {
    ### Backup registry.vdf out of our tmpfs when steam quits.
    echo "Steam quit. Backing up VDF."
    cp -f $VDF_TMP $VDF_BACKUP
}


move_registry_to_tmpfs
### Start steam.
HOME=~/.saves
exec /usr/games/steam -forcedesktopscaling 2
# -no-cef-sandbox
backup_registry_from_tmpfs
