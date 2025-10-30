# Guía de Implementación del Panel de Administración

## 🎯 Estado del Proyecto

### ✅ Backend - COMPLETADO

El backend Laravel está 100% funcional con:

- ✅ 6 migraciones para el sistema de administración
- ✅ 5 modelos nuevos con relaciones completas
- ✅ 7 controladores del admin con lógica completa
- ✅ Dashboard con estadísticas en tiempo real
- ✅ CRUD completo de artículos, estudiantes y jurados
- ✅ Sistema de asignación de jurados (mínimo 2 por artículo)
- ✅ Sistema de evaluaciones con criterios configurables
- ✅ Seeders con datos de prueba
- ✅ 30+ endpoints API documentados
- ✅ Validaciones y seguridad implementadas

### 🚧 Frontend - ESTRUCTURA BASE

El frontend Flutter tiene:

- ✅ Arquitectura limpia establecida
- ✅ Sistema de autenticación funcionando
- ✅ BLoC pattern implementado
- ✅ Inyección de dependencias configurada
- ⏳ Pendiente: Páginas del admin (ver estructura propuesta abajo)

## 📁 Estructura Propuesta para Frontend Admin

```
lib/
├── features/
│   └── admin/
│       ├── data/
│       │   ├── models/
│       │   │   ├── dashboard_stats_model.dart
│       │   │   ├── article_model.dart
│       │   │   ├── assignment_model.dart
│       │   │   └── evaluation_model.dart
│       │   ├── datasources/
│       │   │   └── admin_remote_datasource.dart
│       │   └── repositories/
│       │       └── admin_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── dashboard_stats.dart
│       │   │   ├── article.dart
│       │   │   └── assignment.dart
│       │   ├── repositories/
│       │   │   └── admin_repository.dart
│       │   └── usecases/
│       │       ├── get_dashboard_stats.dart
│       │       ├── get_articles.dart
│       │       ├── create_article.dart
│       │       ├── assign_judges.dart
│       │       └── import_excel.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── dashboard/
│           │   ├── articles/
│           │   ├── assignments/
│           │   └── import/
│           ├── pages/
│           │   ├── admin_dashboard_page.dart
│           │   ├── articles_list_page.dart
│           │   ├── article_form_page.dart
│           │   ├── article_detail_page.dart
│           │   ├── judges_assignment_page.dart
│           │   ├── students_list_page.dart
│           │   ├── judges_list_page.dart
│           │   ├── import_page.dart
│           │   ├── evaluations_page.dart
│           │   └── reports_page.dart
│           └── widgets/
│               ├── stat_card.dart
│               ├── article_card.dart
│               ├── chart_widget.dart
│               ├── filter_bar.dart
│               └── search_bar.dart
```

## 🎨 Páginas del Admin

### 1. Dashboard Principal

**Ruta:** `/admin/dashboard`

**Componentes:**
- Cards con estadísticas principales (total estudiantes, jurados, artículos)
- Gráfico de artículos por mes
- Gráfico de asistencias
- Lista de artículos mejor calificados
- Actividad reciente

**API:** `GET /api/admin/dashboard`

**Widgets recomendados:**
- `fl_chart` para gráficos
- `card` para estadísticas
- `data_table` para listas

### 2. Gestión de Artículos

**Ruta:** `/admin/articles`

**Funcionalidades:**
- Lista con búsqueda y filtros
- Paginación
- Crear nuevo artículo
- Editar artículo
- Ver detalles con evaluaciones
- Eliminar artículo

**API:**
- `GET /api/admin/articles` - Listar
- `POST /api/admin/articles` - Crear
- `GET /api/admin/articles/{id}` - Ver
- `PUT /api/admin/articles/{id}` - Actualizar
- `DELETE /api/admin/articles/{id}` - Eliminar

**Filtros:**
- Por categoría
- Por estado
- Por autor
- Búsqueda por texto

### 3. Asignación de Jurados

**Ruta:** `/admin/assignments`

