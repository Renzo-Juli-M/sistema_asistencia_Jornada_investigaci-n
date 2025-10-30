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
        Schema::create('evaluations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('assignment_id')->constrained('judge_article_assignments')->onDelete('cascade');
            $table->foreignId('criteria_id')->constrained('evaluation_criteria')->onDelete('cascade');
            $table->decimal('score', 5, 2); // Calificación con 2 decimales
            $table->text('comments')->nullable(); // Comentarios del jurado
            $table->timestamps();

            // Un jurado solo puede evaluar un criterio una vez por asignación
            $table->unique(['assignment_id', 'criteria_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('evaluations');
    }
};
