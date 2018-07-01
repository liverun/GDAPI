# GDAPI

A collection of simple scripts to manage domain names using the Godaddy API

**Table of Contents**
- [GDAPI](#gdapi)
  - [Introduction](#introduction)
  - [System requirements](#system-requirements)
    - [Linux (bash)](#linux-bash)
    - [Windows (Powershell) - coming soon](#windows-powershell-coming-soon)
  - [Configuration](#configuration)
    - [Obtaining your API key](#obtaining-your-api-key)
    - [Adding your API credentials](#adding-your-api-credentials)
    - [User settings](#user-settings)
  - [Usage](#usage)
  - [Known bugs and limitations](#known-bugs-and-limitations)
    - [Limitations](#limitations)
    - [Bugs](#bugs)


## Introduction

The scripts provided in this package can be used to perform the following actions on domain names that you own, that are registered with **Godaddy**:

- disable auto-renew
- unlock the domain name (required for transfer to another registrar)
- retrieve the EPP code (required for transfer to another registrar)
- set default name servers of your choice
- fetch domain information (creation date, expiration date, domain contacts etc)

These scripts should be convenient for large portfolio holders who want to automate management of their domain name and perform actions in bulk without the need to log in on the Godaddy website.

Bear in mind that this package is more a proof of concept than a full API solution. The main aim is to facilitate transfer out to another registrar, and set default name servers on newly-acquired domain names.

## System requirements

### Linux (bash)

The bash script `gdapi.sh` requires **curl** but otherwise has no particular dependency. It is very likely that curl is already installed on your Linux platform.

To install curl on your system:

`apt-get install curl`

Or use `yum`, `dnf` or `pacman` depending on the flavor of Linux you are using.

### Windows (Powershell) - coming soon

A Powershell version will be made available later for Windows users.

## Configuration

Make the bash file executable ie `chmod +x gdapi.sh`
(if it is not already executable)

Then it can be called from the command line:

`./gdapi.sh`

### Obtaining your API key

Go to this page to create your own API key: https://developer.godaddy.com/getstarted

You will need to log in to proceed with the creation of your API keys.

You will get two Key/Secret pairs, one to use on a test environment, and one to use on production servers.

It is recommended to get familiar with the [API documentation](https://developer.godaddy.com/doc).

### Adding your API credentials

The bash script will look for a file named `gdapi.creds` in the current working directory (wherever `gdapi.sh` resides). This is where you enter your API credentials. The file should contain two lines like this:
```
gd_key="Your key API here"
gd_secret="secret for API"
```

### User settings

In the script proper, you enter the **name servers** that you want to apply on your domain names. Look for the line that reads like this and adapt accordingly:

`name_servers="ns1.sedoparking.com,  ns2.sedoparking.com"`

## Usage

Call the script as follows:

`./gdapi.sh`

or:

`./gdapi.sh domain.com`

The script will prompt you for a domain name if you haven't entered one in the command line.

Sample output:
```
Using credentials file: /home/liverun/dev/GDAPI/gdapi.creds
Enter domain name: test.com

Choose an option:
1) Change domain name (current: test.com)
2) Get domain info incl. EPP code
3) Set name servers, unlock and disable auto-renew
4) Exit
#?
```
Options #1 and #4 are self-explanatory.

Option #2 will fetch domain information including EPP code.

Option #3 will set name servers, unlock the domain name and disable the auto-renew

## Known bugs and limitations

### Limitations

- This API does not grant access to the Godaddy auctions
- For the sake of simplicity there is no elaborate error handling

### Bugs

For some reason the script may return a response like this, even though the changes are carried out:
```
HTTP/1.1 409 Conflict
{"code":"INELIGIBLE_DOMAIN","message":"The domain was not purchased with a subaccount","name":"ApiError"}
```
Maybe this is a problem that affects domain names acquired through auctions.
