# Comandos frecuentes

Este documento reúne los comandos más utilizados durante el desarrollo del proyecto MiniTractor.

---

# Estructura del proyecto

```bash
cd ~/tractor_project
tree -L 3
```

```
.
├── docker
├── docs
│   ├── 01_Instalacion.md
│   ├── 02_Estructura_del_proyecto.md
│   ├── 03_Comandos_frecuentes.md
│   ├── 04_Arquitectura.md
│   ├── 05_ros2_control.md
│   ├── 06_Docker.md
│   ├── 07_SLAM_Nav2.md
│   ├── 08_Lecciones_aprendidas.md
│   ├── CHANGELOG.md
│   └── CONTEXTO.md
├── README.md
├── scripts
│   ├── build.sh
│   ├── clean.sh
│   ├── doctor.sh
│   ├── lib
│   │   └── common.sh
│   └── run.sh
└── workspace
    ├── build
    │   ├── COLCON_IGNORE
    │   ├── tractor_bringup
    │   ├── tractor_description
    │   └── tractor_safety
    ├── install
    │   ├── COLCON_IGNORE
    │   ├── local_setup.bash
    │   ├── local_setup.ps1
    │   ├── local_setup.sh
    │   ├── _local_setup_util_ps1.py
    │   ├── _local_setup_util_sh.py
    │   ├── local_setup.zsh
    │   ├── setup.bash
    │   ├── setup.ps1
    │   ├── setup.sh
    │   ├── setup.zsh
    │   ├── tractor_bringup
    │   ├── tractor_description
    │   └── tractor_safety
    ├── log
    │   ├── build_2026-07-04_14-04-28
    │   ├── COLCON_IGNORE
    │   ├── latest -> latest_build
    │   └── latest_build -> build_2026-07-04_14-04-28
    └── src
        ├── tractor_bringup
        ├── tractor_description
        └── tractor_safety

```

---

# Configurar entorno ROS 2

```bash
cd ~/tractor_project/workspace

source /opt/ros/humble/setup.bash
source install/setup.bash
```

---

# Scripts del proyecto

Los scripts principales se encuentran en:

```text
~/tractor_project/scripts/
```

## Compilar

```bash
cd ~/tractor_project

./scripts/build.sh
```

Funciones:

- Verifica que exista el workspace.
- Verifica que ROS 2 Humble esté instalado.
- Carga el entorno de ROS.
- Ejecuta `colcon build --symlink-install`.

---

## Ejecutar simulación

```bash
cd ~/tractor_project

./scripts/run.sh
```

Funciones:

- Verifica que el workspace exista.
- Verifica que el workspace esté compilado.
- Carga ROS 2.
- Carga el workspace.
- Ejecuta:

```bash
ros2 launch tractor_bringup sim_with_safety.launch.py
```

---

## Limpiar workspace

```bash
cd ~/tractor_project

./scripts/clean.sh
```

Elimina:

```text
workspace/build/
workspace/install/
workspace/log/
```

---

## Diagnóstico

```bash
cd ~/tractor_project

./scripts/doctor.sh
```

Comprueba:

- ROS 2 Humble
- Gazebo
- colcon
- xacro
- Workspace
- tractor_description
- tractor_bringup
- tractor_safety

---

# Compilación manual

```bash
cd ~/tractor_project/workspace

source /opt/ros/humble/setup.bash

colcon build --symlink-install

source install/setup.bash
```

---

## Compilar un paquete

```bash
colcon build --packages-select tractor_description --symlink-install
```

```bash
colcon build --packages-select tractor_bringup --symlink-install
```

```bash
colcon build --packages-select tractor_safety --symlink-install
```

---

# Ejecutar simulación manualmente

```bash
cd ~/tractor_project/workspace

source /opt/ros/humble/setup.bash
source install/setup.bash

ros2 launch tractor_bringup sim_with_safety.launch.py
```

---

# Arquitectura de control

Actualmente el flujo es:

```text
Usuario
      │
      ▼
/cmd_vel_raw
      │
      ▼
SafetyStopNode
      │
      ▼
/cmd_vel
      │
      ▼
gazebo_ros_diff_drive
      │
      ▼
Tractor
```

**Nunca** publicar directamente sobre `/cmd_vel`.

---

# Movimiento del tractor

## Avanzar

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.5}, angular: {z: 0.0}}"
```

---

## Retroceder

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: -0.5}, angular: {z: 0.0}}"
```

---

## Girar izquierda

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.0}, angular: {z: 0.8}}"
```

---

## Girar derecha

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.0}, angular: {z: -0.8}}"
```

---

