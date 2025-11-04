<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\EvaluationCriteria;

class EvaluationCriteriaSeeder extends Seeder
{
    public function run(): void
    {
        $criteria = [
            [
                'name' => 'Metodología',
                'description' => 'Claridad y adecuación del método de investigación.',
                'max_score' => 10,
                'weight' => 2,
            ],
            [
                'name' => 'Originalidad',
                'description' => 'Nivel de innovación o aporte del trabajo.',
                'max_score' => 10,
                'weight' => 1,
            ],
            [
                'name' => 'Presentación',
                'description' => 'Claridad de exposición y calidad visual.',
                'max_score' => 10,
                'weight' => 1,
            ],
            [
                'name' => 'Resultados y Discusión',
                'description' => 'Interpretación adecuada de los resultados.',
                'max_score' => 10,
                'weight' => 2,
            ],
        ];

        foreach ($criteria as $item) {
            DB::table('evaluation_criteria')->updateOrInsert(
                ['name' => $item['name']],
                $item
            );
        }
    }
}
