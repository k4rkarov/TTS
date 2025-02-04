#!/bin/bash

# ----------------
# - by @k4rkarov -
# ----------------

function show_help() {
    echo "Usage: $0 [-h|--help] [-d|--domain DOMAIN] [-n|--number NUMBER] [-l|--language LANGUAGE] [-f|--fullname]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message and exit."
    echo "  -d, --domain        Specify the email domain (default: @domain.com)."
    echo "  -n, --number        Specify the number of emails to generate (default: 10)."
    echo "  -l, --language      Specify the language for names. Options:"
    echo "                      american (default), brazilian, spanish, french, russian, german."
    echo "  -f, --fullname      Use 'name.surname@domain' format for email generation."
}

# Default values
DOMAIN="@domain.com"
NUMBER=10
LANGUAGE="american"
FULLNAME=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--domain)
            if [[ -n $2 ]]; then
                DOMAIN="$2"
                shift 2
            else
                echo "Error: --domain requires a value."
                exit 1
            fi
            ;;
        -n|--number)
            if [[ $2 =~ ^[0-9]+$ ]]; then
                NUMBER="$2"
                shift 2
            else
                echo "Error: --number requires a numeric value."
                exit 1
            fi
            ;;
        -l|--language)
            if [[ -n $2 ]]; then
                LANGUAGE="$2"
                shift 2
            else
                echo "Error: --language requires a value."
                exit 1
            fi
            ;;
        -f|--fullname)
            FULLNAME=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Name lists
declare -A NAMES
NAMES=(
    ["american"]="john|jane|paul|emily|michael|sarah|james|elizabeth|robert|linda"
    ["brazilian"]="joao|maria|pedro|ana|lucas|fernanda|gabriel|juliana|rafael|camila"
    ["spanish"]="carlos|marta|juan|luisa|diego|sofia|javier|ines|pablo|alicia"
    ["french"]="pierre|marie|luc|camille|antoine|lea|julien|chloe|alexandre|manon"
    ["russian"]="ivan|anna|dmitry|maria|nikolai|elena|sergei|olga|alexei|tatyana"
    ["german"]="hans|anna|karl|lisa|friedrich|maria|otto|sophie|wolfgang|katharina"
)

declare -A SURNAMES
SURNAMES=(
    ["american"]="smith|johnson|brown|williams|jones|miller|davis|garcia|rodriguez|martinez"
    ["brazilian"]="silva|souza|oliveira|pereira|santos|rocha|costa|lima|almeida|ribeiro"
    ["spanish"]="gomez|rodriguez|lopez|martinez|hernandez|gonzalez|perez|sanchez|ramirez|torres"
    ["french"]="dupont|durand|moreau|laurent|lefevre|martin|girard|clerc|renard|roux"
    ["russian"]="ivanov|petrov|sidorov|smirnov|kovalev|mikhailov|novikov|fedorov|volkov|popov"
    ["german"]="müller|schmidt|schneider|fischer|weber|meyer|wagner|becker|schulz|hoffmann"
)

# Validate language
if [[ -z "${NAMES[$LANGUAGE]}" || -z "${SURNAMES[$LANGUAGE]}" ]]; then
    echo "Error: Unsupported language '$LANGUAGE'."
    echo "Supported languages: american, brazilian, spanish, french, russian, german."
    exit 1
fi

# Generate emails
for i in $(seq "$NUMBER"); do
    name=$(echo "${NAMES[$LANGUAGE]}" | tr '|' '\n' | shuf -n1)
    surname=$(echo "${SURNAMES[$LANGUAGE]}" | tr '|' '\n' | shuf -n1)
    
    if $FULLNAME; then
        email="${name}.${surname}${DOMAIN}"
    else
        random_suffix=$(shuf -zer -n3 {a..z} {0..9} | tr -d '\0')
        email="${name}${random_suffix}${DOMAIN}"
    fi

    echo "$email"
done