**Funcionalidades:**
- Seleccionar artículo
- Ver jurados ya asignados
- Seleccionar múltiples jurados (mínimo 2)
- Asignar jurados
- Remover asignación

**API:**
- `GET /api/admin/articles/{id}/available-judges` - Jurados disponibles
- `POST /api/admin/assignments/assign-multiple` - Asignar múltiples
- `DELETE /api/admin/assignments/{id}` - Remover

**Validaciones:**
- Mínimo 2 jurados por artículo
- No duplicar asignaciones
- Confirmar antes de eliminar

### 4. Importación de Excel

**Ruta:** `/admin/import`

**Funcionalidades:**
- Selector de tipo (Estudiantes, Jurados, Artículos)
- File picker
- Preview de datos
- Importar
- Ver errores si los hay

**API:**
- `POST /api/import/students`
- `POST /api/import/judges`
- `POST /api/import/articles`

**Packages:**
- `file_picker` para seleccionar archivos
- `dio` para upload con progress

### 5. Vista de Evaluaciones

**Ruta:** `/admin/evaluations`

**Funcionalidades:**
- Ver todas las evaluaciones
- Filtrar por artículo
- Filtrar por jurado
- Ver promedios
- Gráficos de distribución

**API:**
- `GET /api/admin/articles/{id}/statistics`
- `GET /api/admin/evaluations`

### 6. Reportes

**Ruta:** `/admin/reports`

**Funcionalidades:**
- Seleccionar tipo de reporte
- Filtros de fecha
- Vista previa
- Exportar (Excel, PDF)
- Compartir

**API:**
- `GET /api/admin/reports/general`
- `GET /api/admin/reports/articles`
- `GET /api/admin/reports/evaluations`
- `GET /api/admin/reports/export`

## 🔧 Implementación Paso a Paso

### Paso 1: Crear Modelos de Datos

```dart
// lib/features/admin/data/models/article_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel {
  final int id;
  final String title;
  final String? description;
  final String? abstract;
  final String? keywords;
  final String status;
  final UserModel user;
  final CategoryModel? category;

  ArticleModel({
    required this.id,
    required this.title,
    this.description,
    this.abstract,
    this.keywords,
    required this.status,
    required this.user,
    this.category,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}
```

### Paso 2: Crear DataSource

```dart
// lib/features/admin/data/datasources/admin_remote_datasource.dart
import 'package:dio/dio.dart';

abstract class AdminRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardStats();
  Future<Map<String, dynamic>> getArticles(Map<String, dynamic> params);
  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> data);
  // ... más métodos
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await dio.get('/api/admin/dashboard');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getArticles(Map<String, dynamic> params) async {
    final response = await dio.get(
      '/api/admin/articles',
      queryParameters: params,
    );
    return response.data;
  }

  // ... implementar más métodos
}
```

### Paso 3: Crear BLoCs

```dart
// lib/features/admin/presentation/bloc/dashboard/dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStats getDashboardStats;

  DashboardBloc({required this.getDashboardStats}) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final result = await getDashboardStats();

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (stats) => emit(DashboardLoaded(stats)),
    );
  }
}
```

### Paso 4: Crear Páginas UI

```dart
// lib/features/admin/presentation/pages/admin_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is DashboardLoaded) {
            return _buildDashboard(context, state.stats);
          }

          return const Center(child: Text('Inicializ...'));
        },
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                'Estudiantes',
                stats.totalStudents.toString(),
                Icons.school,
                Colors.blue,
              ),
              _buildStatCard(
                'Jurados',
                stats.totalJudges.toString(),
                Icons.gavel,
                Colors.orange,
              ),
              _buildStatCard(
                'Artículos',
                stats.totalArticles.toString(),
                Icons.article,
                Colors.green,
              ),
              _buildStatCard(
                'Asistencias',
                stats.totalAttendances.toString(),
                Icons.check_circle,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Top Articles
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Artículos Mejor Calificados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...stats.topRatedArticles.map((article) {
                    return ListTile(
                      title: Text(article.title),
                      subtitle: Text(article.author),
                      trailing: Chip(
                        label: Text('${article.averageScore}'),
                        backgroundColor: Colors.green[100],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Panel Admin',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Artículos'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a artículos
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Asignaciones'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a asignaciones
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Estudiantes'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a estudiantes
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Jurados'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a jurados
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Importar Excel'),
            onTap: () {
              Navigator.pop(context),
              // Navegar a importación
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Evaluaciones'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a evaluaciones
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_chart),
            title: const Text('Reportes'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a reportes
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
    );
  }
}
```

