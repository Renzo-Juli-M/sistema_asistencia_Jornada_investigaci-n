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
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('role_id')->nullable()->constrained()->onDelete('cascade');
            $table->string('dni')->unique()->nullable();
            $table->string('username')->unique()->nullable();
            $table->string('student_code')->nullable(); // código de estudiante
            $table->enum('student_type', ['ponente', 'oyente'])->nullable(); // tipo de alumno
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['role_id']);
            $table->dropColumn(['role_id', 'dni', 'username', 'student_code', 'student_type']);
        });
    }
};
