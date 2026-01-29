# Centro Dental - Sistema de Gestión

Sistema web para la gestión de información de la clínica dental Centro Dental, con búsqueda de pacientes, dentistas y citas.

## Características

- 🔍 Búsqueda avanzada de pacientes, dentistas y citas
- 📊 Panel de estadísticas en tiempo real
- 📋 Detalles completos de pacientes con historial de citas y problemas
- 👨‍⚕️ Información detallada de dentistas y sus atenciones
- 💰 Gestión de montos y saldos pendientes
- 🎨 Interfaz moderna y responsive

## Requisitos

- Docker
- Docker Compose

## Instalación y Ejecución

1. Navega al directorio del proyecto:
```bash
cd clinica-dental
```

2. Levanta los contenedores con Docker Compose:
```bash
docker-compose up -d
```

3. Espera unos segundos para que la base de datos se inicialice.

4. Accede a la aplicación en tu navegador:
```
http://localhost
```

## Detener la aplicación

```bash
docker-compose down
```

## Para eliminar también los datos de la base de datos

```bash
docker-compose down -v
```

## Estructura del Proyecto

```
clinica-dental/
├── backend/
│   └── api.php              # API REST en PHP
├── frontend/
│   ├── index.html           # Página principal
│   ├── styles.css           # Estilos
│   └── app.js               # Lógica del frontend
├── database/
│   └── Centro_Dental.sql    # Script de base de datos
├── docker-compose.yml       # Configuración de Docker Compose
└── Dockerfile               # Imagen personalizada de PHP + Apache
```

## Tecnologías Utilizadas

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Backend**: PHP 8.2 con PDO
- **Base de Datos**: MariaDB
- **Contenedores**: Docker & Docker Compose
- **Servidor Web**: Apache

## Base de Datos

La base de datos `centro_dental` contiene las siguientes tablas:

- **paciente**: Información de los pacientes
- **dentistas**: Información de los dentistas
- **citas**: Registro de citas médicas
- **problemas**: Problemas dentales de los pacientes

## API Endpoints

- `GET /api/api.php?action=buscar_pacientes&search={term}`
- `GET /api/api.php?action=buscar_dentistas&search={term}`
- `GET /api/api.php?action=buscar_citas&search={term}`
- `GET /api/api.php?action=obtener_paciente&search={rut}`
- `GET /api/api.php?action=obtener_dentista&search={rut}`
- `GET /api/api.php?action=estadisticas`
