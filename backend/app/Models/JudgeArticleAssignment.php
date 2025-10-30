<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class JudgeArticleAssignment extends Model
{
    protected $fillable = [
        'judge_id',
        'article_id',
        'status',
        'assigned_at',
        'completed_at',
    ];

    protected $casts = [
        'assigned_at' => 'datetime',
        'completed_at' => 'datetime',
    ];

    public function judge()
    {
        return $this->belongsTo(User::class, 'judge_id');
    }

    public function article()
    {
        return $this->belongsTo(Article::class);
    }

    public function evaluations()
    {
        return $this->hasMany(Evaluation::class, 'assignment_id');
    }

    // Obtener calificación promedio de esta asignación
    public function getAverageScoreAttribute()
    {
        $evaluations = $this->evaluations()->with('criteria')->get();

        if ($evaluations->isEmpty()) {
            return 0;
        }

        $totalWeightedScore = 0;
        $totalWeight = 0;

        foreach ($evaluations as $evaluation) {
            $weight = $evaluation->criteria->weight;
            $totalWeightedScore += $evaluation->score * $weight;
            $totalWeight += $weight;
        }

        return $totalWeight > 0 ? round($totalWeightedScore / $totalWeight, 2) : 0;
    }
}
