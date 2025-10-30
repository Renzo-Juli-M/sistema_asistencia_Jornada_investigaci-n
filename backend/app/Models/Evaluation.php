<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Evaluation extends Model
{
    protected $fillable = [
        'assignment_id',
        'criteria_id',
        'score',
        'comments',
    ];

    protected $casts = [
        'score' => 'decimal:2',
    ];

    public function assignment()
    {
        return $this->belongsTo(JudgeArticleAssignment::class, 'assignment_id');
    }

    public function criteria()
    {
        return $this->belongsTo(EvaluationCriteria::class, 'criteria_id');
    }
}
