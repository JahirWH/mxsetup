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
    echo "     (paquetes + configuración)"
    echo ""
    echo "  2) 📤 Exportar configuración actual"
    echo "     (paquetes + terminal + Python + fuentes + temas)"
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

# Función para restaurar configuraciones de terminal
restaurar_terminal() {
    echo ""
    echo "💻 Restaurando configuraciones de terminal..."
    echo "------------------------------------------"
    
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

# Función para restaurar entorno Python
restaurar_python() {
    echo ""
    echo " Configurando entorno Python..."
    echo "-------------------------------"
    
    if [ -f "python/requirements.txt" ]; then
        echo " Creando entorno virtual en ~/.venv"
        python3 -m venv ~/.venv
        source ~/.venv/bin/activate
        pip install -r python/requirements.txt
        deactivate
        echo "✅ Entorno Python configurado en ~/.venv"
    else
        echo "⚠️  No se encontró python/requirements.txt"
        echo "    Saltando configuración de Python..."
    fi
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
        restaurar_terminal
        restaurar_temas
        restaurar_python
        
        echo ""
        echo "🎉 ¡Entorno instalado correctamente!"
        echo "=================================="
        echo "💡 Reinicia tu terminal para aplicar todos los cambios"
        ;;
        
    2)
        echo ""
        echo "📋 Iniciando exportación de configuración..."
        echo "==========================================="
        
        exportar_terminal
        exportar_python
        exportar_temas
        exportar_paquetes
        
        echo ""
        echo "🎉 ¡Exportación completada!"
        echo "========================="
        echo "📁 Revisa los archivos generados en el directorio actual"
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