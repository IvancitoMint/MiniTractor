# Instalación

Esta guía describe cómo preparar el entorno para ejecutar **MiniTractor**.

El proyecto utiliza **Docker** para encapsular ROS 2, Gazebo y todas las dependencias, por lo que únicamente es necesario instalar las herramientas básicas en el sistema operativo anfitrión.

Actualmente se soportan los siguientes sistemas:

- Debian 13 o superior
- Ubuntu 22.04 o superior
- Fedora 40 o superior
- Windows 11 (Docker Desktop + WSL2)
- macOS (Intel y Apple Silicon)

---

# Requisitos

Antes de comenzar verifica que tienes:

- Git
- Docker
- Docker Compose

---

# 1. Instalar Git

Verifica si Git ya está instalado:

```bash
git --version
```

Si no lo está:

### Debian / Ubuntu

```bash
sudo apt install git
```

### Fedora

```bash
sudo dnf install git
```

### Windows

Instalar desde:

https://git-scm.com/downloads/windows

### macOS

Instalar mediante Homebrew:

```bash
brew install git
```

o instalar Xcode Command Line Tools:

```bash
xcode-select --install
```

---

# 2. Instalar Docker

Instala Docker siguiendo la documentación oficial correspondiente a tu sistema operativo.

| Sistema operativo | Documentación oficial |
|------------------|-----------------------|
| Debian | https://docs.docker.com/engine/install/debian/ |
| Ubuntu | https://docs.docker.com/engine/install/ubuntu/ |
| Fedora | https://docs.docker.com/engine/install/fedora/ |
| Windows | https://docs.docker.com/desktop/setup/install/windows-install/ |
| macOS | https://docs.docker.com/desktop/setup/install/mac-install/ |

Una vez instalado, verifica:

```bash
docker --version
docker compose version
docker context show
docker run hello-world
```

---

# 3. Configurar Docker (solo Linux)

**Agregar el usuario al grupo docker**

```bash
sudo usermod -aG docker $USER
```

Aplicar el cambio:

```bash
newgrp docker
```

Para actualizar los grupos será necesario reiniciar el dispositivo. Con el siguiente comando lo hará:
```bash
sudo reboot
```

Confirmar que el usuario pertenece al grupo docker
```bash
groups
```

> **Nota:** Configurar el grupo docker es un paso que se realiza una única vez. No es necesario repetirlo.

**Seleccionar el contexto default**

```bash
docker context use default
```

Verificar:
```bash
docker context ls
```

Debe aparecer algo similar a:

```bash
NAME              DESCRIPTION                               DOCKER ENDPOINT
default *         Current DOCKER_HOST based configuration   unix:///var/run/docker.sock
```

> **Nota:** Este comando cambia el contexto activo de Docker. Docker recuerda ese contexto, así que no necesitas volver a ejecutarlo salvo que:
- instales Docker Desktop;
- cambies manualmente al contexto desktop-linux;
- crees otros contextos.

**Permitir aplicaciones gráficas (X11)**
```bash
xhost +local:
```

Debe aparecer algo similar a:
```bash
non-network local connections being added to access control list
```

Verificar:

```bash
docker run hello-world
```
> **Nota:** Este comando modifica los permisos del servidor X de la sesión gráfica actual, no es una configuración permanente. si cierras sesión gráfica o reinicias el equipo, normalmente tendrás que volver a ejecutarlo

> **Nota:** En Windows y macOS estos pasos no son necesarios, ya que Docker Desktop gestiona automáticamente los permisos.

---

# 4. Clonar el repositorio

```bash
git clone https://github.com/IvancitoMint/MiniTractor.git

cd MiniTractor
```

---

# 5. Construir la imagen Docker

### Linux, macOs y Windows + WSL2

```bash
./scripts/docker_build.sh
```

### Windows (PowerShell)

```powershell
docker compose -f docker/docker-compose.yml build
```

---

# 6. Iniciar el contenedor

### Linux y macOS:

```bash
./scripts/docker_shell.sh
```

### Windows:

```powershell
bash scripts/docker_shell.sh
```

---

# 7. Compilar el workspace

```bash
./scripts/ws_build.sh
```

---

# 8. Ejecutar la simulación

```bash
./scripts/sim_run.sh
```

Al ejecutar la simulación por primera vez es muy probable que el ángulo de la cámara no sea el adecuado.
Esto se soluciona deteniendo la simulación presionando:
```bash
ctrl + c
```

Luego ejecutamos la simulación por segunda y ahora el ángulo de la cámara debería ser el corrcto.
```bash
./scripts/sim_run.sh
```

---

# 9. Teleoperación

Abrir una segunda terminal.

Entrar nuevamente al contenedor:

```bash
./scripts/docker_shell.sh
```

Ejecutar:

```bash
./scripts/sim_teleop.sh
```

---

# Verificación

La instalación es correcta cuando:

- Docker funciona correctamente.
- La imagen `minitractor:humble` se construye sin errores.
- El contenedor inicia correctamente.
- El workspace compila.
- Gazebo inicia correctamente.
- El tractor aparece en el mundo virtual.
- El tractor responde a los comandos del teclado.
- El nodo Safety Stop funciona correctamente.