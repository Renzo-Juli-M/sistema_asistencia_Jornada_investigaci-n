<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\JudgeArticleAssignment;
use App\Models\Article;
use App\Models\User;
use Illuminate\Http\Request;

class AssignmentController extends Controller
{
    /**
     * Get all assignments
     */
    public function index(Request $request)
    {
        $query = JudgeArticleAssignment::with(['judge', 'article.user', 'evaluations.criteria']);

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('judge_id')) {
            $query->where('judge_id', $request->judge_id);
        }

        if ($request->has('article_id')) {
            $query->where('article_id', $request->article_id);
        }

        $perPage = $request->get('per_page', 15);
        $assignments = $query->latest()->paginate($perPage);

        return response()->json($assignments);
    }

    /**
     * Assign a judge to an article
     */
    public function assign(Request $request)
    {
        $validated = $request->validate([
            'judge_id' => 'required|exists:users,id',
            'article_id' => 'required|exists:articles,id',
        ]);

        // Verificar que el usuario es jurado
        $judge = User::findOrFail($validated['judge_id']);
        if (!$judge->isJudge()) {
            return response()->json([
                'message' => 'El usuario seleccionado no es un jurado',
            ], 400);
        }

        // Verificar que no esté ya asignado
        $exists = JudgeArticleAssignment::where('judge_id', $validated['judge_id'])
            ->where('article_id', $validated['article_id'])
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Este jurado ya está asignado a este artículo',
            ], 400);
        }

        $assignment = JudgeArticleAssignment::create($validated);

        return response()->json([
            'message' => 'Jurado asignado exitosamente',
            'assignment' => $assignment->load(['judge', 'article']),
        ], 201);
    }

    /**
     * Assign multiple judges to an article
     */
    public function assignMultiple(Request $request)
    {
        $validated = $request->validate([
            'judge_ids' => 'required|array|min:2',
            'judge_ids.*' => 'exists:users,id',
            'article_id' => 'required|exists:articles,id',
        ]);

        $article = Article::findOrFail($validated['article_id']);
        $assignments = [];

        foreach ($validated['judge_ids'] as $judgeId) {
            // Verificar que el usuario es jurado
            $judge = User::find($judgeId);
            if (!$judge || !$judge->isJudge()) {
                continue;
            }

            // Verificar que no esté ya asignado
            $exists = JudgeArticleAssignment::where('judge_id', $judgeId)
                ->where('article_id', $validated['article_id'])
                ->exists();

            if (!$exists) {
                $assignment = JudgeArticleAssignment::create([
                    'judge_id' => $judgeId,
                    'article_id' => $validated['article_id'],
                ]);
                $assignments[] = $assignment->load(['judge', 'article']);
            }
        }

        return response()->json([
            'message' => 'Jurados asignados exitosamente',
            'assignments' => $assignments,
            'count' => count($assignments),
        ], 201);
    }

    /**
     * Unassign a judge from an article
     */
    public function unassign($id)
    {
        $assignment = JudgeArticleAssignment::findOrFail($id);

        // Solo permitir eliminar si no tiene evaluaciones
        if ($assignment->evaluations()->exists()) {
            return response()->json([
                'message' => 'No se puede eliminar la asignación porque ya tiene evaluaciones registradas',
            ], 400);
        }

        $assignment->delete();

        return response()->json([
            'message' => 'Asignación eliminada exitosamente',
        ]);
    }

    /**
     * Get available judges for an article (not assigned yet)
     */
    public function availableJudges($articleId)
    {
        $article = Article::findOrFail($articleId);

        // Obtener IDs de jurados ya asignados
        $assignedJudgeIds = $article->assignments()->pluck('judge_id');

        // Obtener jurados no asignados
        $availableJudges = User::whereHas('role', function ($query) {
            $query->where('name', 'jurado');
        })
        ->whereNotIn('id', $assignedJudgeIds)
        ->select('id', 'name', 'email', 'username')
        ->get();

        return response()->json($availableJudges);
    }

    /**
     * Get assignment details with evaluations
     */
    public function show($id)
    {
        $assignment = JudgeArticleAssignment::with([
            'judge',
            'article.user',
            'article.category',
            'evaluations.criteria'
        ])->findOrFail($id);

        return response()->json($assignment);
    }
}
