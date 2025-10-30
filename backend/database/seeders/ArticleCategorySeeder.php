<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\ArticleCategory;

class ArticleCategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Ciencias de la Computación',
                'description' => 'Investigaciones relacionadas con programación, algoritmos, inteligencia artificial, etc.',
                'color' => '#3B82F6',
            ],
            [
                'name' => 'Ingeniería de Software',
                'description' => 'Metodologías, arquitecturas y patrones de desarrollo de software',
                'color' => '#10B981',
            ],
            [
                'name' => 'Redes y Comunicaciones',
                'description' => 'Protocolos de red, seguridad, IoT y comunicaciones',
                'color' => '#F59E0B',
            ],
            [
                'name' => 'Base de Datos',
                'description' => 'Sistemas de gestión de bases de datos, Big Data, Analytics',
                'color' => '#EF4444',
            ],
            [
                'name' => 'Seguridad Informática',
                'description' => 'Ciberseguridad, criptografía, análisis de vulnerabilidades',
                'color' => '#8B5CF6',
            ],
            [
                'name' => 'Inteligencia Artificial',
                'description' => 'Machine Learning, Deep Learning, NLP, Computer Vision',
                'color' => '#EC4899',
            ],
        ];

        foreach ($categories as $category) {
            ArticleCategory::firstOrCreate(
                ['name' => $category['name']],
                $category
            );
        }
    }
}
