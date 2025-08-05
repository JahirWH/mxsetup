# mxsetup

A simple script to set up and export your personal MX Linux environment.

---

Un script simple para configurar y exportar tu entorno personal en MX Linux.

##  What is this? / ¿Qué es esto?

`mxprofile.sh` is my personal configuration script for MX Linux.  
It sets up packages, aliases, terminal configs, and more — or exports your current setup for backup or transfer.

`mxprofile.sh` es mi script personal para MX Linux.  
Instala paquetes, alias, configuraciones de terminal, o exporta tu sistema actual para respaldo o copiar en otra PC.

## ⚙️ How to use / Cómo usar

### Fast install, copy and paste 

```
wget -O - https://raw.githubusercontent.com/JahirWH/mxsetup/mxprofile.sh | bash

```

### or
1. **Clone this repo / Clona este repositorio**  
   ```bash
   git clone https://github.com/yourusername/mxsetup.git
   cd mxsetup

2. ## Run the script / Ejecuta el script
```
./mxprofile.sh

```
(sudo chmod +x mxprofile.sh (optional))

# What it does / ¿Qué hace?
- Installs your essential packages / Instala tus paquetes esenciales
- Applies terminal configs (Kitty, Zellij, etc.) / Aplica configuraciones de terminal
- Sets aliases and variables / Añade alias y variables de entorno
- Saves your system setup / Guarda tu sistema para futuras instalaciones

## Goal / Objetivo
- Make it easy to replicate or share your exact MX Linux setup — clean, fast, and personal.
- Hacer fácil replicar o compartir tu configuración MX Linux — limpio, rápido y personalizado.

## Customize it 
Edit mxprofile.sh to match your style.