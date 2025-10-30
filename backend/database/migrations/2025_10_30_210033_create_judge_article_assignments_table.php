<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('judge_article_assignments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('judge_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('article_id')->constrained()->onDelete('cascade');
            $table->enum('status', ['pending', 'in_progress', 'completed'])->default('pending');
            $table->timestamp('assigned_at')->useCurrent();
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            // Un jurado no puede ser asignado dos veces al mismo artículo
            $table->unique(['judge_id', 'article_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('judge_article_assignments');
    }
};
