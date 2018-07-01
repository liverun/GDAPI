#!/bin/bash

# Constants
api_url="https://api.godaddy.com/v1/"

# comma-separated list of name servers, spaces allowed
# at least 2 name servers are normally required
# set your desired ame servers here
name_servers="ns1.sedoparking.com,  ns2.sedoparking.com"


# fetch the current path, no matter where the script is called from
current_dir=$(dirname $(readlink -f "$0"))
echo $current_dir

# keep credentials in an external file - should reside in the same directory as the script
cred_file="$current_dir/gdapi.creds"

if [ ! -f "$cred_file" ]; then
	echo "Error: credentials file missing (expected location: $cred_file)"
    echo "=> Please create a file named gdapi.creds in the same directory of the script"
    echo "with 2 lines as follows:"
    echo ""
    echo "gd_key=\"Your key API here\""
    echo "gd_secret=\"Your secret for API here\""
    exit 1
else
    # import credentials from file
    echo "Using credentials file: $cred_file"
    source "$cred_file"
fi

# set HTTP header with credentials
headers="Authorization: sso-key $gd_key:$gd_secret"


# if the domain name was not provided in parameter
if [ -z $1 ]; then
	echo -n "Enter domain name: "
	read domain
else
	domain=$1
fi

if [ -z $domain ]; then
	echo "Domain name may not be blank, exit"
	exit 1
fi

while true; do
	options=("Change domain name (current: $domain)" "Get domain info incl. EPP code" "Set name servers, unlock and disable auto-renew" "Exit")

	echo -e "\nChoose an option: "
	select opt in "${options[@]}"; do
		case $REPLY in
			1) domain=""
			while [ -z $domain ]; do
				echo -n "Enter domain name: "
				read domain
			done
		break ;;

			2) echo "Fetching domain info ($domain)..."

			# send query
			result=$(curl --silent --include -X GET -H "$headers" -H "Content-Type: application/json" -H "Accept: text/xml" "$api_url/domains/$domain")
			# uncomment below to see Curl response
			echo "$result"
			# extract EPP code from XML response
			epp_code=$(echo $result | grep -Po '<authCode>.*</authCode>' | sed 's/<\/*authCode>//g')
			echo -e "\nEPP code: $epp_code\n"
		break ;;

			3) echo "Set name servers, unlock domain name and disable auto-renew ($domain)...";
			# parse list of name servers (build list)
			ns_list=$(echo "$name_servers" | sed 's/,\s*/", "/g')

			request="{ \"locked\": false, \"nameServers\": [ \"$ns_list\" ], \"renewAuto\": false, \"subaccountId\": \" \" }"

			# send request
			result=$(curl --silent --include -X PATCH -H "$headers" -H "Content-Type: application/json" -H "Accept: text/xml" -d "$request" "https://api.godaddy.com/v1/domains/$domain")
			echo "$result"
		break ;;

			4) exit 0;
		break ;;

		*) echo "Invalid option"
		;;
		esac
	done
done
