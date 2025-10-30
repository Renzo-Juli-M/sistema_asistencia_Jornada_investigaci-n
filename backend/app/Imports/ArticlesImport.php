<?php

namespace App\Imports;

use App\Models\Article;
use App\Models\User;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class ArticlesImport implements ToModel, WithHeadingRow
{
    /**
    * @param array $row
    *
    * Excel columns expected: titulo, descripcion, dni_ponente
    *
    * @return \Illuminate\Database\Eloquent\Model|null
    */
    public function model(array $row)
    {
        // Find the student ponente by DNI
        $ponente = User::where('dni', $row['dni_ponente'])
            ->where('student_type', 'ponente')
            ->whereHas('role', function ($query) {
                $query->where('name', 'alumno');
            })
            ->first();

        if (!$ponente) {
            return null; // Skip if ponente not found
        }

        return new Article([
            'title' => $row['titulo'],
            'description' => $row['descripcion'] ?? null,
            'user_id' => $ponente->id,
        ]);
    }
}
