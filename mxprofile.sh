#!/bin/bash
set -e

# ===============================================
# MXProfile - Gestor de entorno personalizado
# ===============================================

CONFIG_PATH=$(pwd)
PACKAGES_FILE="$CONFIG_PATH/packages/base.txt"

# Función para mostrar el menú principal
mostrar_menu() {
    echo ""
    echo "🏠 MXProfile - Gestor de entorno personalizado"
    echo "=============================================="
    echo ""
    echo "¿Qué deseas hacer?"
    echo ""
    echo "  1) 📥 Instalar entorno completo"
    echo "     (paquetes + configuración + pihole + networks)"
    echo ""
    echo "  2) 📤 Exportar configuración actual"
    echo "     (paquetes + terminal + Python + fuentes + temas + pihole + networks)"
    echo ""
    echo "  3) 🚪 Salir"
    echo ""
    echo "=============================================="
}

# Función para instalar paquetes
instalar_paquetes() {
    echo ""
    echo "📦 Instalando paquetes del sistema..."
    echo "-----------------------------------"
    
    if [ -f "$PACKAGES_FILE" ]; then
        echo " Leyendo lista de paquetes desde: $PACKAGES_FILE"
        xargs -a "$PACKAGES_FILE" sudo apt install -y
        echo " Paquetes instalados correctamente"
    else
        echo "  Archivo no encontrado: $PACKAGES_FILE"
        echo "    Saltando instalación de paquetes..."
    fi
}

# Función para configurar archivos de sistema
configurar_archivos_sistema() {
    echo ""
    echo " Configurando archivos del sistema..."
    echo "------------------------------------"
    
    # Crear directorios necesarios
    echo " Creando directorios de configuración..."
    mkdir -p ~/.config/kitty ~/.config/zellij ~/.config/neofetch ~/.config/btop
    
    # Enlazar archivos de configuración principales
    echo "🔗 Enlazando archivos de configuración..."
    ln -sf "$CONFIG_PATH/configs/bash/.bashrc" ~/.bashrc
    ln -sf "$CONFIG_PATH/configs/zsh/.zshrc" ~/.zshrc
    ln -sf "$CONFIG_PATH/configs/kitty/kitty.conf" ~/.config/kitty/kitty.conf
    ln -sf "$CONFIG_PATH/configs/conky/conky.conf" ~/.conkyrc
    ln -sf "$CONFIG_PATH/configs/zellij/config.kdl" ~/.config/zellij/config.kdl
    
    echo "✅ Enlaces simbólicos creados"
}

# Función para restaurar configuraciones de shell
restaurar_shell() {
    echo ""
    echo "🐚 Restaurando configuraciones de shell..."
    echo "--------------------------------------"
    
    mkdir -p ~/.config/shell
    cp configs/bash/.bashrc ~/ 2>/dev/null || true
    cp configs/zsh/.zshrc ~/ 2>/dev/null || true
    
    echo "✅ Configuraciones de shell restauradas"
}

# Función para restaurar configuraciones de terminal
restaurar_terminal() {
    echo ""
    echo "💻 Restaurando configuraciones de terminal..."
    echo "------------------------------------------"
    
    mkdir -p ~/.config/kitty ~/.config/zellij ~/.config/neofetch ~/.config/btop
    
    cp configs/kitty/kitty.conf ~/.config/kitty/ 2>/dev/null || true
    cp configs/zellij/config.kdl ~/.config/zellij/ 2>/dev/null || true
    cp configs/neofetch/config.conf ~/.config/neofetch/ 2>/dev/null || true
    cp configs/btop/btop.conf ~/.config/btop/ 2>/dev/null || true
    cp configs/conky/conky.conf ~/.conkyrc 2>/dev/null || true
    
    echo "✅ Configuraciones de terminal restauradas"
}

