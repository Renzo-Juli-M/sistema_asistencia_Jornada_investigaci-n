# API de Administración

Documentación completa de los endpoints del administrador.

## Autenticación

Todas las rutas requieren autenticación con token Sanctum:
```
Authorization: Bearer {token}
```

## Dashboard y Estadísticas

### GET /api/admin/dashboard
Obtiene estadísticas generales del sistema.

**Respuesta:**
```json
{
  "total_students": 50,
  "total_ponentes": 20,
  "total_oyentes": 30,
  "total_judges": 10,
  "total_articles": 25,
  "total_attendances": 150,
  "articles_by_status": {
    "submitted": 15,
    "under_review": 5,
    "approved": 5
  },
  "articles_by_category": [...],
  "assignments_by_status": {...},
  "evaluation_stats": {...},
  "top_rated_articles": [...],
  "recent_attendances": [...]
}
```

### GET /api/admin/dashboard/articles-chart
Obtiene datos para gráfico de artículos por mes.

### GET /api/admin/dashboard/attendances-chart
Obtiene datos para gráfico de asistencias por día.

## Artículos

### GET /api/admin/articles
Lista todos los artículos con paginación.

**Query Parameters:**
- `search` - Buscar por título, descripción o abstract
- `category_id` - Filtrar por categoría
- `status` - Filtrar por estado (draft, submitted, under_review, approved, rejected)
- `user_id` - Filtrar por autor
- `per_page` - Resultados por página (default: 15)

**Respuesta:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Inteligencia Artificial en Medicina",
      "description": "...",
      "abstract": "...",
      "keywords": "AI, Healthcare, ML",
      "status": "approved",
      "user": {...},
      "category": {...},
      "assignments": [...]
    }
  ],
  "links": {...},
  "meta": {...}
}
```

### POST /api/admin/articles
Crea un nuevo artículo.

**Body:**
```json
{
  "title": "Título del artículo",
  "description": "Descripción completa",
  "abstract": "Resumen ejecutivo",
  "keywords": "palabra1, palabra2",
  "user_id": 5,
  "category_id": 2,
  "status": "submitted"
}
```

### GET /api/admin/articles/{id}
Obtiene detalles completos de un artículo.

### PUT /api/admin/articles/{id}
Actualiza un artículo.

### DELETE /api/admin/articles/{id}
Elimina un artículo.

### GET /api/admin/articles/{id}/statistics
Obtiene estadísticas detalladas de un artículo incluyendo evaluaciones.

**Respuesta:**
```json
{
  "article": {...},
  "judges_count": 3,
  "completed_evaluations": 2,
  "pending_evaluations": 1,
  "average_score": 85.5,
  "evaluations_by_judge": [
    {
      "judge": "Dr. García",
      "status": "completed",
      "average_score": 88,
      "evaluations": [
        {
          "criteria": "Metodología",
          "score": 18,
          "max_score": 20,
          "comments": "Excelente trabajo"
        }
      ]
    }
  ]
}
```

## Estudiantes

### GET /api/admin/students
Lista todos los estudiantes.

### POST /api/admin/students
Crea un nuevo estudiante.

### GET /api/admin/students/{id}
Obtiene detalles de un estudiante.

### PUT /api/admin/students/{id}
Actualiza un estudiante.

### DELETE /api/admin/students/{id}
Elimina un estudiante.

## Jurados

### GET /api/admin/judges
Lista todos los jurados.

### POST /api/admin/judges
Crea un nuevo jurado.

### GET /api/admin/judges/{id}
Obtiene detalles de un jurado.

### PUT /api/admin/judges/{id}
Actualiza un jurado.

### DELETE /api/admin/judges/{id}
Elimina un jurado.

## Asignación de Jurados

### GET /api/admin/assignments
Lista todas las asignaciones jurado-artículo.

**Query Parameters:**
- `status` - Filtrar por estado (pending, in_progress, completed)
- `judge_id` - Filtrar por jurado
- `article_id` - Filtrar por artículo
- `per_page` - Resultados por página

### POST /api/admin/assignments/assign
Asigna un jurado a un artículo.

**Body:**
```json
{
  "judge_id": 3,
  "article_id": 5
}
```

### POST /api/admin/assignments/assign-multiple
Asigna múltiples jurados a un artículo.

**Body:**
```json
{
  "judge_ids": [3, 5, 7],
  "article_id": 5
}
```

**Nota:** Requiere mínimo 2 jurados por artículo.

### GET /api/admin/assignments/{id}
Obtiene detalles de una asignación.

### DELETE /api/admin/assignments/{id}
Elimina una asignación (solo si no tiene evaluaciones).

### GET /api/admin/articles/{articleId}/available-judges
Obtiene lista de jurados disponibles (no asignados) para un artículo.

## Evaluaciones

### GET /api/admin/evaluations
Lista todas las evaluaciones.

### GET /api/admin/evaluations/criteria
Obtiene todos los criterios de evaluación.

**Respuesta:**
```json
[
  {
    "id": 1,
    "name": "Metodología",
    "description": "Rigurosidad y coherencia de la metodología",
    "max_score": 20,
    "weight": 2,
    "is_active": true
  }
]
```

### POST /api/admin/evaluations/criteria
Crea un nuevo criterio de evaluación.

**Body:**
```json
{
  "name": "Innovación",
  "description": "Nivel de innovación propuesto",
  "max_score": 10,
  "weight": 1,
  "is_active": true
}
```

### GET /api/admin/articles/{articleId}/evaluations
Obtiene todas las evaluaciones de un artículo.

## Reportes

### GET /api/admin/reports/general
Genera reporte general del evento.

### GET /api/admin/reports/articles
Genera reporte detallado de artículos.

### GET /api/admin/reports/evaluations
Genera reporte de evaluaciones y calificaciones.

### GET /api/admin/reports/attendances
Genera reporte de asistencias.

### GET /api/admin/reports/export
Exporta reportes en formato Excel.

**Query Parameters:**
- `type` - Tipo de reporte (general, articles, evaluations, attendances)
- `format` - Formato (xlsx, csv, pdf)

## Importación de Datos

### POST /api/import/students
Importa estudiantes desde Excel.

**Body (multipart/form-data):**
- `file` - Archivo Excel (.xlsx, .xls, .csv)

**Formato Excel:**
- nombre
- email
- dni
- codigo_estudiante
- tipo (ponente/oyente)

### POST /api/import/judges
Importa jurados desde Excel.

**Formato Excel:**
- nombre
- email
- dni
- username

### POST /api/import/articles
Importa artículos desde Excel.

**Formato Excel:**
- titulo
- descripcion
- dni_ponente

## Códigos de Estado

- `200` - Éxito
- `201` - Creado exitosamente
- `400` - Error de validación
- `401` - No autenticado
- `403` - No autorizado
- `404` - No encontrado
- `500` - Error del servidor

## Ejemplo de Uso (cURL)

```bash
# Obtener dashboard
curl -X GET http://localhost:8000/api/admin/dashboard \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"

# Crear artículo
curl -X POST http://localhost:8000/api/admin/articles \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Mi Investigación",
    "description": "Descripción completa",
    "user_id": 5,
    "category_id": 1
  }'

# Asignar jurados
curl -X POST http://localhost:8000/api/admin/assignments/assign-multiple \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "judge_ids": [3, 5],
    "article_id": 10
  }'
```

## Próximas Funcionalidades

- ✅ Sistema de notificaciones
- ✅ Exportación avanzada de reportes
- ✅ Análisis estadístico avanzado
- ✅ Gestión de eventos/sesiones
- ✅ Sistema de comentarios en artículos
