<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ImportController;
use App\Http\Controllers\Api\Admin\DashboardController;
use App\Http\Controllers\Api\Admin\ArticleController;
use App\Http\Controllers\Api\Admin\StudentController;
use App\Http\Controllers\Api\Admin\JudgeController;
use App\Http\Controllers\Api\Admin\AssignmentController;
use App\Http\Controllers\Api\Admin\EvaluationController;
use App\Http\Controllers\Api\Admin\ReportController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public routes - Login endpoints
Route::post('/login/admin', [AuthController::class, 'loginAdmin']);
Route::post('/login/student', [AuthController::class, 'loginStudent']);
Route::post('/login/judge', [AuthController::class, 'loginJudge']);

// Protected routes - Require authentication
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // Import routes (admin only)
    Route::post('/import/students', [ImportController::class, 'importStudents']);
    Route::post('/import/judges', [ImportController::class, 'importJudges']);
    Route::post('/import/articles', [ImportController::class, 'importArticles']);

    // Admin routes
    Route::prefix('admin')->group(function () {
        // Dashboard & Statistics
        Route::get('/dashboard', [DashboardController::class, 'index']);
        Route::get('/dashboard/articles-chart', [DashboardController::class, 'articlesChart']);
        Route::get('/dashboard/attendances-chart', [DashboardController::class, 'attendancesChart']);

        // Articles CRUD
        Route::apiResource('articles', ArticleController::class);
        Route::get('/articles/{id}/statistics', [ArticleController::class, 'statistics']);

        // Students CRUD
        Route::apiResource('students', StudentController::class);

        // Judges CRUD
        Route::apiResource('judges', JudgeController::class);

        // Judge-Article Assignments
        Route::get('/assignments', [AssignmentController::class, 'index']);
        Route::post('/assignments/assign', [AssignmentController::class, 'assign']);
        Route::post('/assignments/assign-multiple', [AssignmentController::class, 'assignMultiple']);
        Route::delete('/assignments/{id}', [AssignmentController::class, 'unassign']);
        Route::get('/assignments/{id}', [AssignmentController::class, 'show']);
        Route::get('/articles/{articleId}/available-judges', [AssignmentController::class, 'availableJudges']);

        // Evaluations
        Route::get('/evaluations', [EvaluationController::class, 'index']);
        Route::get('/evaluations/criteria', [EvaluationController::class, 'getCriteria']);
        Route::post('/evaluations/criteria', [EvaluationController::class, 'storeCriteria']);
        Route::get('/articles/{articleId}/evaluations', [EvaluationController::class, 'getArticleEvaluations']);

        // Reports
        Route::get('/reports/general', [ReportController::class, 'general']);
        Route::get('/reports/articles', [ReportController::class, 'articles']);
        Route::get('/reports/evaluations', [ReportController::class, 'evaluations']);
        Route::get('/reports/attendances', [ReportController::class, 'attendances']);
        Route::get('/reports/export', [ReportController::class, 'export']);
    });
});
