# MiniTractor

> Simulación de un mini tractor autónomo utilizando ROS 2 Humble y Gazebo Classic.

---

## Descripción

MiniTractor es un proyecto de robótica móvil cuyo objetivo es desarrollar una plataforma virtual capaz de simular un tractor agrícola equipado con sensores y algoritmos de navegación autónoma.

Actualmente el proyecto incluye:

- Docker
- Modelo del tractor en URDF/Xacro
- Simulación en Gazebo Classic
- Cámara RGB
- Sensor LiDAR
- Sistema de frenado reactivo por LiDAR
- Control mediante `/cmd_vel`

En futuras versiones se integrarán:

- ros2_control
- RViz2
- SLAM
- Nav2
- Navegación autónoma
- Visión artificial

---

# Objetivos

- Construir una plataforma modular basada en ROS 2.
- Simular un entorno agrícola realista.
- Implementar sistemas de percepción y navegación.
- Mantener una arquitectura escalable y documentada.
- Facilitar una futura migración a hardware físico.

---

# Tecnologías

- ROS 2 Humble
- Gazebo Classic
- RViz2
- Xacro
- URDF
- Python
- CMake
- Git

Próximamente:

- ros2_control

---

# Estructura del proyecto

```text
tractor_project/
├── docs/
├── docker/
├── scripts/
├── workspace/
└── README.md
```

---

# Estado del proyecto

## Fase 0 — Infraestructura

- [x] Organización del proyecto
- [x] Documentación inicial
- [x] Scripts
- [x] Git

## Fase 1 — Simulación

- [x] Restauración del proyecto
- [x] Validación completa

## Fase 2

- [x] Docker

## Fase 3

- [ ] ros2_control

## Fase 4

- [ ] RViz2

## Fase 5

- [ ] SLAM

## Fase 6

- [ ] Nav2

## Fase 7

- [ ] Navegación Autónoma

---

# Documentación

Toda la documentación del proyecto se encuentra en:

```
docs/
```

---

# Licencia

Pendiente.

---

# Autores

- Guillermo Delgado Farias
- Ivan Alejandro Gonzalez Ochoa
- Christian David Sanchez Sanchez
- Fernando Nicolás Sanchez Montes de Oca