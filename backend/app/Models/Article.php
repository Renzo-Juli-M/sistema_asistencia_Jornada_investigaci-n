<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    protected $fillable = [
        'title',
        'description',
        'user_id',
        'category_id',
        'abstract',
        'keywords',
        'status',
    ];

    /**
     * Get the user (ponente) that owns the article.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the category of the article.
     */
    public function category()
    {
        return $this->belongsTo(ArticleCategory::class, 'category_id');
    }

    /**
     * Get the judge assignments for this article.
     */
    public function assignments()
    {
        return $this->hasMany(JudgeArticleAssignment::class);
    }

    /**
     * Get the judges assigned to this article.
     */
    public function judges()
    {
        return $this->belongsToMany(User::class, 'judge_article_assignments', 'article_id', 'judge_id')
            ->withPivot('status', 'assigned_at', 'completed_at')
            ->withTimestamps();
    }

    /**
     * Get the attendances for this article.
     */
    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }

    /**
     * Get the average score from all judges.
     */
    public function getAverageScoreAttribute()
    {
        $assignments = $this->assignments()->with('evaluations.criteria')->get();

        if ($assignments->isEmpty()) {
            return 0;
        }

        $totalScore = 0;
        $count = 0;

        foreach ($assignments as $assignment) {
            $score = $assignment->average_score;
            if ($score > 0) {
                $totalScore += $score;
                $count++;
            }
        }

        return $count > 0 ? round($totalScore / $count, 2) : 0;
    }
}
