<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Article;
use Illuminate\Http\Request;

class ArticleController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Article::with(['user', 'category', 'assignments.judge']);

        // Filtros
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%")
                  ->orWhere('abstract', 'like', "%{$search}%");
            });
        }

        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Paginación
        $perPage = $request->get('per_page', 15);
        $articles = $query->latest()->paginate($perPage);

        return response()->json($articles);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'abstract' => 'nullable|string',
            'keywords' => 'nullable|string',
            'user_id' => 'required|exists:users,id',
            'category_id' => 'nullable|exists:article_categories,id',
            'status' => 'nullable|in:draft,submitted,under_review,approved,rejected',
        ]);

        $article = Article::create($validated);

        return response()->json([
            'message' => 'Artículo creado exitosamente',
            'article' => $article->load(['user', 'category']),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $article = Article::with([
            'user',
            'category',
            'assignments.judge',
            'assignments.evaluations.criteria',
            'attendances.user'
        ])->findOrFail($id);

        return response()->json($article);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $article = Article::findOrFail($id);

        $validated = $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'abstract' => 'nullable|string',
            'keywords' => 'nullable|string',
            'user_id' => 'sometimes|required|exists:users,id',
            'category_id' => 'nullable|exists:article_categories,id',
            'status' => 'nullable|in:draft,submitted,under_review,approved,rejected',
        ]);

        $article->update($validated);

        return response()->json([
            'message' => 'Artículo actualizado exitosamente',
            'article' => $article->load(['user', 'category']),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $article = Article::findOrFail($id);
        $article->delete();

        return response()->json([
            'message' => 'Artículo eliminado exitosamente',
        ]);
    }

    /**
     * Get article statistics
     */
    public function statistics($id)
    {
        $article = Article::with([
            'assignments.evaluations.criteria',
            'assignments.judge'
        ])->findOrFail($id);

        $stats = [
            'article' => [
                'id' => $article->id,
                'title' => $article->title,
                'author' => $article->user->name,
                'category' => $article->category ? $article->category->name : null,
            ],
            'judges_count' => $article->assignments->count(),
            'completed_evaluations' => $article->assignments->where('status', 'completed')->count(),
            'pending_evaluations' => $article->assignments->where('status', 'pending')->count(),
            'average_score' => $article->average_score,
            'evaluations_by_judge' => $article->assignments->map(function ($assignment) {
                return [
                    'judge' => $assignment->judge->name,
                    'status' => $assignment->status,
                    'average_score' => $assignment->average_score,
                    'evaluations' => $assignment->evaluations->map(function ($evaluation) {
                        return [
                            'criteria' => $evaluation->criteria->name,
                            'score' => $evaluation->score,
                            'max_score' => $evaluation->criteria->max_score,
                            'comments' => $evaluation->comments,
                        ];
                    }),
                ];
            }),
        ];

        return response()->json($stats);
    }
}
