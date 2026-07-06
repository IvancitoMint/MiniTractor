# Contexto del proyecto MiniTractor

## Objetivo

Este repositorio implementa un **tractor agrícola autónomo** desarrollado sobre **ROS 2 Humble** y **Gazebo Classic 11**, con el objetivo de evolucionar progresivamente hasta obtener un sistema capaz de:

- Simular un tractor diferencial.
- Navegar dentro de un huerto virtual.
- Construir mapas mediante SLAM.
- Navegar de forma autónoma utilizando Nav2.
- Mantener una arquitectura limpia, modular y reproducible mediante Docker.

El proyecto busca además ser un ejemplo didáctico de buenas prácticas para ROS 2.

---

# Estado actual del proyecto

Actualmente el proyecto corresponde aproximadamente a la versión **v0.2.0**.

La infraestructura ya fue reorganizada y estabilizada.

Se cuenta con:

- Docker completamente funcional.
- ROS 2 Humble.
- Gazebo Classic.
- Workspace organizado mediante paquetes.
- Scripts para automatizar las tareas más comunes.
- Documentación de instalación.
- Simulación funcional del tractor.

La migración desde una instalación nativa hacia Docker fue concluida exitosamente.

---

# Organización del repositorio

Actualmente la estructura general es similar a:

```
MiniTractor/
│
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── entrypoint.sh
│
├── docs/
│
├── scripts/
│   ├── docker_build.sh
│   ├── docker_shell.sh
│   ├── docker_stop.sh
│   │
│   ├── sim_run.sh
│   ├── sim_stop.sh
│   ├── sim_teleop.sh
│   │
│   ├── ws_build.sh
│   ├── ws_clean.sh
│   ├── ws_doctor.sh
│   │
│   └── lib/
│       └── common.sh
│
└── workspace/
    └── src/
        ├── tractor_description
        ├── tractor_bringup
        └── tractor_safety
```

---

# Arquitectura actual

Actualmente existen tres paquetes principales.

## tractor_description

Contiene:

- URDF/Xacro
- meshes
- launch
- rviz
- worlds

Es el paquete responsable de describir completamente el robot.

---

## tractor_bringup

Contiene:

- launch files
- mundo del huerto
- inicialización completa del sistema

Actualmente ejecuta:

- Gazebo
- robot_state_publisher
- spawn_entity
- Safety Stop

---

## tractor_safety

Implementa el nodo Safety Stop.

Actualmente:

- recibe información del LiDAR
- detecta obstáculos
- bloquea el avance del tractor

---

# Docker

El proyecto ya no depende de instalaciones manuales de ROS.

Toda la infraestructura se ejecuta mediante Docker.

Actualmente existen scripts para:

- construir la imagen
- abrir un shell
- detener contenedores

El objetivo es que cualquier usuario pueda ejecutar el proyecto sin instalar ROS localmente.

---

# Scripts

El proyecto utiliza scripts para simplificar todas las operaciones frecuentes.

Actualmente existen scripts para:

Docker

- docker_build.sh
- docker_shell.sh
- docker_stop.sh

Workspace

- ws_build.sh
- ws_clean.sh
- ws_doctor.sh

Simulación

- sim_run.sh
- sim_stop.sh
- sim_teleop.sh

Todos ellos utilizan la biblioteca común:

```
scripts/lib/common.sh
```

---

# Estado funcional

Actualmente el sistema permite:

✔ Construir el workspace

✔ Lanzar Gazebo

✔ Generar el tractor

✔ Publicar TF

✔ Publicar Odometry

✔ Ejecutar Safety Stop

✔ Control mediante teclado

Actualmente el tractor:

- avanza
- retrocede

Todavía no gira correctamente.

Esto es esperado.

La razón es que aún no se ha implementado **ros2_control**.

---

# Filosofía del proyecto

Se busca mantener:

- código limpio
- documentación completa
- scripts reutilizables
- estructura modular
- facilidad para nuevos colaboradores

Se prioriza que cualquier estudiante pueda clonar el repositorio y ejecutar la simulación con la menor cantidad posible de pasos.

---

# Trabajo solicitado

Antes de realizar cualquier modificación, analiza completamente el proyecto.

Se espera una revisión integral de:

