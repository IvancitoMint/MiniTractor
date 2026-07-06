# Docker

## Objetivo

MiniTractor utiliza Docker como entorno oficial de desarrollo.

El objetivo es garantizar que cualquier desarrollador pueda ejecutar el proyecto utilizando exactamente las mismas versiones de ROS 2, Gazebo y demás dependencias, independientemente del sistema operativo.

De esta manera se eliminan diferencias entre distribuciones Linux, Windows y macOS, facilitando la colaboración y la reproducibilidad del proyecto.

---

# ¿Por qué Docker?

Tradicionalmente, instalar un entorno completo para ROS 2 implica configurar manualmente:

- ROS 2 Humble
- Gazebo Classic
- colcon
- dependencias de compilación
- bibliotecas adicionales

Cada sistema operativo posee procedimientos distintos de instalación, lo que dificulta la colaboración entre desarrolladores.

Docker resuelve este problema encapsulando todo el entorno dentro de una imagen reproducible.

Con ello se obtiene:

- mismo entorno para todos los desarrolladores;
- mismas versiones de dependencias;
- instalación simplificada;
- menor riesgo de incompatibilidades;
- facilidad para reinstalar el entorno cuando sea necesario.

---

# Arquitectura

La infraestructura Docker del proyecto está organizada de la siguiente manera.

```
docker/
│
├── Dockerfile
├── docker-compose.yml
└── entrypoint.sh
```

Cada archivo tiene una responsabilidad específica.

---

## Dockerfile

Define la imagen oficial del proyecto.

Entre otras tareas:

- selecciona la imagen base de ROS 2 Humble;
- instala las dependencias necesarias;
- crea el usuario del contenedor;
- configura el directorio de trabajo;
- establece el script de inicio.

La imagen generada recibe el nombre:

```
minitractor:humble
```

---

## docker-compose.yml

Describe cómo debe ejecutarse el contenedor.

Su configuración incluye:

- montaje del repositorio como volumen;
- acceso a la interfaz gráfica (X11);
- variables de entorno;
- configuración de red;
- asignación de usuario;
- directorio de trabajo.

Docker Compose permite iniciar siempre el mismo entorno sin necesidad de recordar comandos complejos.

---

## entrypoint.sh

Es el primer script ejecutado al iniciar el contenedor.

Su responsabilidad consiste en preparar automáticamente el entorno de trabajo antes de entregar el control al usuario.

Entre otras tareas:

- carga ROS 2 Humble;
- carga el workspace si ya fue compilado;
- configura el entorno de ejecución;
- inicia una terminal Bash.

---

# Flujo de trabajo

El flujo habitual de desarrollo es el siguiente.

```
Repositorio

↓

docker_build.sh

↓

Imagen Docker

↓

docker_shell.sh

↓

Contenedor

↓

ws_build.sh

↓

sim_run.sh
```

Todo el desarrollo se realiza dentro del contenedor.

---

# Scripts Docker

El proyecto proporciona scripts para simplificar el uso de Docker.

| Script | Función |
|---------|---------|
| docker_build.sh | Construye la imagen Docker del proyecto. |
| docker_shell.sh | Inicia un contenedor interactivo. |
| docker_stop.sh | Detiene y elimina los contenedores temporales. |

Estos scripts constituyen la forma recomendada de interactuar con Docker.

---

# Persistencia de datos

El repositorio del proyecto se monta como un volumen compartido entre el sistema anfitrión y el contenedor.

Esto significa que:

- los archivos editados desde el contenedor aparecen inmediatamente en el sistema anfitrión;
- los cambios realizados desde el sistema anfitrión son visibles dentro del contenedor;
- el código fuente permanece fuera de la imagen Docker.

Como consecuencia, reconstruir la imagen no elimina el código del proyecto.

---

# Entorno gráfico

Gazebo y RViz se ejecutan dentro del contenedor utilizando el servidor gráfico del sistema anfitrión.

Esto permite utilizar aceleración gráfica sin instalar ROS 2 de forma nativa.

En Linux se utiliza X11 para compartir la interfaz gráfica entre el anfitrión y el contenedor.

---

# Sistemas operativos compatibles

La infraestructura Docker fue diseñada para ser reproducible en múltiples plataformas.

| Sistema operativo | Estado |
|-------------------|--------|
| Debian | Compatible |
| Ubuntu | Compatible |
| Fedora | Compatible |
| macOS | Compatible |
| Windows (WSL2) | Compatible |

En Windows se recomienda utilizar Docker Desktop con integración WSL2 habilitada y ejecutar todos los scripts desde la distribución Linux instalada en WSL2.

---

# Buenas prácticas

Durante el desarrollo se recomienda:

- construir la imagen únicamente cuando cambie el Dockerfile;
- utilizar siempre los scripts del proyecto;
- evitar instalar paquetes manualmente dentro del contenedor;
- mantener el código fuente fuera de la imagen Docker;
- reconstruir la imagen cuando se modifiquen las dependencias del proyecto.

---

# Evolución futura

La infraestructura Docker continuará utilizándose durante todas las etapas del proyecto.

Las futuras versiones incorporarán nuevas dependencias relacionadas con:

- ros2_control;
- SLAM Toolbox;
- Navigation2.

Estas herramientas se añadirán a la imagen Docker sin modificar el flujo de trabajo del desarrollador.