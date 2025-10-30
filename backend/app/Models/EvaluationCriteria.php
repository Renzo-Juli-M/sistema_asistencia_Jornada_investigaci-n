<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EvaluationCriteria extends Model
{
    protected $fillable = [
        'name',
        'description',
        'max_score',
        'weight',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'max_score' => 'integer',
        'weight' => 'integer',
    ];

    public function evaluations()
    {
        return $this->hasMany(Evaluation::class, 'criteria_id');
    }
}
