# Arquitectura

## Objetivo

Este documento describe la arquitectura general de **MiniTractor**, los componentes que lo integran y el flujo de información entre ellos.

El proyecto sigue una arquitectura modular basada en paquetes de ROS 2, donde cada componente tiene una responsabilidad claramente definida.

Esta organización facilita el mantenimiento del código y permite incorporar nuevas funcionalidades sin afectar la estructura existente.

---

# Arquitectura general

Actualmente MiniTractor está compuesto por tres paquetes principales:

```
                   MiniTractor
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
tractor_description  tractor_bringup  tractor_safety
```

Cada uno posee una única responsabilidad dentro del sistema.

---

# Componentes

## tractor_description

Es el paquete encargado de describir completamente el robot.

Contiene todos los recursos relacionados con su representación física.

Entre ellos:

- URDF
- Xacro
- configuración de ros2_control
- Meshes
- Configuración de RViz
- Mundos de Gazebo

Su responsabilidad termina una vez que el modelo del robot ha sido generado.

No contiene lógica de navegación ni de control.

---

## tractor_bringup

Es el paquete encargado de iniciar el sistema completo.

Desde aquí se ejecutan todos los launch files necesarios para la simulación.

Entre sus responsabilidades se encuentran:

- iniciar Gazebo
- cargar el mundo virtual
- publicar el robot
- insertar el tractor en la simulación
- iniciar los nodos necesarios

Puede considerarse como el punto de entrada principal del proyecto.

---

## tractor_safety

Implementa el nodo **Safety Stop**.

Su objetivo es supervisar continuamente el LiDAR para evitar colisiones.

Cuando detecta un obstáculo dentro de la distancia configurada:

- bloquea el movimiento hacia adelante;
- permite continuar girando o retrocediendo;
- protege al robot frente a obstáculos inesperados.

---

# Arquitectura ROS 2

Actualmente el flujo de información puede representarse de la siguiente manera:

```
                 Teleop
                    │
             /cmd_vel_raw
                    │
                    ▼
            Safety Stop Node
                    │
                /cmd_vel
                    │
                    ▼
          diff_drive_controller
                    │
                    ▼
        ros2_control / Gazebo
                    │
      ┌─────────────┴─────────────┐
      │                           │
      ▼                           ▼
   /odom                      /joint_states
      │                           │
      └─────────────┬─────────────┘
                    ▼
           robot_state_publisher
                    │
                    ▼
                   TF
```

Toda la comunicación entre componentes se realiza mediante los mecanismos estándar de ROS 2:

- Topics
- TF
- Launch Files
- Parámetros

El tópico `/cmd_vel_raw` es la entrada de comandos del usuario o de herramientas de teleoperación.
El tópico `/cmd_vel` queda reservado como salida filtrada del nodo Safety Stop hacia `diff_drive_controller`.

---

# Sensores

Actualmente el tractor incorpora los siguientes sensores virtuales.

## LiDAR

Utilizado para:

- detección de obstáculos;
- Safety Stop;
- futuro SLAM;
- futura navegación autónoma.

---

## Cámara

Permite visualizar el entorno desde el tractor.

Actualmente se utiliza con fines de simulación y depuración.

Su integración servirá como base para futuros desarrollos relacionados con visión artificial.

---

## Odometría

Generada por Gazebo.

Se utiliza para:

- estimación de la posición del robot;
- publicación del frame `odom`;
- integración futura con SLAM Toolbox.

---

# Frames TF

Actualmente el sistema publica la siguiente jerarquía de transformaciones.

```
odom
 │
 ▼
base_footprint
 │
 ▼
base_link
 ├── lidar_link
 ├── camera_link
 ├── front_left_wheel
 ├── front_right_wheel
 ├── rear_left_wheel
 └── rear_right_wheel
```

Esta estructura será reutilizada en las siguientes etapas del proyecto.

---

# Flujo de ejecución

Cuando el usuario ejecuta:

```bash
./scripts/sim_run.sh
```

ocurre la siguiente secuencia:

1. Se carga el entorno de ROS 2.
2. Se inicia Gazebo.
3. Se carga el mundo del huerto.
4. Se publica el modelo del tractor.
5. El robot es insertado en la simulación.
6. Se activan `joint_state_broadcaster` y `diff_drive_controller`.
7. Se inicia el nodo Safety Stop.
8. Comienza la publicación de sensores, odometría y transformaciones.

Una vez completado este proceso, el tractor queda listo para recibir comandos mediante teleoperación.

---

# Estado actual

En la versión actual del proyecto el tractor es capaz de:

- iniciar correctamente en Gazebo;
- publicar TF;
- generar odometría;
- publicar datos del LiDAR;
- publicar imágenes de la cámara;
- detenerse automáticamente ante obstáculos;
- desplazarse mediante comandos de teclado;
- utilizar controladores estándar de `ros2_control`.

---

# Arquitectura futura

La arquitectura del proyecto evolucionará de forma incremental.

## v0.3.0

La arquitectura basada en **ros2_control** incorpora:

- controller_manager
- diff_drive_controller
- joint_state_broadcaster

Esto proporciona interfaces estándar de control para ROS 2 y prepara el proyecto para SLAM, Nav2 y futuras variantes de hardware.

---

## v0.4.0

Se integrará **SLAM Toolbox**.

El flujo de información incorporará:

- LiDAR
- Odometría
- SLAM Toolbox
- Generación de mapas

permitiendo construir mapas persistentes del huerto.

---

## v0.5.0

Finalmente se incorporará **Navigation2**.

La arquitectura añadirá:

- AMCL
- Planner Server
- Controller Server
- BT Navigator
- Global Costmap
- Local Costmap
- Recovery Behaviors

Con ello el tractor podrá localizarse, planificar trayectorias y navegar de forma completamente autónoma dentro del huerto.

---

# Filosofía de diseño

Durante toda la evolución del proyecto se mantendrán los siguientes principios:

- una responsabilidad por paquete;
- una única fuente de configuración;
- separación entre descripción, control y navegación;
- reutilización de componentes estándar de ROS 2;
- compatibilidad con Docker;
- documentación sincronizada con el código.

Esta filosofía permitirá que MiniTractor continúe creciendo sin comprometer su mantenibilidad ni la claridad de su arquitectura.
