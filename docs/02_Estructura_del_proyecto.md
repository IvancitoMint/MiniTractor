# Estructura del Proyecto

## Objetivo

Este documento describe la organización del repositorio **MiniTractor**, la función de cada directorio y las convenciones utilizadas durante el desarrollo.

La estructura fue diseñada para mantener el proyecto modular, facilitar su mantenimiento y permitir que nuevos colaboradores comprendan rápidamente la ubicación de cada componente.

---

# Organización general

```
MiniTractor/
│
├── docker/
├── docs/
├── scripts/
├── workspace/
│
├── README.md
├── LICENSE
└── .gitignore
```

Cada directorio tiene una responsabilidad específica y evita mezclar código fuente, documentación y herramientas de desarrollo.

---

# Directorio docker/

Contiene toda la infraestructura necesaria para ejecutar el proyecto mediante Docker.

```
docker/
│
├── Dockerfile
├── docker-compose.yml
└── entrypoint.sh
```

## Dockerfile

Define la imagen base del proyecto.

Su función es instalar todas las dependencias necesarias para ejecutar ROS 2 Humble y Gazebo dentro del contenedor.

---

## docker-compose.yml

Describe la configuración del contenedor.

Entre otras tareas:

- construcción de la imagen
- montaje del repositorio como volumen
- configuración de variables de entorno
- acceso a la interfaz gráfica (X11)
- configuración de la red

---

## entrypoint.sh

Script ejecutado al iniciar el contenedor.

Su función es preparar automáticamente el entorno de trabajo antes de abrir la terminal del usuario.

---

# Directorio docs/

Contiene toda la documentación oficial del proyecto.

```
docs/
│
├── 01_Instalacion.md
├── 02_Estructura_del_proyecto.md
├── 03_Arquitectura.md
├── 04_Docker.md
└── 05_Comandos_frecuentes.md
```

Cada documento aborda un aspecto específico del proyecto para evitar información duplicada.

---

# Directorio scripts/

Contiene los scripts utilizados para automatizar las tareas más comunes.

```
scripts/
│
├── docker_build.sh
├── docker_shell.sh
├── docker_stop.sh
│
├── sim_run.sh
├── sim_stop.sh
├── sim_teleop.sh
│
├── ws_build.sh
├── ws_clean.sh
├── ws_doctor.sh
│
└── lib/
    └── common.sh
```

Los scripts se encuentran organizados por categoría.

---

## Scripts Docker

Se encargan de administrar el contenedor.

| Script | Función |
|---------|---------|
| docker_build.sh | Construye la imagen Docker. |
| docker_shell.sh | Inicia un contenedor interactivo y construye la imagen si no existe. |
| docker_stop.sh | Detiene contenedores activos del proyecto y limpia contenedores detenidos. |

---

## Scripts de Simulación

Permiten ejecutar la simulación del tractor.

| Script | Función |
|---------|---------|
| sim_run.sh | Inicia Gazebo y todos los nodos del proyecto. |
| sim_stop.sh | Detiene procesos locales de simulación sin administrar Docker. |
| sim_teleop.sh | Controla el tractor mediante teclado. |

---

## Scripts del Workspace

Automatizan las tareas relacionadas con el workspace de ROS 2.

| Script | Función |
|---------|---------|
| ws_build.sh | Compila el workspace mediante colcon. |
| ws_clean.sh | Elimina build, install y log tras confirmación. |
| ws_doctor.sh | Verifica el estado del entorno de desarrollo. |

---

## Biblioteca común

```
scripts/lib/common.sh
```

Este archivo contiene funciones reutilizadas por todos los scripts, como:

- mensajes informativos
- comprobaciones del entorno
- carga automática del workspace
- configuración compartida

Su objetivo es evitar duplicar código entre scripts.

---

# Directorio workspace/

Contiene el workspace de ROS 2.

```
workspace/
│
├── src/
├── build/
├── install/
└── log/
```

---

## src/

Contiene el código fuente del proyecto.

Actualmente está dividido en tres paquetes.

```
src/
│
├── tractor_bringup/
├── tractor_description/
└── tractor_safety/
```

---

### tractor_bringup

Coordina el inicio completo del sistema.

Se encarga de:

- iniciar Gazebo
- cargar el mundo virtual
- publicar el modelo del robot
- generar la entidad en la simulación
- iniciar los nodos necesarios para la simulación

---

### tractor_description

Describe físicamente el robot.

Contiene:

- modelo URDF/Xacro modular
- configuración de ros2_control
- mallas (meshes)
- mundos de Gazebo
- configuraciones de RViz
- archivos launch relacionados con la descripción del robot

---

### tractor_safety

Implementa el sistema Safety Stop.

Su responsabilidad es supervisar continuamente el LiDAR para detener el tractor cuando detecta obstáculos dentro de una distancia configurable.

---

## build/

Generado automáticamente por `colcon build`.

Contiene todos los archivos temporales utilizados durante la compilación.

No debe modificarse manualmente.

---

## install/

Contiene los paquetes ya compilados y listos para ser utilizados.

Los scripts del proyecto cargan automáticamente este directorio mediante:

```bash
source install/setup.bash
```

---

## log/

Almacena los registros generados durante la compilación y ejecución de ROS 2.

Resulta útil para depuración y diagnóstico de errores.

---

# Convenciones del proyecto

Con el objetivo de mantener una estructura uniforme, el proyecto sigue las siguientes convenciones.

- Cada paquete debe tener una única responsabilidad.
- Los scripts deben automatizar tareas repetitivas.
- La documentación debe mantenerse sincronizada con el código.
- Los launch files deben concentrarse en la inicialización del sistema.
- La configuración debe mantenerse separada del código fuente.
- Docker constituye el entorno oficial de desarrollo.

---

# Evolución del proyecto

La estructura del repositorio continuará creciendo conforme se incorporen nuevas funcionalidades.

Las siguientes versiones añadirán nuevos componentes relacionados con:

- ros2_control
- SLAM Toolbox
- Navigation2

La organización actual fue diseñada para integrar estas tecnologías sin necesidad de reorganizar el repositorio nuevamente.
