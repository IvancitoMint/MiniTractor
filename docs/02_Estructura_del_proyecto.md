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
├── 05_Comandos_frecuentes.md
└── 06_Recovery_behaviors.md
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
├── slam_run.sh
├── slam_save_map.sh
├── obstacle_add.sh
├── obstacle_remove.sh
├── nav_run.sh
├── nav_rviz.sh
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

## Scripts de SLAM

Permiten ejecutar el flujo de mapeo con SLAM Toolbox.

| Script | Función |
|---------|---------|
| slam_run.sh | Inicia la simulación con Safety Stop y SLAM Toolbox activo. |
| slam_save_map.sh | Guarda el mapa generado en `workspace/maps/`. |

---

## Scripts de Obstáculos

Permiten agregar o quitar obstáculos temporales durante la simulación.

| Script | Función |
|---------|---------|
| obstacle_add.sh | Inserta la caja roja de prueba en Gazebo. |
| obstacle_remove.sh | Elimina la caja roja de prueba de Gazebo. |

---

## Scripts de Navegación

Permiten ejecutar Navigation2 y abrir RViz2 con la configuración del proyecto.

| Script | Función |
|---------|---------|
| nav_run.sh | Inicia la simulación con Navigation2 usando un mapa estático. |
| nav_rviz.sh | Abre RViz2 con visualización de mapa, costmaps y objetivos. |

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
├── maps/
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

## maps/

Contiene los mapas generados durante las sesiones de SLAM.

Esta carpeta mantiene únicamente un archivo `.gitkeep` en Git. Los mapas `*.pgm` y `*.yaml` generados localmente se ignoran para evitar incluir artefactos temporales en el repositorio.

---

### tractor_bringup

Coordina el inicio completo del sistema.

Se encarga de:

- iniciar Gazebo
- cargar el mundo virtual
- instalar modelos dinámicos de simulación
- publicar el modelo del robot
- generar la entidad en la simulación
- cargar configuraciones de SLAM y Navigation2
- iniciar los nodos necesarios para la simulación

Contenido principal:

```text
tractor_bringup/
├── config/
│   ├── nav2_params.yaml
│   └── slam_toolbox.yaml
├── launch/
│   ├── sim_with_safety.launch.py
│   ├── sim_with_slam.launch.py
│   └── sim_with_nav2.launch.py
├── models/
│   └── caja_obstaculo/
├── rviz/
│   └── nav2.rviz
└── worlds/
    └── huerto_papayos.world
```

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

El launch `display.launch.py` pertenece a este paquete porque sirve para visualizar o validar la descripción del tractor, no para iniciar el sistema completo.

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

La estructura del repositorio ha evolucionado para integrar:

- ros2_control
- SLAM Toolbox
- Navigation2

La organización actual mantiene estas tecnologías separadas por responsabilidad para evitar reorganizaciones grandes y facilitar el mantenimiento.
