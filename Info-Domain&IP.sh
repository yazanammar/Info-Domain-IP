#!/bin/bash

# -----------------------------------------------------------------------------
# Script: DNS Recon Tool
# Author: (Yazan Ammar)
# Version: 2.0 (Fully Functional & Refactored)
# Description: A wrapper for various DNS enumeration tools.
# -----------------------------------------------------------------------------

# --- CONSTANTS & COLORS ---
readonly GREEN=$(tput setaf 2)
readonly YELLOW=$(tput setaf 3)
readonly BLUE=$(tput setaf 4)
readonly RED=$(tput setaf 1)
readonly PURPLE=$(tput setaf 5)
readonly CYAN=$(tput setaf 6)
readonly RESET=$(tput sgr0)

# --- HELPER FUNCTIONS ---
# These functions help us avoid repeating code for printing messages.

print_error() {
    # Prints a message in red to the standard error stream.
    echo "${RED}[ERROR] $1${RESET}" >&2
}

print_info() {
    # Prints an informational message.
    echo "${CYAN}[INFO] $1${RESET}"
}

print_success() {
    # Prints a success message in green.
    echo "${GREEN}[SUCCESS] $1${RESET}"
}

ensure_command_exists() {
    command -v "$1" >/dev/null 2>&1 || { print_error "$1 is required but not installed. Please install it."; exit 1; }
}

# --- UI FUNCTIONS ---

display_banner() {
    clear
    echo -n " Loading: ["
    for i in {1..20}; do echo -n "${GREEN}#${RESET}"; sleep 0.05; done
    echo "]${GREEN} 100%${RESET}"
    echo " "
    # Using a Heredoc for the banner makes it much cleaner to write and edit.
    cat << EOF
 ${YELLOW}-------- 
< De3fult >
 --------${RESET}
   \\
    \\\\
     \\\\   .--.
       |o_o |
       |:_/ |
      //   \\ \\
     (|     | )
    /'\\_   _/\\\`\\
    \\___)=(___/

EOF
    print_success "Started successfully"
    echo ""
}

display_main_menu() {
    echo "${GREEN}* Welcome to the comprehensive tool for DNS information gathering.${RESET}"
    echo "* Please select from the list below:"
    cat << EOF

 ${YELLOW}[1] ==> [Forward-Lookup]${RESET}
 ${YELLOW}[2] ==> [Reverse-Lookup]${RESET}
 ${YELLOW}[3] ==> [Zone-Transfers]${RESET}
 ${YELLOW}[4] ==> [All...]${RESET}
 ${YELLOW}[5] ==> [More-Information]${RESET}

EOF
}

# --- LOGIC FUNCTIONS ---
# Each main menu option gets its own function. This is the core of clean code.

handle_forward_lookup() {
    print_info "You Chose ==> [Forward-Lookup]"
    read -p "Enter Target Domain (e.g., google.com): " domain
    echo ""
    
    cat << EOF
What Tool Do You Want To Use?

 [1] ==> [Host]
 [2] ==> [Dig]
 [3] ==> [nslookup]
 [4] ==> [Brute-Force On Subdomains]

EOF
    read -p "Enter The Number: " tool_choice
    echo ""

    case $tool_choice in
        1)
            print_info "Using [Host] Tool"
            host "$domain"
            ;;
        2)
            print_info "Using [Dig] Tool"
            dig "$domain"
            dig AAAA "$domain" | grep "AAAA"
            ;;
        3)
            print_info "Using [nslookup] Tool"
            nslookup "$domain"
            ;;
        4)
            print_info "Using [Brute-Force On Subdomains]"
            read -p "Please Enter The Wordlist Path: " wordlist
            if [[ ! -f "$wordlist" ]]; then
                print_error "Wordlist file not found at '$wordlist'"
                return 1 # Exit the function with an error
            fi
            echo ""
            print_info "Brute force attack is underway..."
            for sub in $(cat "$wordlist"); do 
                host -t A "$sub.$domain" | grep -v "not found"
            done
            ;;
        *)
            print_error "Invalid tool choice."
            ;;
    esac
}

