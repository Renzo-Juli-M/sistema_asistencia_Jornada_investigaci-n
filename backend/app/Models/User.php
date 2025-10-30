<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role_id',
        'dni',
        'username',
        'student_code',
        'student_type',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    /**
     * Get the role that the user belongs to.
     */
    public function role()
    {
        return $this->belongsTo(Role::class);
    }

    /**
     * Get the articles for the user (if student is ponente).
     */
    public function articles()
    {
        return $this->hasMany(Article::class);
    }

    /**
     * Check if user is admin
     */
    public function isAdmin()
    {
        return $this->role && $this->role->name === 'admin';
    }

    /**
     * Check if user is judge (jurado)
     */
    public function isJudge()
    {
        return $this->role && $this->role->name === 'jurado';
    }

    /**
     * Check if user is student (alumno)
     */
    public function isStudent()
    {
        return $this->role && $this->role->name === 'alumno';
    }

    /**
     * Check if student is ponente
     */
    public function isPonente()
    {
        return $this->isStudent() && $this->student_type === 'ponente';
    }

    /**
     * Check if student is oyente
     */
    public function isOyente()
    {
        return $this->isStudent() && $this->student_type === 'oyente';
    }
}
