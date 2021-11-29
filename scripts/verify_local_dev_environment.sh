#!/bin/bash

FAILURE="false"

# prints out red text
function echo_failure {
    echo -e "\033[1;31m$1\033[0m"
}

# prints out green text
function echo_success {
    echo -e "\033[1;32m$1\033[0m"
}

# Function to verify if a version is valid
function verify {
    tool="$1"
    expected_version="$2"
    get_version_version_command="$3"

    # Before we compare versions, the program has to be installed, with the 'which' command
    tool_exists="$(which "${tool}")"
    exit_code="$?"
    if [ "${exit_code}" != "0" ]; then
        echo_failure "Error: ${tool} not found in PATH"
        FAILURE="true"
        return
    fi
    
    # Run the command to extract the current version number
    actual_version="$(eval ${get_version_version_command} 2> /dev/null)"
    exit_code="$?"
    # If there was an error parsing the version (invalid command perhaps)
    if [ "${exit_code}" != "0" ]; then
        echo_failure "Error: could not parse ${tool} version"
        FAILURE="true"
        return
    fi
    
    # extract the version numbers (sepearted by the dots): major.minor.patch
    expected_major_version="$(echo ${expected_version} | cut -d '.' -f1)"
    actual_major_version="$(echo ${actual_version} | cut -d '.' -f1)"

    expected_minor_version="$(echo ${expected_version} | cut -d '.' -f2)"
    actual_minor_version="$(echo ${actual_version} | cut -d '.' -f2)"

    expected_patch_version="$(echo ${expected_version} | cut -d '.' -f3)"
    actual_patch_version="$(echo ${actual_version} | cut -d '.' -f3)"
    
    # Compare major version (different major version are not compatable)
    if (( ${expected_major_version} != ${actual_major_version} )) ; then
        echo_failure "Error: ${tool} ${actual_version} does not meet version requirements ${expected_version}"
        FAILURE="true"
        return
    fi

    # Compare minor versions, they (if they respect rules of versioning) backwards compatable.
    if (( ${expected_minor_version} > ${actual_minor_version} )) ; then
        echo_failure "Error: ${tool} ${actual_version} does not meet version requirements ${expected_version}"
        FAILURE="true"
        return
    fi

    # Finally compare the patch version, the little changes can matter a lot.
    if (( ${expected_patch_version} > ${actual_patch_version} )) ; then
        echo_failure "Error: ${tool} ${actual_version} does not meet version requirements ${expected_version}"
        FAILURE="true"
        return
    fi

    # If we managed to reach this point without failing, congrats, requirements were met
    echo_success "${tool} up to date!"
}

# run the 'verify' function for specified programs
function main {
    verify "git"     "2.0.0"  "git --version | cut -d ' ' -f3"
    verify "just"    "0.10.0" "just --version | cut -d ' ' -f2"
    verify "kubectl" "1.21.0" "kubectl version | grep 'Client Version' | cut -d ':' -f5 | cut -d '\"' -f2 | sed 's/v//g'"
    verify "node"    "16.0.0" "node --version | sed 's/v//g'"
    verify "npm"     "8.0.0"  "npm --version"
    verify "pip"     "20.0.0" "pip --version | cut -d ' ' -f2"
    verify "python"  "3.8.0"  "python --version | cut -d ' ' -f2"
    verify "yarn"    "1.20.0" "yarn --version"

    # After checking all the programs, did any of them fail? 
    if [ "${FAILURE}" != "false" ]; then
        # Then we did not meet overall requirements
        echo_failure "Error: not all tools were up to date"
        exit 1
    fi
}

main
