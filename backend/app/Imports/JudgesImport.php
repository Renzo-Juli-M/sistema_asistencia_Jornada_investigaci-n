<?php

namespace App\Imports;

use App\Models\User;
use App\Models\Role;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class JudgesImport implements ToModel, WithHeadingRow
{
    /**
    * @param array $row
    *
    * Excel columns expected: nombre, email, dni, username
    *
    * @return \Illuminate\Database\Eloquent\Model|null
    */
    public function model(array $row)
    {
        $judgeRole = Role::where('name', 'jurado')->first();

        if (!$judgeRole) {
            return null;
        }

        // Check if judge already exists
        $existingJudge = User::where('dni', $row['dni'])->first();

        if ($existingJudge) {
            return null; // Skip if already exists
        }

        return new User([
            'name' => $row['nombre'],
            'email' => $row['email'],
            'dni' => $row['dni'],
            'username' => $row['username'],
            'role_id' => $judgeRole->id,
            'password' => bcrypt('defaultpassword'), // Default password
        ]);
    }
}