# Función para restaurar temas y fuentes
restaurar_temas() {
    echo ""
    echo "🎨 Restaurando temas, iconos y fuentes..."
    echo "--------------------------------------"
    
    mkdir -p ~/.themes ~/.icons ~/.fonts
    
    if [ -d "$CONFIG_PATH/themes" ]; then
        cp -r themes/* ~/.themes/
        echo "✅ Temas restaurados"
    fi
    
    if [ -d "$CONFIG_PATH/icons" ]; then
        cp -r icons/* ~/.icons/
        echo "✅ Iconos restaurados"
    fi
    
    if [ -d "$CONFIG_PATH/fonts" ]; then
        cp -r fonts/* ~/.fonts/
        echo "✅ Fuentes restauradas"
    fi
}

# Función para restaurar configuraciones de pihole
restaurar_pihole() {
    echo ""
    echo "🔒 Restaurando configuraciones de pihole..."
    echo "--------------------------------------"
    
    if [ -d "$CONFIG_PATH/configs/pihole" ]; then
        sudo cp -r configs/pihole/* /etc/pihole/ 2>/dev/null || true
        # sudo cp configs/pihole/resolved.conf /etc/systemd/resolved.conf 2>/dev/null || true
        echo "✅ Configuraciones de pihole restauradas"
        # Eliminacion db de pihole para evitar conflictos

    
    else
        echo "⚠️  Directorio de pihole no encontrado"
        echo "    Saltando restauración..."
    fi
}

# Función para restaurar configuraciones de networks
restaurar_networks() {
    echo ""
    echo "🌐 Restaurando configuraciones de networks..."
    echo "--------------------------------------"
    
    if [ -d "$CONFIG_PATH/configs/networks" ]; then
        sudo cp -r configs/networks/* /etc/network/ 2>/dev/null || true
        sudo cp configs/networks/resolv.conf /etc/resolv.conf 2>/dev/null || true
        echo "✅ Configuraciones de networks restauradas"
    else
        echo "⚠️  Directorio de networks no encontrado"
        echo "    Saltando restauración..."
    fi
}

# Función para restaurar entorno Python
restaurar_python() {
    echo ""
    echo "🐍 Restaurando entorno Python..."
    echo "-------------------------------"
    
    if [ -f "python/requirements.txt" ]; then
        echo " Creando entorno virtual en ~/.venv"
        python3 -m venv ~/.venv
        echo " Instalando dependencias..."
        ~/.venv/bin/pip install -r python/requirements.txt
        echo "✅ Entorno Python configurado en ~/.venv"
        echo "   💡 Actívalo con: source ~/.venv/bin/activate"
    else
        echo "⚠️  No se encontró python/requirements.txt"
        echo "    Saltando configuración de Python..."
    fi
}

# Función para exportar configuraciones de shell
exportar_shell() {
    echo ""
    echo "🐚 Exportando configuraciones de shell..."
    echo "--------------------------------------"
    
    mkdir -p configs/bash configs/zsh
    
    cp ~/.bashrc configs/bash/.bashrc 2>/dev/null || true
    cp ~/.zshrc configs/zsh/.zshrc 2>/dev/null || true
    
    # Advertencia de seguridad
    echo ""
    echo "⚠️  ADVERTENCIA DE SEGURIDAD:"
    echo "    Revisa los archivos exportados en configs/bash/ y configs/zsh/"
    echo "    Pueden contener credenciales, API keys, o variables sensibles"
    echo "    ❌ NO los subas a control de versión público sin revisar"
    echo ""
    
    chmod 600 configs/bash/.bashrc configs/zsh/.zshrc 2>/dev/null || true
    echo "✅ Configuraciones de shell exportadas (permisos: 600)"
}

# Función para exportar configuraciones de terminal
exportar_terminal() {
    echo ""
    echo "💻 Exportando configuraciones de terminal..."
    echo "------------------------------------------"
    
    mkdir -p configs/kitty configs/zellij configs/conky configs/neofetch configs/btop
    
    cp ~/.config/kitty/kitty.conf configs/kitty/ 2>/dev/null || true
    cp ~/.config/zellij/config.kdl configs/zellij/ 2>/dev/null || true
    cp ~/.conkyrc configs/conky/conky.conf 2>/dev/null || true
    cp ~/.config/neofetch/config.conf configs/neofetch/ 2>/dev/null || true
    cp ~/.config/btop/btop.conf configs/btop/ 2>/dev/null || true
    
    echo "✅ Configuraciones de terminal exportadas"
}

# Función para exportar configuraciones de pihole
exportar_pihole() {
    echo ""
    echo "🔒 Exportando configuraciones de pihole..."
    echo "--------------------------------------"
    
    mkdir -p configs/pihole
    
    if [ -d "/etc/pihole" ]; then
        # Copiar SOLO archivos de configuración, EXCLUYENDO bases de datos
        sudo cp -r /etc/pihole/* configs/pihole/ 2>/dev/null || true
        
        # IMPORTANTE: Cambiar propietario para que sea accesible sin sudo
        sudo chown -R $(whoami):$(whoami) configs/pihole/ 2>/dev/null || true
        
        # Establecer permisos seguros pero legibles
        sudo chmod -R 600 configs/pihole/* 2>/dev/null || true
        sudo chmod 700 configs/pihole/ 2>/dev/null || true
        
        # ELIMINAR archivos sensibles que contienen datos personales
        rm -f configs/pihole/pihole-FTL.db 2>/dev/null || true
        rm -f configs/pihole/gravity.db 2>/dev/null || true
        rm -f configs/pihole/*.log 2>/dev/null || true
        
        echo "✅ Configuraciones de pihole exportadas (bases de datos excluidas)"
    else
        echo "⚠️  Directorio /etc/pihole no encontrado"
        echo "    Saltando exportación..."
    fi
}

# Función para exportar configuraciones de networks
exportar_networks() {
    echo ""
    echo "🌐 Exportando configuraciones de networks..."
    echo "--------------------------------------"
    
    mkdir -p configs/networks
    
    if [ -d "/etc/NetworkManager/conf.d" ]; then
        sudo cp -r /etc/NetworkManager/conf.d/* configs/networks/ 2>/dev/null || true
        sudo chown -R $(whoami):$(whoami) configs/networks/ 2>/dev/null || true
        chmod 600 configs/networks/* 2>/dev/null || true
    fi
    
    if [ -f "/etc/network/interfaces" ]; then
        sudo cp /etc/network/interfaces configs/networks/ 2>/dev/null || true
        sudo chown $(whoami):$(whoami) configs/networks/interfaces 2>/dev/null || true
        chmod 600 configs/networks/interfaces 2>/dev/null || true
    fi
    
    # NO EXPORTAR resolv.conf (información de DNS) ni system-connections (credenciales WiFi)
    # resolv.conf es dinámico y suele cambiarse
    # system-connections contiene contraseñas en texto plano
    
    echo "✅ Configuraciones de networks exportadas"
    echo "   ℹ️  Nota: system-connections (WiFi/VPN) NO se exportan por seguridad"
}

# Función para exportar entorno Python
exportar_python() {
    echo ""
    echo "🐍 Exportando entorno Python..."
    echo "-----------------------------"
    
    mkdir -p python
    
    if [ -n "$VIRTUAL_ENV" ]; then
        pip freeze > python/requirements.txt
        echo "✅ Entorno Python exportado desde: $VIRTUAL_ENV"
    else
        echo "⚠️  No hay entorno virtual activo"
        echo "    💡 Tip: Activa tu virtualenv si quieres exportarlo"
    fi
}

# Función para exportar temas y fuentes
exportar_temas() {
    echo ""
    echo "🎨 Exportando temas, iconos y fuentes..."
    echo "-------------------------------------"
    
    mkdir -p themes icons fonts
    
    if [ -d ~/.themes ]; then
        cp -r ~/.themes/* themes/ 2>/dev/null || true
        echo "✅ Temas exportados"
    fi
    
    if [ -d ~/.icons ]; then
        cp -r ~/.icons/* icons/ 2>/dev/null || true
        echo "✅ Iconos exportados"
    fi
    
    if [ -d ~/.fonts ]; then
        cp -r ~/.fonts/* fonts/ 2>/dev/null || true
        echo "✅ Fuentes exportadas"
    fi
}

# Función para exportar lista de paquetes
exportar_paquetes() {
    echo ""
    echo "📦 Exportando lista de paquetes..."
    echo "--------------------------------"
    
    mkdir -p "$CONFIG_PATH/packages"
    
    comm -23 \
        <(apt-mark showmanual | sort) \
        <(gzip -dc /var/log/installer/initial-status.gz | awk '/Package: / {print $2}' | sort) \
        > "$PACKAGES_FILE"
    
    echo "✅ Lista de paquetes guardada en: $PACKAGES_FILE"
}

# ===============================================
# PROGRAMA PRINCIPAL
# ===============================================

mostrar_menu
read -p "Selecciona una opción [1-3]: " opcion

case "$opcion" in
    1)
        echo ""
        echo "🚀 Iniciando instalación del entorno..."
        echo "======================================"
        
        instalar_paquetes
        configurar_archivos_sistema
        restaurar_shell
        restaurar_terminal
        restaurar_temas
        restaurar_python
        restaurar_pihole
        restaurar_networks
        
        echo ""
        echo "🎉 ¡Entorno instalado correctamente!"
        echo "=================================="
        echo "💡 Reinicia tu terminal para aplicar todos los cambios"
        ;;
        
    2)
        echo ""
        echo "📋 Iniciando exportación de configuración..."
        echo "==========================================="
        
        exportar_shell
        exportar_terminal
        exportar_python
        exportar_temas
        exportar_paquetes
        exportar_pihole
        exportar_networks
        
        echo ""
        echo "🎉 ¡Exportación completada!"
        echo "========================="
        echo "📁 Revisa los archivos generados en el directorio actual"
        echo ""
        echo "⚠️  IMPORTANTE - Revisión de seguridad:"
        echo "   1. Revisa configs/bash/.bashrc y configs/zsh/.zshrc"
        echo "   2. Busca y ELIMINA: API keys, tokens, contraseñas"
        echo "   3. NO subas a GitHub sin revisar"
        echo "   4. Los archivos de credenciales WiFi NO se exportan por seguridad"
        ;;
        
    3)
        echo ""
        echo "👋 ¡Hasta luego!"
        exit 0
        ;;
        
    *)
        echo ""
        echo "❌ Opción no válida"
        echo "💡 Por favor, selecciona una opción del 1 al 3"
        exit 1
        ;;
esac