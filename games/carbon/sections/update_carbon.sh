#!/bin/bash

source /helpers/messages.sh

#################
# UPDATE CARBON #
#################

Debug "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Debug "Inside /sections/update_carbon.sh file!"

Debug "Trying to update Carbon..."

# This is necessary for carbon to run. Put it in a function to reduce repeat code.
function Doorstop_Startup_Carbon() {
    export DOORSTOP_ENABLED=1
    export DOORSTOP_TARGET_ASSEMBLY="$(pwd)/${MODDING_ROOT}/managed/Carbon.Preloader.dll"
    MODIFIED_STARTUP="LD_PRELOAD=$(pwd)/libdoorstop.so ${MODIFIED_STARTUP}"
}

if [[ "$FRAMEWORK_UPDATE" == "1" ]]; then
	# Determine build tag and build type
	local CARBON_BUILD_TAG=""
	local CARBON_BUILD_TYPE=""
	local IS_MINIMAL=false

	# If custom Carbon branch is specified, use it
	if [[ -n "${CARBON_BRANCH}" ]]; then
		CARBON_BUILD_TAG="${CARBON_BRANCH}"
		Info "Using custom Carbon build tag: ${CARBON_BUILD_TAG}"

		# Determine build type based on framework setting
		if [[ "${FRAMEWORK}" == *"minimal"* ]]; then
			CARBON_BUILD_TYPE="Carbon.Linux.Minimal.tar.gz"
			IS_MINIMAL=true
		else
			# For production/edge, use Release/Debug based on framework
			if [[ "${FRAMEWORK}" == "carbon" ]]; then
				CARBON_BUILD_TYPE="Carbon.Linux.Release.tar.gz"
			else
				CARBON_BUILD_TYPE="Carbon.Linux.Debug.tar.gz"
			fi
		fi
	# Otherwise, determine by framework
	elif [[ "${FRAMEWORK}" == "carbon" ]]; then
		CARBON_BUILD_TAG="production_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Release.tar.gz"
	elif [[ "${FRAMEWORK}" == "carbon-minimal" ]]; then
		CARBON_BUILD_TAG="production_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Minimal.tar.gz"
		IS_MINIMAL=true
	elif [[ "${FRAMEWORK}" == "carbon-edge" ]]; then
		CARBON_BUILD_TAG="edge_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Debug.tar.gz"
	elif [[ "${FRAMEWORK}" == "carbon-edge-minimal" ]]; then
		CARBON_BUILD_TAG="edge_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Minimal.tar.gz"
		IS_MINIMAL=true
	elif [[ "${FRAMEWORK}" == "carbon-staging" ]]; then
		CARBON_BUILD_TAG="rustbeta_staging_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Debug.tar.gz"
	elif [[ "${FRAMEWORK}" == "carbon-staging-minimal" ]]; then
		CARBON_BUILD_TAG="rustbeta_staging_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Minimal.tar.gz"
		IS_MINIMAL=true
	elif [[ "${FRAMEWORK}" == "carbon-aux1" ]]; then
		CARBON_BUILD_TAG="rustbeta_aux01_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Debug.tar.gz"
	elif [[ "${FRAMEWORK}" == "carbon-aux1-minimal" ]]; then
		CARBON_BUILD_TAG="rustbeta_aux01_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Minimal.tar.gz"
		IS_MINIMAL=true
	elif [[ "${FRAMEWORK}" == "carbon-aux2" ]]; then
		CARBON_BUILD_TAG="rustbeta_aux02_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Debug.tar.gz"
	elif [[ "${FRAMEWORK}" == "carbon-aux2-minimal" ]]; then
		CARBON_BUILD_TAG="rustbeta_aux02_build"
		CARBON_BUILD_TYPE="Carbon.Linux.Minimal.tar.gz"
		IS_MINIMAL=true
	fi

	# If we have a Carbon build to download
	if [[ -n "${CARBON_BUILD_TAG}" && -n "${CARBON_BUILD_TYPE}" ]]; then
		local FRAMEWORK_NAME="${FRAMEWORK}"
		if [[ $IS_MINIMAL == true ]]; then
			FRAMEWORK_NAME="${FRAMEWORK_NAME} Minimal"
		fi

		Info "Updating ${FRAMEWORK_NAME}..."
		Info "Build Tag: ${CARBON_BUILD_TAG}, Build Type: ${CARBON_BUILD_TYPE}"

		# Use Carbon.Core repo for production release, Carbon repo for others
		if [[ "${CARBON_BUILD_TAG}" == "production_build" && "${CARBON_BUILD_TYPE}" == "Carbon.Linux.Release.tar.gz" ]]; then
			curl -sSL "https://github.com/CarbonCommunity/Carbon.Core/releases/download/${CARBON_BUILD_TAG}/${CARBON_BUILD_TYPE}" | tar zx
		else
			curl -sSL "https://github.com/CarbonCommunity/Carbon/releases/download/${CARBON_BUILD_TAG}/${CARBON_BUILD_TYPE}" | tar zx
		fi

		Check_Modding_Root_Folder
		Success "Done updating Carbon!"
		Doorstop_Startup_Carbon
	fi
else
	Error "Skipping framework auto update! Did you mean to do this? If not set the Framework Update variable to true!"
fi