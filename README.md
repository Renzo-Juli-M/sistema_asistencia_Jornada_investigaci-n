# Sistema de Asistencia - Jornada de Investigación

Sistema de autenticación y gestión de asistencia para jornadas de investigación con tres roles principales: Administrador, Jurado y Alumno (ponente/oyente).

## 🏗️ Arquitectura

### Backend - Laravel 12
- ✅ Laravel Sanctum para autenticación API
- ✅ Importación de Excel (maatwebsite/excel)
- ✅ API RESTful
- ✅ Migraciones y Seeders
- ✅ Modelos con relaciones

### Frontend - Flutter
- ✅ Arquitectura Limpia (Clean Architecture)
- ✅ Inyección de dependencias (get_it)
- ✅ Gestión de estado con BLoC
- ✅ Patrón de repositorio
- ✅ Domain-Driven Design

## 👥 Roles y Autenticación

### 1. Administrador
- **Login:** Email + Contraseña
- **Credenciales por defecto:**
  - Email: `admin@example.com`
  - Password: `password`

### 2. Alumno
- **Login:** DNI + Código de estudiante
- **Tipos:** Ponente u Oyente
- **Importación:** Excel con columnas: nombre, email, dni, codigo_estudiante, tipo

### 3. Jurado
- **Login:** Usuario + DNI
- **Importación:** Excel con columnas: nombre, email, dni, username

## 📋 Requisitos

### Backend
- PHP 8.4+
- Composer
- MySQL/MariaDB o PostgreSQL
- Laravel 12

### Frontend
- Flutter 3.0+
- Dart 3.0+

## 🚀 Instalación

### 1. Backend (Laravel)

```bash
cd backend

# Instalar dependencias
composer install

# Configurar base de datos en .env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=sistema_asistencia
DB_USERNAME=root
DB_PASSWORD=

# Crear base de datos
mysql -u root -e "CREATE DATABASE sistema_asistencia"

# Ejecutar migraciones y seeders
php artisan migrate:fresh --seed

# Iniciar servidor
php artisan serve
```

El backend estará disponible en: `http://localhost:8000`

### 2. Frontend (Flutter)

```bash
cd frontend

# Instalar dependencias
flutter pub get

# Generar código (si es necesario)
flutter pub run build_runner build --delete-conflicting-outputs

# Ejecutar aplicación
flutter run
```

**Nota:** Actualiza la URL del backend en `lib/core/di/injection.dart`:
```dart
baseUrl: 'http://localhost:8000', // o tu IP del servidor
```

## 📁 Estructura del Proyecto

```
├── backend/                    # Laravel Backend
│   ├── app/
│   │   ├── Models/            # User, Role, Article
│   │   ├── Http/Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php
│   │   │       └── ImportController.php
│   │   └── Imports/           # StudentsImport, JudgesImport, ArticlesImport
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   └── routes/
│       └── api.php            # Rutas de la API
│
└── frontend/                  # Flutter Frontend
    └── lib/
        ├── core/
        │   ├── di/           # Inyección de dependencias
        │   └── error/        # Manejo de errores
        └── features/
            └── auth/
                ├── data/      # Datasources, Models, Repositories
                ├── domain/    # Entities, Repositories, UseCases
                └── presentation/  # BLoC, Pages, Widgets
```

## 🔌 API Endpoints

### Autenticación

#### Login Administrador
```http
POST /api/login/admin
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "password"
}
```

#### Login Alumno
```http
POST /api/login/student
Content-Type: application/json

{
  "dni": "12345678",
  "student_code": "2024001"
}
```

#### Login Jurado
```http
POST /api/login/judge
Content-Type: application/json

{
  "username": "jurado01",
  "dni": "87654321"
}
```

#### Logout
```http
POST /api/logout
Authorization: Bearer {token}
```

#### Obtener usuario autenticado
```http
GET /api/me
Authorization: Bearer {token}
```

### Importación de datos (requiere autenticación)

#### Importar Alumnos
```http
POST /api/import/students
Authorization: Bearer {token}
Content-Type: multipart/form-data

file: [archivo.xlsx]
```

#### Importar Jurados
```http
POST /api/import/judges
Authorization: Bearer {token}
Content-Type: multipart/form-data

file: [archivo.xlsx]
```

#### Importar Artículos
```http
POST /api/import/articles
Authorization: Bearer {token}
Content-Type: multipart/form-data

file: [archivo.xlsx]
```

## 📊 Formato de Archivos Excel

### Alumnos
| nombre | email | dni | codigo_estudiante | tipo |
|--------|-------|-----|-------------------|------|
| Juan Pérez | juan@example.com | 12345678 | 2024001 | ponente |
| María López | maria@example.com | 87654321 | 2024002 | oyente |

### Jurados
| nombre | email | dni | username |
|--------|-------|-----|----------|
| Dr. García | garcia@example.com | 11111111 | jurado01 |
| Dra. Martínez | martinez@example.com | 22222222 | jurado02 |

### Artículos
| titulo | descripcion | dni_ponente |
|--------|-------------|-------------|
| Investigación sobre IA | Estudio de machine learning | 12345678 |
| Análisis de datos | Big data y analytics | 12345678 |

## 🎨 Características de la UI

- ✅ Selector de roles en pantalla principal
- ✅ Formularios de login personalizados por rol
- ✅ Validación de campos
- ✅ Indicadores de carga
- ✅ Manejo de errores con Snackbars
- ✅ Pantalla de inicio personalizada según el rol
- ✅ Logout funcional

## 🔒 Seguridad

- Autenticación con Laravel Sanctum
- Tokens de acceso seguros
- Almacenamiento seguro con FlutterSecureStorage
- Hash de contraseñas con bcrypt
- Validación de datos en backend y frontend
- CORS configurado

## 🧪 Testing

### Backend
```bash
cd backend
php artisan test
```

### Frontend
```bash
cd frontend
flutter test
```

## 📝 Notas Importantes

1. **Base de datos:** Por defecto, el proyecto usa MySQL. Para otros motores, actualiza el archivo `.env` del backend.

2. **URL del servidor:** En producción, actualiza la `baseUrl` en Flutter:
   ```dart
   // frontend/lib/core/di/injection.dart
   baseUrl: 'https://tu-servidor.com',
   ```

3. **Certificados SSL:** Para HTTPS, configura los certificados en el servidor Laravel.

4. **Generación de código:** Si modificas los modelos que usan `json_serializable`, ejecuta:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Migraciones:** Para resetear la base de datos:
   ```bash
   php artisan migrate:fresh --seed
   ```

## 🐛 Solución de Problemas

### Error de conexión a la base de datos
- Verifica que MySQL esté corriendo
- Confirma las credenciales en `.env`
- Crea manualmente la base de datos si no existe

### Error de CORS en Flutter
- Verifica que CORS esté configurado en Laravel
- Confirma que la URL del backend sea correcta
- En desarrollo, usa la IP local en lugar de localhost

### Error de dependencias en Flutter
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📄 Licencia

Este proyecto es de código abierto para fines educativos.

## 👨‍💻 Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue primero para discutir los cambios propuestos.

## 📧 Contacto

Para preguntas o soporte, contacta al equipo de desarrollo.
