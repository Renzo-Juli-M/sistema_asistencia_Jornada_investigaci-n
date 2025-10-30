<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Article;
use App\Models\Attendance;
use App\Models\JudgeArticleAssignment;
use App\Models\ArticleCategory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    /**
     * Get dashboard statistics
     */
    public function index()
    {
        $stats = [
            // Contadores principales
            'total_students' => User::whereHas('role', function ($query) {
                $query->where('name', 'alumno');
            })->count(),

            'total_ponentes' => User::whereHas('role', function ($query) {
                $query->where('name', 'alumno');
            })->where('student_type', 'ponente')->count(),

            'total_oyentes' => User::whereHas('role', function ($query) {
                $query->where('name', 'alumno');
            })->where('student_type', 'oyente')->count(),

            'total_judges' => User::whereHas('role', function ($query) {
                $query->where('name', 'jurado');
            })->count(),

            'total_articles' => Article::count(),

            'total_attendances' => Attendance::count(),

            // Artículos por estado
            'articles_by_status' => Article::select('status', DB::raw('count(*) as count'))
                ->groupBy('status')
                ->get()
                ->mapWithKeys(function ($item) {
                    return [$item->status => $item->count];
                }),

            // Artículos por categoría
            'articles_by_category' => ArticleCategory::withCount('articles')
                ->get()
                ->map(function ($category) {
                    return [
                        'name' => $category->name,
                        'count' => $category->articles_count,
                        'color' => $category->color,
                    ];
                }),

            // Asignaciones por estado
            'assignments_by_status' => JudgeArticleAssignment::select('status', DB::raw('count(*) as count'))
                ->groupBy('status')
                ->get()
                ->mapWithKeys(function ($item) {
                    return [$item->status => $item->count];
                }),

            // Estadísticas de evaluación
            'evaluation_stats' => [
                'total_assignments' => JudgeArticleAssignment::count(),
                'completed_evaluations' => JudgeArticleAssignment::where('status', 'completed')->count(),
                'pending_evaluations' => JudgeArticleAssignment::where('status', 'pending')->count(),
                'in_progress_evaluations' => JudgeArticleAssignment::where('status', 'in_progress')->count(),
            ],

            // Artículos mejor calificados (top 5)
            'top_rated_articles' => Article::with(['user', 'category', 'assignments.evaluations'])
                ->get()
                ->map(function ($article) {
                    return [
                        'id' => $article->id,
                        'title' => $article->title,
                        'author' => $article->user->name,
                        'category' => $article->category ? $article->category->name : 'Sin categoría',
                        'average_score' => $article->average_score,
                    ];
                })
                ->sortByDesc('average_score')
                ->take(5)
                ->values(),

            // Asistencia reciente (últimas 10)
            'recent_attendances' => Attendance::with(['user', 'article'])
                ->latest('check_in')
                ->take(10)
                ->get()
                ->map(function ($attendance) {
                    return [
                        'id' => $attendance->id,
                        'user' => $attendance->user->name,
                        'article' => $attendance->article ? $attendance->article->title : 'General',
                        'check_in' => $attendance->check_in->format('Y-m-d H:i:s'),
                        'status' => $attendance->status,
                    ];
                }),
        ];

        return response()->json($stats);
    }

    /**
     * Get chart data for articles by month
     */
    public function articlesChart()
    {
        $data = Article::select(
            DB::raw('DATE_FORMAT(created_at, "%Y-%m") as month'),
            DB::raw('count(*) as count')
        )
            ->groupBy('month')
            ->orderBy('month')
            ->get();

        return response()->json($data);
    }

    /**
     * Get chart data for attendances by day
     */
    public function attendancesChart()
    {
        $data = Attendance::select(
            DB::raw('DATE(check_in) as date'),
            DB::raw('count(*) as count')
        )
            ->groupBy('date')
            ->orderBy('date', 'desc')
            ->take(30)
            ->get();

        return response()->json($data);
    }
}
