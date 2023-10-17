#!/bin/bash

# Copyright (C) 2023 RES IT srl. All rights reserved.
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

set -e

ProgName=$(basename $0)
  
sub_help(){
    echo "Usage: $ProgName <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    generate-keys      Generates private and public keys to be used to sign secrets"
    echo "    register-secrets   Signs the secrets and uploads them to Jenres API into the secrets repository"
    echo ""
    echo "For help with each subcommand run:"
    echo "$ProgName <subcommand> -h|--help"
    echo ""
}
  
sub_generate_keys(){
    echo "Running generate-keys command"
    
    mkdir -p .jenres
    
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4092 -outform pem -out .jenres/jenres_rsa_private.pem
    openssl pkey -in .jenres/jenres_rsa_private.pem -pubout -out .jenres/jenres_rsa_public.pem

    cp .jenres/jenres_rsa_public.pem .jenres/pub.key

    # add .jenres/jenres_rsa_public.pem and .jenres/jenres_rsa_private.pem to gitignore file if not already there
    if ! grep -q ".jenres/jenres_rsa_public.pem" .gitignore; then
        echo ".jenres/jenres_rsa_public.pem" >> .gitignore
    fi

    if ! grep -q ".jenres/jenres_rsa_private.pem" .gitignore; then
        echo ".jenres/jenres_rsa_private.pem" >> .gitignore
    fi

    # perform git add on .gitignore and .jenres/pub.key
    git add .gitignore .jenres/pub.key

    echo "Keys generated and the public key has been added to Git index."
    echo "Now you should review the changes, commit and push them."
}
  
sub_register_secrets(){
    echo "Running register-secrets command"
        # Function to generate the secret and signature
    generate_secret(){
        openai_api_key=$1

        # Generate the secret
        secret="{\"openai_api_key\":\"$openai_api_key\"}"

        echo $secret
    }

    # Function to generate the secret and signature
    generate_signature(){
        private_key_path=$1
        secret=$2

        # Generate the signature
        signature=$(echo -n $secret | openssl dgst -sha256 -sign $private_key_path | openssl enc -base64 | tr -d '\n')

        echo $signature
    }

    # Function to update the secret using curl
    update_secret(){
        url=$1
        repository=$2
        secret=$3
        signature=$4

        # Check if all parameters are provided
        if [ -z "$url" ] || [ -z "$repository" ] || [ -z "$secret" ] || [ -z "$signature" ]; then
            echo "Usage: update_secret <url> <repository> <secret> <signature>"
            return 1
        fi

        # $secret and $signature are not escaped, create the escaped versions
        escaped_secret=$(echo $secret | sed 's/"/\\"/g')
        escaped_signature=$(echo $signature | sed 's/"/\\"/g')

        # Use curl to update the secret
        response=$(curl -X PUT -H "Content-Type: application/json" -d "{\"secret\":\"$escaped_secret\",\"signature\":\"$escaped_signature\"}" $url/$repository )

        # Print the response
        echo "Response:"
        echo "${response}"
    }

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
            --url)
                url="$2"
                shift # past argument
                shift # past value
                ;;
            --private-key)
                private_key_path="$2"
                shift # past argument
                shift # past value
                ;;
            --repo)
                repository="$2"
                shift # past argument
                shift # past value
                ;;
            -h|--help)
                echo "Usage: $0 [--url <url>] [--private-key <private_key_path>] [--repo <repository>]"
                echo ""
                echo "Options:"
                echo "  --url          URL of the secrets API. Default is 'https://jenres-api.aws.res-it.com/secrets'."
                echo "  --private-key  Path to the private key file. Default is '.jenres/jenres_rsa_private.pem'."
                echo "  --repo         Name of the repository. If not provided, it will be extracted from the git remote URL."
                echo "  -h, --help     Show this help message."
                exit 0
                ;;
            *)    # unknown option
                shift # past argument
                ;;
        esac
    done

    # Set defaults if parameters were not provided
    url=${url:-"https://jenres-api.aws.res-it.com/secrets"}
    private_key_path=${private_key_path:-".jenres/jenres_rsa_private.pem"}

    # If the repository parameter was not provided, extract the repository name from the git remote URL
    if [ -z "$repository" ]; then
        git_url=$(git remote -v | head -n1 | awk '{print $2}')
        if [[ $git_url == https://github.com/* ]]; then
            repository=${git_url#https://github.com/}
            repository=${repository%.git}
        elif [[ $git_url == git@github.com:* ]]; then
            repository=${git_url#git@github.com:}
            repository=${repository%.git}
        else
            echo "Could not extract repository name from git remote URL. Please provide it as a parameter."
            exit 1
        fi
    fi
    read -p "Enter OPENAI_API_KEY: " openai_api_key

    # Generate the secret and signature
    secret=$(generate_secret $openai_api_key)
    signature=$(generate_signature $private_key_path $secret)

    # Print a summary of the parameters
    echo "URL: $url"
    echo "Private Key Path: $private_key_path"
    echo "Repository: $repository"
    echo "OPENAI_API_KEY: $openai_api_key"

    # Ask for confirmation before uploading
    read -p "Are you sure you want to upload these secrets? (y/n) " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        # Update the secret
        update_secret $url $repository $secret $signature
    else
        echo "Aborted."
        exit 1
    fi
}
  
subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        # replace "-" with "_" for subcommand function name
        subcommand_fun=${subcommand//-/_}
        sub_${subcommand_fun} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo "       Run '$ProgName --help' for a list of known subcommands." >&2
            exit 1
        fi
        ;;
esac
