<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    protected $fillable = [
        'title',
        'description',
        'user_id',
    ];

    /**
     * Get the user (ponente) that owns the article.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
