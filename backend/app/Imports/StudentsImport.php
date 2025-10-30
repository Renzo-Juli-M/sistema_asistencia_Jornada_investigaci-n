<?php

namespace App\Imports;

use App\Models\User;
use App\Models\Role;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class StudentsImport implements ToModel, WithHeadingRow
{
    /**
    * @param array $row
    *
    * Excel columns expected: nombre, email, dni, codigo_estudiante, tipo
    * tipo can be: ponente or oyente
    *
    * @return \Illuminate\Database\Eloquent\Model|null
    */
    public function model(array $row)
    {
        $studentRole = Role::where('name', 'alumno')->first();

        if (!$studentRole) {
            return null;
        }

        // Check if student already exists
        $existingStudent = User::where('dni', $row['dni'])->first();

        if ($existingStudent) {
            return null; // Skip if already exists
        }

        return new User([
            'name' => $row['nombre'],
            'email' => $row['email'],
            'dni' => $row['dni'],
            'student_code' => $row['codigo_estudiante'],
            'student_type' => $row['tipo'], // ponente or oyente
            'role_id' => $studentRole->id,
            'password' => bcrypt('defaultpassword'), // Default password
        ]);
    }
}
