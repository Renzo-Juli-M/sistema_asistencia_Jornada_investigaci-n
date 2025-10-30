<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ImportController;

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
});