- estructura del repositorio
- organización de paquetes
- launch files
- URDF/Xacro
- scripts
- Docker
- documentación
- dependencias
- arquitectura ROS

No comiences implementando cambios inmediatamente.

Primero comprende completamente cómo funciona el proyecto.

Identifica posibles mejoras estructurales y oportunidades de refactorización sin romper la arquitectura existente.

---

# Hoja de ruta

Después del análisis deberán desarrollarse las siguientes versiones.

---

# v0.3.0 — Integración de ros2_control

Objetivo principal:

Migrar el modelo del tractor para utilizar **ros2_control** en lugar de depender únicamente del plugin DiffDrive de Gazebo.

Se espera:

- integración completa con ros2_control
- controladores configurados correctamente
- uso de controller_manager
- diff_drive_controller
- joint_state_broadcaster
- separación clara entre hardware y control

Al finalizar esta etapa el tractor deberá:

- avanzar
- retroceder
- girar correctamente
- exponer interfaces estándar de ROS 2

Toda la arquitectura deberá quedar preparada para SLAM Toolbox y Nav2.

---

# v0.4.0 — Integración de SLAM Toolbox

Una vez completada la integración de ros2_control, implementar **SLAM Toolbox** para permitir el mapeo del huerto de papayos.

## Objetivos

- Integrar SLAM Toolbox en la arquitectura existente.
- Utilizar el LiDAR y la odometría del tractor para construir un mapa 2D consistente.
- Crear launch files específicos para el proceso de mapeo.
- Configurar correctamente los parámetros de SLAM Toolbox.
- Permitir guardar el mapa generado en formato `.pgm` y `.yaml`.
- Crear un directorio dedicado para almacenar los mapas generados.

## Resultado esperado

El operador deberá poder:

- iniciar la simulación;
- teleoperar el tractor por todo el huerto;
- generar un mapa completo del entorno;
- guardar el mapa para utilizarlo posteriormente en Navigation2.

Al finalizar esta versión deberán existir los launch files y scripts necesarios para ejecutar el proceso completo de mapeo.

---

# v0.5.0 — Integración de Navigation2 (Nav2)

Con el mapa generado mediante SLAM Toolbox, integrar completamente **Navigation2**.

## Objetivos

- Configurar AMCL para la localización del tractor.
- Configurar los archivos YAML de Navigation2.
- Ajustar el Global Costmap utilizando el mapa estático generado.
- Configurar el Local Costmap para la evasión dinámica de obstáculos.
- Ajustar correctamente la Inflation Layer considerando las dimensiones del tractor y la separación entre los árboles del huerto.
- Integrar Planner Server.
- Integrar Controller Server.
- Integrar BT Navigator.
- Configurar Recovery Behaviors.
- Crear launch files específicos para la navegación autónoma.

## Resultado esperado

El operador deberá poder:

- cargar un mapa previamente generado;
- localizar el tractor dentro del huerto;
- enviar objetivos (Goal Pose) desde RViz2;
- visualizar la trayectoria planificada;
- navegar autónomamente evitando obstáculos;
- recuperarse automáticamente cuando el robot pierda la trayectoria o encuentre bloqueos.

## Validación

Al finalizar esta versión deberán obtenerse como mínimo:

- mapa del huerto (`.pgm` y `.yaml`);
- navegación autónoma completamente funcional;
- visualización en RViz2 de:
  - mapa;
  - posición del robot;
  - trayectoria global;
  - trayectoria local;
- documentación de la configuración de los archivos YAML de Navigation2;
- documentación del comportamiento de los Recovery Behaviors.

---

# Restricciones

Durante todas las etapas:

- mantener compatibilidad con ROS 2 Humble
- mantener compatibilidad con Docker
- no romper la estructura existente
- evitar dependencias innecesarias
- mantener scripts simples
- mantener documentación actualizada

Cada modificación debe estar justificada técnicamente.

Siempre priorizar una arquitectura mantenible sobre soluciones rápidas.

---

# Objetivo final

El objetivo es que MiniTractor evolucione hasta convertirse en un proyecto educativo y profesional que sirva como ejemplo completo de un robot agrícola autónomo construido sobre:

- ROS 2 Humble
- Gazebo
- ros2_control
- SLAM Toolbox
- Navigation2
- Docker

con una arquitectura limpia, modular, reproducible y completamente documentada.