## 📦 Packages Recomendados

```yaml
dependencies:
  # Gráficos
  fl_chart: ^0.65.0

  # Tablas y listas avanzadas
  data_table_2: ^2.5.0

  # File picker para Excel
  file_picker: ^6.0.0

  # Exportación Excel
  excel: ^2.1.0

  # PDF
  pdf: ^3.10.7
  printing: ^5.11.1

  # Infinite scroll
  infinite_scroll_pagination: ^4.0.0

  # Pull to refresh
  pull_to_refresh: ^2.0.0

  # Dropdown search
  dropdown_search: ^5.0.6

  # Date picker
  syncfusion_flutter_datepicker: ^24.1.41
```

## 🎯 Prioridades de Implementación

### Prioridad Alta
1. ✅ Admin Dashboard - Vista general
2. ✅ Lista de Artículos con filtros
3. ✅ Asignación de Jurados
4. ✅ Importación de Excel

### Prioridad Media
5. CRUD completo de Artículos
6. CRUD de Estudiantes y Jurados
7. Vista de Evaluaciones

### Prioridad Baja
8. Reportes avanzados
9. Gráficos interactivos
10. Exportación PDF

## 🚀 Cómo Empezar

1. **Configurar DI:**
```dart
// Agregar al injection.dart
sl.registerFactory(() => DashboardBloc(getDashboardStats: sl()));
sl.registerFactory(() => ArticlesBloc(...));
sl.registerLazySingleton(() => GetDashboardStats(sl()));
sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(...));
sl.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl(dio: sl()));
```

2. **Actualizar enrutamiento:**
```dart
// Agregar rutas del admin
MaterialApp(
  routes: {
    '/admin/dashboard': (context) => AdminDashboardPage(),
    '/admin/articles': (context) => ArticlesListPage(),
    // ...
  },
)
```

3. **Ejecutar el backend:**
```bash
cd backend
php artisan migrate:fresh --seed
php artisan serve
```

4. **Ejecutar el frontend:**
```bash
cd frontend
flutter run
```

## 📝 Notas de Desarrollo

- Usar `Provider` o `BlocProvider` para inyectar BLoCs
- Implementar manejo de errores en todos los formularios
- Agregar loading states en todas las operaciones async
- Validar inputs antes de enviar al backend
- Implementar pull-to-refresh en listas
- Agregar confirmación antes de eliminar
- Mostrar SnackBars para feedback de operaciones
- Implementar búsqueda con debounce (500ms)
- Agregar paginación infinita en listas grandes

## 🐛 Troubleshooting

**Error al importar Excel:**
- Verificar que el formato del Excel sea correcto
- Revisar los logs del backend
- Validar que los datos no tengan caracteres especiales

**Error de CORS:**
- Verificar configuración en `backend/config/cors.php`
- Revisar que el middleware esté activo

**Error de autenticación:**
- Verificar que el token se esté enviando en las peticiones
- Revisar que el token no haya expirado

## 📚 Recursos

- [Flutter BLoC](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Laravel Sanctum](https://laravel.com/docs/sanctum)
- [Flutter Charts](https://pub.dev/packages/fl_chart)

---

**Estado:** Backend 100% completo, Frontend estructura base lista
**Próximo paso:** Implementar páginas del admin siguiendo esta guía
