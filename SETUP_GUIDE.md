# 🚀 Guía de Configuración - Sistema de Asistencia

## 📋 Requisitos Previos

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / Xcode (para emuladores)
- VS Code con extensiones de Flutter (recomendado)

## 🔧 Configuración del Backend

### 1. Configurar Base de Datos

```bash
cd backend

# Copiar archivo de configuración
cp .env.example .env

# Editar .env y configurar la base de datos
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=sistema_asistencia
DB_USERNAME=root
DB_PASSWORD=tu_password
```

### 2. Instalar Dependencias y Migrar

```bash
# Instalar dependencias de Composer
composer install

# Generar key de la aplicación
php artisan key:generate

# Ejecutar migraciones
php artisan migrate

# Ejecutar seeders (categorías y criterios de evaluación)
php artisan db:seed --class=ArticleCategorySeeder
php artisan db:seed --class=EvaluationCriteriaSeeder

# Crear usuario administrador (opcional)
php artisan db:seed --class=AdminUserSeeder
```

### 3. Iniciar Servidor

```bash
php artisan serve
# El servidor estará disponible en http://localhost:8000
```

## 📱 Configuración del Frontend

### 1. Instalar Dependencias

```bash
cd frontend

# Instalar dependencias de Flutter
flutter pub get
```

### 2. Configurar URL del API

Editar `lib/core/network/network_module.dart`:

```dart
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(SharedPreferences prefs) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://TU_IP:8000',  // ← Cambiar esto
        // ... resto de configuración
      ),
    );
    // ...
  }
}
```

**Importante:** 
- Si usas emulador Android: `http://10.0.2.2:8000`
- Si usas dispositivo físico: `http://TU_IP_LOCAL:8000`
- Si usas iOS Simulator: `http://localhost:8000`

### 3. Generar Código

```bash
# Ejecutar el script de build
./build.sh

# O manualmente:
flutter pub run build_runner build --delete-conflicting-outputs
```

Este comando generará:
- `injection.config.dart` - Configuración de inyección de dependencias
- `*.g.dart` - Archivos de serialización JSON para todos los modelos

### 4. Ejecutar la Aplicación

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en un dispositivo específico
flutter run -d <device_id>

# O simplemente
flutter run
```

## 🗂️ Estructura del Proyecto

```
frontend/
├── lib/
│   ├── core/
│   │   ├── di/
│   │   │   ├── injection.dart              # Configuración de DI
│   │   │   └── injection.config.dart       # (Generado)
│   │   ├── network/
│   │   │   ├── network_module.dart         # Configuración de Dio
│   │   │   └── dio_interceptor.dart        # Interceptor de auth
│   │   ├── routes/
│   │   │   └── app_routes.dart             # Rutas de la app
│   │   └── error/
│   │       └── failures.dart               # Clases de errores
│   ├── features/
│   │   └── admin/
│   │       ├── domain/                     # Lógica de negocio
│   │       │   ├── entities/               # Entidades
│   │       │   ├── repositories/           # Interfaces
│   │       │   └── usecases/               # Casos de uso
│   │       ├── data/                       # Acceso a datos
│   │       │   ├── models/                 # Modelos con JSON
│   │       │   ├── datasources/            # API calls
│   │       │   └── repositories/           # Implementaciones
│   │       └── presentation/               # UI
│   │           ├── bloc/                   # State management
│   │           ├── pages/                  # Pantallas
│   │           └── widgets/                # Widgets reutilizables
│   └── main.dart                           # Punto de entrada
└── pubspec.yaml                            # Dependencias
```

## 🔐 Flujo de Autenticación

El sistema actualmente está configurado para iniciar directamente en el dashboard de admin. Para implementar el login completo:

1. Crear las páginas de login para cada rol
2. Implementar el AuthBloc
3. Guardar el token en SharedPreferences
4. El interceptor agregará automáticamente el token a las peticiones

## 📝 Rutas Disponibles

```dart
AppRoutes.adminDashboard      // '/admin/dashboard'
AppRoutes.articlesList        // '/admin/articles'
AppRoutes.articleCreate       // '/admin/articles/create'
AppRoutes.articleEdit         // '/admin/articles/edit' (requiere articleId)
AppRoutes.articleDetail       // '/admin/articles/detail' (requiere articleId)
AppRoutes.judgeAssignment     // '/admin/articles/assign-judges' (requiere articleId)
AppRoutes.importData          // '/admin/import'
AppRoutes.evaluations         // '/admin/evaluations'
AppRoutes.reports             // '/admin/reports'
```

## 🐛 Solución de Problemas

### Error: "No se puede conectar al servidor"

1. Verificar que el backend esté corriendo
2. Verificar la URL del API en `network_module.dart`
3. Si usas emulador Android, usar `10.0.2.2` en lugar de `localhost`

### Error: "Injection.config.dart not found"

Ejecutar el build_runner:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "*.g.dart files not found"

Los archivos `.g.dart` son generados automáticamente. Ejecutar:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error de serialización JSON

Verificar que todos los modelos tengan:
- `@JsonSerializable()` annotation
- `part 'nombre_archivo.g.dart';`
- `fromJson` y `toJson` factory methods

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar con coverage
flutter test --coverage

# Ver reporte de coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Build para Producción

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recomendado para Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build para iOS
flutter build ios --release
```

## 🔄 Actualizar Dependencias

```bash
# Actualizar todas las dependencias
flutter pub upgrade

# Re-generar código después de actualizar
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📚 Documentación Adicional

- `ADMIN_API.md` - Documentación completa de los endpoints del API
- `ADMIN_PROGRESS.md` - Estado del desarrollo y features implementados
- `README.md` - Documentación general del proyecto

## 💡 Tips de Desarrollo

1. **Hot Reload**: Presiona `r` en la terminal para hot reload
2. **Hot Restart**: Presiona `R` para hot restart
3. **DevTools**: Ejecuta `flutter pub global activate devtools` y luego `flutter pub global run devtools`
4. **Logs**: Usa `debugPrint()` en lugar de `print()` para mejor output

## 🎯 Próximos Pasos

1. ✅ Backend configurado
2. ✅ Frontend con arquitectura limpia
3. ✅ Inyección de dependencias
4. ✅ Rutas configuradas
5. ⏳ Implementar páginas de login
6. ⏳ Implementar guards de rutas por rol
7. ⏳ Testing end-to-end

---

**¿Necesitas ayuda?** Revisa la documentación del proyecto o consulta los archivos README.
