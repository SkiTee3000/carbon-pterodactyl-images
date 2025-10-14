#!/bin/bash

################################
# STEAMCMD DOWNLOAD GAME FILES #
################################

source /helpers/messages.sh

Debug "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Debug "Inside /helpers/steamcmd.sh file!"

Info "Sourcing SteamCMD Script..."

# We need to delete the steamapps directory in order to prevent the following error:
# Error! App '258550' state is 0x486 after update job.
# Ref: https://www.reddit.com/r/playark/comments/3smnog/error_app_376030_state_is_0x486_after_update_job/
function Delete_SteamApps_Directory() {
    Debug "Deleting SteamApps Folder as a precaution..."
    rm -rf /home/container/steamapps
}

# Validate when downloading
function SteamCMD_Validate() {
	Debug "Inside Function: SteamCMD_Validate()"

    # Determine which Steam branch to use
    local STEAM_BETA_BRANCH=""

    # If custom branch is specified, use it
    if [[ -n "${STEAM_BRANCH}" ]]; then
        STEAM_BETA_BRANCH="${STEAM_BRANCH}"
        Info "Using custom Steam branch: ${STEAM_BETA_BRANCH}"
    # Otherwise, determine by framework
    elif [[ "${FRAMEWORK}" == *"aux1"* ]]; then
        STEAM_BETA_BRANCH="aux01-staging"
    elif [[ "${FRAMEWORK}" == *"aux2"* ]]; then
        STEAM_BETA_BRANCH="aux02"
    elif [[ "${FRAMEWORK}" == *"staging"* ]]; then
        STEAM_BETA_BRANCH="staging"
    else
        STEAM_BETA_BRANCH="public"
    fi

    Delete_SteamApps_Directory
    Info "Downloading ${STEAM_BETA_BRANCH} Files - Validation On!"
    ./steamcmd/steamcmd.sh +force_install_dir /home/container +login anonymous +app_update 258550 -beta ${STEAM_BETA_BRANCH} validate +quit
}

# Don't validate while downloading
function SteamCMD_No_Validation() {
	Debug "Inside Function: SteamCMD_No_Validation()"

    # Determine which Steam branch to use
    local STEAM_BETA_BRANCH=""

    # If custom branch is specified, use it
    if [[ -n "${STEAM_BRANCH}" ]]; then
        STEAM_BETA_BRANCH="${STEAM_BRANCH}"
        Info "Using custom Steam branch: ${STEAM_BETA_BRANCH}"
    # Otherwise, determine by framework
    elif [[ "${FRAMEWORK}" == *"aux1"* ]]; then
        STEAM_BETA_BRANCH="aux01-staging"
    elif [[ "${FRAMEWORK}" == *"aux2"* ]]; then
        STEAM_BETA_BRANCH="aux02"
    elif [[ "${FRAMEWORK}" == *"staging"* ]]; then
        STEAM_BETA_BRANCH="staging"
    else
        STEAM_BETA_BRANCH="public"
    fi

    Info "Downloading ${STEAM_BETA_BRANCH} Files - Validation Off!"
    ./steamcmd/steamcmd.sh +force_install_dir /home/container +login anonymous +app_update 258550 -beta ${STEAM_BETA_BRANCH} +quit
}
