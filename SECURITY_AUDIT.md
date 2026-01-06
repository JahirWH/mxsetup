# 🔐 Auditoría de Seguridad - mxprofile.sh

## 🚨 PROBLEMAS CRÍTICOS ENCONTRADOS

### 1. **CRÍTICO: Exportación de Contraseñas de WiFi**

**Ubicación:** Función `exportar_pihole()` línea 200

```bash
sudo cp -r /etc/NetworkManager/system-connections/* configs/pihole/
```

**Problema:**

- Este directorio contiene archivos `.nmconnection` con contraseñas de WiFi/VPN en **TEXTO PLANO**
- Contraseñas de redes inalámbricas almacenadas sin cifrar
- Si se sube a GitHub o se comparte, CUALQUIERA puede obtener las credenciales

**Solución:** ✅ DEBE ELIMINARSE

---

### 2. **CRÍTICO: Base de Datos de Pihole Expuesta**

**Ubicación:** Función `exportar_pihole()` línea 190

```bash
sudo cp -r /etc/pihole/* configs/pihole/
```

**Problema:**

- Contiene `pihole-FTL.db` con historial completo de consultas DNS
- Revela sitios web visitados, direcciones IP, patrones de navegación
- Información personal sensible expuesta

**Solución:** ✅ Se debe excluir la base de datos

---

### 3. **ALTO: Configuración de Resolv.conf Exportada**

**Ubicación:** Función `exportar_pihole()` y `exportar_networks()`

```bash
sudo cp /etc/systemd/resolved.conf configs/pihole/
sudo cp /etc/resolv.conf configs/networks/
```

**Problema:**

- Revela configuración de servidores DNS
- Potencialmente expone información de privacidad y seguridad de red
- Si pihole es personalizado, revela la estrategia de filtrado

**Solución:** ✅ Se debe excluir

---

### 4. **ALTO: Archivos de Configuración de Shell sin Revisar**

**Ubicación:** Función `exportar_shell()`

```bash
cp ~/.bashrc configs/bash/.bashrc
cp ~/.zshrc configs/zsh/.zshrc
```

**Problema:**

- `.bashrc` y `.zshrc` pueden contener:
  - Variables de entorno con API keys
  - Tokens de autenticación
  - Contraseñas en texto plano
  - Credenciales de bases de datos
  - Información sensible en alias y funciones

**Solución:** ✅ Advertencia del usuario + Verificación recomendada

---

### 5. **MEDIO: Falta de Validación de Permisos de Directorios**

**Ubicación:** Directorios exportados

```bash
configs/bash/ configs/zsh/ configs/pihole/ configs/networks/
```

**Problema:**

- Los archivos exportados quedan con permisos legibles por todos
- Si se suben a control de versión, quedan públicamente accesibles
- No se establecen permisos restrictivos (600 o 700)

**Solución:** ✅ Configurar permisos (chmod 600) después de exportar

---

### 6. **MEDIO: Falta de .gitignore**

**Ubicación:** Toda la carpeta `configs/`
**Problema:**

- Si se sube a GitHub, expone toda la información sensible
- No hay protección contra commits accidentales

**Solución:** ✅ Crear `.gitignore` completo

---

## 📊 Resumen de Riesgos

| Severidad  | Elemento             | Riesgo                               |
| ---------- | -------------------- | ------------------------------------ |
| 🔴 CRÍTICO | WiFi Passwords       | Acceso a redes inalámbricas          |
| 🔴 CRÍTICO | pihole-FTL.db        | Historial de navegación completo     |
| 🟠 ALTO    | Resolved.conf        | Exposición de servidores DNS         |
| 🟠 ALTO    | .bashrc/.zshrc       | Credenciales en variables de entorno |
| 🟡 MEDIO   | Permisos de archivos | Acceso no autorizado en el sistema   |
| 🟡 MEDIO   | Sin .gitignore       | Sincronización accidental a GitHub   |

---

## ✅ CAMBIOS A REALIZAR

1. **Eliminar** exportación de `/etc/NetworkManager/system-connections/`
2. **Excluir** `pihole-FTL.db` de exportación (ya está parcialmente hecho)
3. **No exportar** `resolved.conf` y `resolv.conf`
4. **Advertir** al usuario sobre contenido sensible en `.bashrc`/`.zshrc`
5. **Crear .gitignore** para proteger contra sincronización accidental
6. **Cambiar permisos** a 600 en archivos sensibles después de exportar
7. **Documentar** qué no se debe exportar nunca
