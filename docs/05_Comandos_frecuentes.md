# Comandos frecuentes

Este documento reúne los comandos más utilizados durante el desarrollo de **MiniTractor**.

Los comandos de ROS 2 deben ejecutarse dentro del contenedor Docker del proyecto, salvo que se indique lo contrario.

---

# Estructura del proyecto

```bash
cd ~/MiniTractor
tree -L 3
```

Estructura esperada:

```text
MiniTractor/
├── docker/
├── docs/
├── scripts/
├── workspace/
│   └── src/
│       ├── tractor_bringup/
│       ├── tractor_description/
│       └── tractor_safety/
├── AGENTS.md
├── README.md
└── .gitignore
```

---

# Docker

Construir la imagen:

```bash
./scripts/docker_build.sh
```

Entrar al contenedor:

```bash
./scripts/docker_shell.sh
```

Detener contenedores del proyecto:

```bash
./scripts/docker_stop.sh
```

Este comando es el punto explícito para detener contenedores Docker de MiniTractor.

---

# Workspace

Compilar:

```bash
./scripts/ws_build.sh
```

Limpiar `build/`, `install/` y `log/` tras confirmación:

```bash
./scripts/ws_clean.sh
```

Diagnosticar el entorno:

```bash
./scripts/ws_doctor.sh
```

Compilación manual:

```bash
cd ~/MiniTractor/workspace
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
```

Compilar un paquete específico:

```bash
colcon build --packages-select tractor_description --symlink-install
colcon build --packages-select tractor_bringup --symlink-install
colcon build --packages-select tractor_safety --symlink-install
```

---

# Simulación

Iniciar la simulación completa:

```bash
./scripts/sim_run.sh
```

Detener procesos locales de simulación:

```bash
./scripts/sim_stop.sh
```

Este comando no detiene contenedores Docker. Para eso usa `./scripts/docker_stop.sh`.

Lanzamiento manual:

```bash
cd ~/MiniTractor/workspace
source /opt/ros/humble/setup.bash
source install/setup.bash
ros2 launch tractor_bringup sim_with_safety.launch.py
```

Visualizar únicamente el modelo del tractor en Gazebo:

```bash
ros2 launch tractor_description display.launch.py
```

---

# Teleoperación

En una segunda terminal, entrar al contenedor y ejecutar:

```bash
./scripts/sim_teleop.sh
```

Comando manual equivalente:

```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard \
  --ros-args \
  --remap cmd_vel:=/cmd_vel_raw \
  -p speed:=0.5 \
  -p turn:=1.8
```

Para ajustar la sensibilidad desde el script:

```bash
TELEOP_TURN=2.0 ./scripts/sim_teleop.sh
```

Teclas principales:

| Tecla | Acción |
|-------|--------|
| `i` | Avanzar |
| `,` | Retroceder |
| `j` | Girar izquierda |
| `l` | Girar derecha |
| `k` | Detener |
| `u` | Avanzar girando izquierda |
| `o` | Avanzar girando derecha |
| `m` | Retroceder girando |
| `.` | Retroceder girando |

---

# Arquitectura de control actual

Actualmente el flujo de comandos es:

```text
Usuario / teleoperación
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
 diff_drive_controller
        │
        ▼
 ros2_control / Gazebo
        │
        ▼
     Tractor
```

No se recomienda publicar directamente sobre `/cmd_vel`, porque evita el filtro de seguridad.

---

# Movimiento manual

Avanzar:

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.5}, angular: {z: 0.0}}"
```

Retroceder:

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: -0.5}, angular: {z: 0.0}}"
```

Girar izquierda:

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.0}, angular: {z: 0.8}}"
```

Girar derecha:

```bash
ros2 topic pub --rate 10 /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.0}, angular: {z: -0.8}}"
```

Detener:

```bash
ros2 topic pub --once /cmd_vel_raw geometry_msgs/msg/Twist \
"{linear: {x: 0.0}, angular: {z: 0.0}}"
```

---

# Inspección ROS 2

Listar nodos:

```bash
ros2 node list
```

Inspeccionar el nodo Safety Stop:

```bash
ros2 node info /safety_stop_node
```

Listar tópicos:

```bash
ros2 topic list
```

Inspeccionar tópicos principales:

```bash
ros2 topic info /cmd_vel_raw
ros2 topic info /cmd_vel
ros2 topic info /scan
ros2 topic info /odom
```

Escuchar mensajes:

```bash
ros2 topic echo /scan --once
ros2 topic echo /odom --once
ros2 topic echo /cmd_vel_raw
ros2 topic echo /cmd_vel
```

Medir frecuencias:

```bash
ros2 topic hz /scan
ros2 topic hz /odom
ros2 topic hz /joint_states
```

---

# Sensores

LiDAR:

```bash
ros2 topic echo /scan --once
ros2 topic hz /scan
```

Cámara:

```bash
ros2 topic info /front_camera/image_raw
ros2 topic info /front_camera/camera_info
```

Odometría:

```bash
ros2 topic echo /odom --once
ros2 topic hz /odom
```

---

# TF

Verificar mensajes TF:

```bash
ros2 topic echo /tf --once
```

Generar el árbol de frames:

```bash
ros2 run tf2_tools view_frames
```

Si la herramienta no está disponible, debe añadirse a la imagen Docker en una etapa controlada.

---

# Parámetros

Listar parámetros:

```bash
ros2 param list
```

Consultar parámetros del Safety Stop:

```bash
ros2 param list /safety_stop_node
ros2 param get /safety_stop_node stop_distance
ros2 param get /safety_stop_node forward_angle_deg
```

---

# Paquetes

Listar paquetes del proyecto:

```bash
ros2 pkg list | grep tractor
```

Buscar paquetes de Gazebo:

```bash
ros2 pkg list | grep gazebo
```

---

# Xacro

Validar el Xacro:

```bash
xacro ~/MiniTractor/workspace/src/tractor_description/urdf/tractor.urdf.xacro
```

Guardar el URDF generado:

```bash
xacro ~/MiniTractor/workspace/src/tractor_description/urdf/tractor.urdf.xacro > /tmp/mini_tractor.urdf
```

---

# Búsqueda

Buscar archivos:

```bash
find ~/MiniTractor -name "tractor.urdf.xacro"
```

Buscar texto:

```bash
grep -R "gazebo_ros2_control" ~/MiniTractor/workspace/src
grep -R "cmd_vel_raw" ~/MiniTractor/workspace/src
```

---

# Git

Estado del repositorio:

```bash
git status
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

Listar controladores:

```bash
ros2 control list_controllers
```

Listar interfaces de hardware:

```bash
ros2 control list_hardware_interfaces
```

Listar componentes de hardware:

```bash
ros2 control list_hardware_components
```