handle_reverse_lookup() {
    print_info "You Chose ==> [Reverse-Lookup]"
    read -p "Enter Target IPv4 or IPv6: " reverse
    echo ""

    cat << EOF
What Tool Do You Want To Use?

 [1] ==> [Host]
 [2] ==> [Dig]
 [3] ==> [nslookup]
 [4] ==> [Brute-Force On Subdomains]

EOF
    read -p "Enter The Number: " tool_choice
    echo ""
    
    case $tool_choice in
        1)
            print_info "Using [Host] Tool"
            host -t PTR "$reverse"
            ;;
        2)
            print_info "Using [Dig] Tool"
            dig -x "$reverse"
            ;;
        3)
            print_info "Using [nslookup] Tool"
            nslookup "$reverse"
            ;;
        4)
            print_info "This section is still under development."
            ;;
        *)
            print_error "Invalid tool choice."
            ;;
    esac
}

handle_zone_transfers() {
    print_info "You Chose ==> [Zone-Transfers]"
    read -p "Enter Target Domain: " domain
    read -p "Enter Target Name Server (e.g., ns1.google.com): " nameserver
    echo ""

    cat << EOF
What Tool Do You Want To Use?

 [1] ==> [Host]
 [2] ==> [Dig]
 [3] ==> [Dnsrecon]
 [4] ==> [Dnsenum]
 [5] ==> [Fierce]

EOF
    read -p "Enter The Number: " tool_choice
    echo ""

    case $tool_choice in
        1) ensure_command_exists "host"; print_info "Using [Host]"; host -l "$domain" "$nameserver" ;;
        2) ensure_command_exists "dig"; print_info "Using [Dig]"; dig axfr "$domain" @"$nameserver" ;;
        3) ensure_command_exists "dnsrecon"; print_info "Using [Dnsrecon]"; dnsrecon -d "$domain" -t axfr ;;
        4) ensure_command_exists "dnsenum"; print_info "Using [Dnsenum]"; dnsenum --enum "$domain" ;;
        5) ensure_command_exists "fierce"; print_info "Using [Fierce]"; fierce --domain "$domain" ;;
        *) print_error "Invalid tool choice." ;;
    esac
}

handle_all() {
    print_info "You Chose ==> [All...]"
    echo "${RED}Note: This field is not fully created so you may encounter some errors !!${RESET}"
    read -p "Enter Target Domain: " domain
    read -p "Enter Target IPv4/IPv6: " reverse
    read -p "Enter Target Name Server: " nameserver
    
    # An array of commands to run
    commands=(
        "host $domain"
        "nslookup $domain"
        "host -t PTR $reverse"
        "nslookup $reverse"
        "host -l $domain $nameserver"
        "dig axfr $domain @$nameserver"
        "dnsrecon -d $domain -t axfr"
        "fierce --domain $domain"
        "dnsenum --enum $domain"
    )

    for cmd in "${commands[@]}"; do
        echo "${YELLOW}==================================================${RESET}"
        print_info "Running command: $cmd"
        # The 'eval' command executes the command stored in the string
        eval "$cmd"
    done
    echo "${YELLOW}==================================================${RESET}"
}


handle_more_info() {
    cat << EOF

${YELLOW}--------------------------${RESET}
 Tool Maker ${YELLOW}:==>${RESET} ${CYAN}[De3fult]${RESET}
${YELLOW}--------------------------${RESET}

 ${PURPLE}* Social Media :${RESET}
 ${PURPLE}================${RESET}

 ${GREEN}GitHub${RESET}    ==> https://github.com/YazanAmmar
 ${BLUE}Telegram${RESET}  ==> https://t.me/Yazan_Amar
 ${RED}TryHackMe${RESET} ==> https://tryhackme.com/r/p/De3fult
 ${CYAN}Twitter${RESET}   ==> https://x.com/Yazan_o_ammar

 The Tool Version : ${GREEN}V1.0${RESET}
 Date of creation : ${GREEN}17/1/2025${RESET}

EOF
}

# --- SCRIPT EXECUTION ---

# 1. Check for the most basic tools first
ensure_command_exists "tput"

# 2. Display UI
display_banner
display_main_menu

# 3. Get User Input
read -p "Enter The Number: ${GREEN}${RESET}" number
echo "" # Newline for cleaner output

# 4. Handle User Choice using the main router (case statement)
case $number in
    1) handle_forward_lookup ;;
    2) handle_reverse_lookup ;;
    3) handle_zone_transfers ;;
    4) handle_all ;;
    5) handle_more_info ;;
    *) print_error "Invalid selection. Please choose a number from 1 to 5." ;;
esac

echo ""
print_success "Tool finished."
exit 0
