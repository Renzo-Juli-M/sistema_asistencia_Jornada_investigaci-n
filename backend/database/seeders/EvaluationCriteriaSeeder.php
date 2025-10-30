<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\EvaluationCriteria;

class EvaluationCriteriaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $criteria = [
            [
                'name' => 'Metodología',
                'description' => 'Rigurosidad y coherencia de la metodología utilizada',
                'max_score' => 20,
                'weight' => 2,
            ],
            [
                'name' => 'Originalidad',
                'description' => 'Novedad y aporte de la investigación',
                'max_score' => 15,
                'weight' => 2,
            ],
            [
                'name' => 'Relevancia',
                'description' => 'Importancia y aplicabilidad del tema',
                'max_score' => 15,
                'weight' => 1,
            ],
            [
                'name' => 'Presentación',
                'description' => 'Calidad de la exposición oral y apoyo visual',
                'max_score' => 20,
                'weight' => 1,
            ],
            [
                'name' => 'Dominio del Tema',
                'description' => 'Conocimiento y manejo del tema por parte del expositor',
                'max_score' => 20,
                'weight' => 2,
            ],
            [
                'name' => 'Resultados',
                'description' => 'Calidad y coherencia de los resultados obtenidos',
                'max_score' => 10,
                'weight' => 1,
            ],
        ];

        foreach ($criteria as $criterion) {
            EvaluationCriteria::firstOrCreate(
                ['name' => $criterion['name']],
                $criterion
            );
        }
    }
}