## Avanzar girando

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.4}, angular: {z: 0.4}}"
```

---

## Detener

```bash
ros2 topic pub --once /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.0}, angular: {z: 0.0}}"
```

---

# Control mediante teclado

```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard \
--ros-args --remap cmd_vel:=/cmd_vel_raw
```

Teclas principales:

| Tecla | Acción |
|-------|--------|
| i | Avanzar |
| , | Retroceder |
| j | Girar izquierda |
| l | Girar derecha |
| k | Detener |
| u | Avanzar girando izquierda |
| o | Avanzar girando derecha |

---

# Nodos

Mostrar todos los nodos:

```bash
ros2 node list
```

Información de un nodo:

```bash
ros2 node info /gazebo
```

```bash
ros2 node info /safety_stop_node
```

---

# Topics

Mostrar topics:

```bash
ros2 topic list
```

Información de un topic:

```bash
ros2 topic info /cmd_vel_raw
```

```bash
ros2 topic info /cmd_vel
```

```bash
ros2 topic info /scan
```

---

# Escuchar mensajes

Odometría:

```bash
ros2 topic echo /odom --once
```

LiDAR:

```bash
ros2 topic echo /scan --once
```

Comandos enviados:

```bash
ros2 topic echo /cmd_vel_raw
```

Comandos hacia el tractor:

```bash
ros2 topic echo /cmd_vel
```

---

# Frecuencia de publicación

```bash
ros2 topic hz /scan
```

```bash
ros2 topic hz /odom
```

```bash
ros2 topic hz /joint_states
```

---

# Verificar Safety Stop

```bash
ros2 topic info /cmd_vel_raw
```

Resultado esperado:

```
Publisher count: 1
Subscription count: 1
```

```bash
ros2 topic info /cmd_vel
```

Resultado esperado:

```
Publisher count: 1
Subscription count: 1
```

---

# LiDAR

```bash
ros2 topic echo /scan --once
```

```bash
ros2 topic hz /scan
```

---

# Cámara

```bash
ros2 topic info /front_camera/image_raw
```

```bash
ros2 topic info /front_camera/camera_info
```

---

# Odometría

```bash
ros2 topic echo /odom --once
```

```bash
ros2 topic hz /odom
```

---

# Transformaciones TF

```bash
ros2 topic echo /tf --once
```

Instalar herramientas:

```bash
sudo apt install ros-humble-tf2-tools
```

Generar árbol TF:

```bash
ros2 run tf2_tools view_frames
```

---

# Parámetros

Listar parámetros:

```bash
ros2 param list
```

Parámetros del Safety Stop:

```bash
ros2 param list /safety_stop_node
```

Consultar un parámetro:

```bash
ros2 param get /safety_stop_node stop_distance
```

---

# Paquetes ROS

Todos los paquetes:

```bash
ros2 pkg list
```

Buscar paquetes del proyecto:

```bash
ros2 pkg list | grep tractor
```

Buscar paquetes de Gazebo:

```bash
ros2 pkg list | grep gazebo
```

---

# Validar el Xacro

Mostrar el URDF generado:

```bash
xacro ~/tractor_project/workspace/src/tractor_description/urdf/tractor.urdf.xacro
```

Guardar el resultado:

```bash
xacro ~/tractor_project/workspace/src/tractor_description/urdf/tractor.urdf.xacro > /tmp/robot.urdf
```

---

# Buscar archivos

```bash
find ~/tractor_project -name "tractor.urdf.xacro"
```

---

# Buscar texto dentro del proyecto

```bash
grep -R "gazebo_ros_diff_drive" ~/tractor_project/workspace/src
```

```bash
grep -R "cmd_vel_raw" ~/tractor_project/workspace/src
```

---

# Mostrar partes de un archivo

```bash
sed -n '1,120p' archivo
```

Ejemplo:

```bash
sed -n '200,260p' \
~/tractor_project/workspace/src/tractor_description/urdf/tractor.urdf.xacro
```

---

# Matar procesos de Gazebo

```bash
killall -9 gzserver gzclient gazebo 2>/dev/null

pkill -f gzserver
pkill -f gzclient
pkill -f gazebo
pkill -f spawn_entity
```

Verificar:

```bash
ps aux | grep -E "gazebo|gzserver|gzclient|spawn_entity"
```

---

# Git

Estado del repositorio:

```bash
git status
```

Agregar cambios:

```bash
git add .
```

Crear commit:

```bash
git commit -m "Initial commit"
```

Crear etiqueta:

```bash
git tag -a v0.1.0 -m "First stable release"
```

Ver historial:

```bash
git log --oneline
```

Ver etiquetas:

```bash
git tag
```

---

# ros2_control

Reservado para futuras fases.

Listar controladores:

```bash
ros2 control list_controllers
```

Interfaces:

```bash
ros2 control list_hardware_interfaces
```

Hardware:

```bash
ros2 control list_hardware_components
```