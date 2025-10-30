# Guía de Inicio Rápido

## ⚡ Configuración en 5 minutos

### 1. Configurar Backend

```bash
cd backend

# Instalar dependencias
composer install

# Configurar base de datos
cp .env.example .env  # Si no existe .env

# Editar .env y configurar:
# DB_CONNECTION=mysql
# DB_DATABASE=sistema_asistencia
# DB_USERNAME=root
# DB_PASSWORD=

# Crear base de datos
mysql -u root -e "CREATE DATABASE sistema_asistencia"

# Migrar y poblar datos
php artisan migrate:fresh --seed

# Iniciar servidor
php artisan serve
```

### 2. Configurar Frontend

```bash
cd frontend

# Instalar dependencias
flutter pub get

# Ejecutar app
flutter run
```

## 🧪 Probar el Sistema

### Login como Administrador

1. En la app Flutter, selecciona "Administrador"
2. Ingresa:
   - Email: `admin@example.com`
   - Contraseña: `password`
3. Presiona "Ingresar"

### Crear Usuarios de Prueba

#### Opción 1: Crear manualmente con Tinker

```bash
cd backend
php artisan tinker
```

```php
// Crear un estudiante ponente
$studentRole = App\Models\Role::where('name', 'alumno')->first();

$student = App\Models\User::create([
    'name' => 'Juan Pérez',
    'email' => 'juan@example.com',
    'dni' => '12345678',
    'student_code' => '2024001',
    'student_type' => 'ponente',
    'password' => bcrypt('password'),
    'role_id' => $studentRole->id,
]);

// Crear un jurado
$judgeRole = App\Models\Role::where('name', 'jurado')->first();

$judge = App\Models\User::create([
    'name' => 'Dr. García',
    'email' => 'garcia@example.com',
    'dni' => '87654321',
    'username' => 'jurado01',
    'password' => bcrypt('password'),
    'role_id' => $judgeRole->id,
]);
```

#### Opción 2: Importar desde Excel

1. Crea archivos Excel con el formato especificado en README.md
2. Inicia sesión como administrador
3. Usa Postman o curl para importar:

```bash
# Importar estudiantes
curl -X POST http://localhost:8000/api/import/students \
  -H "Authorization: Bearer TU_TOKEN" \
  -F "file=@estudiantes.xlsx"

# Importar jurados
curl -X POST http://localhost:8000/api/import/judges \
  -H "Authorization: Bearer TU_TOKEN" \
  -F "file=@jurados.xlsx"

# Importar artículos
curl -X POST http://localhost:8000/api/import/articles \
  -H "Authorization: Bearer TU_TOKEN" \
  -F "file=@articulos.xlsx"
```

## 📱 Flujo de Usuario

### Alumno
1. Selecciona "Alumno" en la pantalla principal
2. Ingresa DNI y Código de estudiante
3. Presiona "Ingresar"
4. Ve tu información de perfil
5. Presiona el ícono de logout para salir

### Jurado
1. Selecciona "Jurado" en la pantalla principal
2. Ingresa Usuario y DNI
3. Presiona "Ingresar"
4. Ve tu información de perfil
5. Presiona el ícono de logout para salir

## 🔧 Comandos Útiles

### Backend

```bash
# Ver rutas disponibles
php artisan route:list

# Limpiar caché
php artisan cache:clear
php artisan config:clear

# Ver logs
tail -f storage/logs/laravel.log

# Recrear base de datos
php artisan migrate:fresh --seed
```

### Frontend

```bash
# Limpiar build
flutter clean

# Ver dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS

# Build para producción
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
```

## 🐛 Problemas Comunes

### "Connection refused" en Flutter

**Solución 1:** Usa la IP de tu máquina en lugar de localhost

```dart
// lib/core/di/injection.dart
baseUrl: 'http://192.168.1.100:8000',  // Tu IP local
```

**Solución 2:** En Android Emulator, usa:
```dart
baseUrl: 'http://10.0.2.2:8000',
```

### "SQLSTATE[HY000] [2002] Connection refused"

**Solución:** Verifica que MySQL esté corriendo
```bash
# macOS
brew services start mysql

# Linux
sudo systemctl start mysql

# Windows
net start MySQL
```

### "Token expired"

**Solución:** Vuelve a iniciar sesión. Los tokens de Sanctum expiran después de cierto tiempo.

## 📊 Datos de Ejemplo para Excel

### estudiantes.xlsx
```
nombre          email                 dni       codigo_estudiante  tipo
Juan Pérez      juan@example.com      12345678  2024001           ponente
María López     maria@example.com     23456789  2024002           oyente
Carlos Ruiz     carlos@example.com    34567890  2024003           ponente
```

### jurados.xlsx
```
nombre          email                 dni       username
Dr. García      garcia@example.com    11111111  jurado01
Dra. Martínez   martinez@example.com  22222222  jurado02
Dr. Rodríguez   rodriguez@example.com 33333333  jurado03
```

### articulos.xlsx
```
titulo                    descripcion                      dni_ponente
IA en la Medicina        Aplicaciones de ML en salud      12345678
Blockchain y Finanzas    Criptomonedas descentralizadas   34567890
```

## 🎯 Próximos Pasos

Una vez que tengas el sistema funcionando:

1. ✅ Implementar gestión de asistencia
2. ✅ Añadir visualización de artículos
3. ✅ Implementar evaluación de ponencias
4. ✅ Agregar reportes y estadísticas
5. ✅ Implementar notificaciones push
6. ✅ Añadir búsqueda y filtros

## 💡 Tips

- Usa Postman para probar la API
- Revisa los logs de Laravel para debugging
- Usa Flutter DevTools para debugging de UI
- Mantén las dependencias actualizadas
- Haz commits frecuentes en Git

## 📚 Recursos

- [Laravel Documentation](https://laravel.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [Sanctum Documentation](https://laravel.com/docs/sanctum)
- [BLoC Pattern](https://bloclibrary.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
