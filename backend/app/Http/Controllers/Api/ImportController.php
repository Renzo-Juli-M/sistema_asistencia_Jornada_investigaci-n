<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Imports\StudentsImport;
use App\Imports\JudgesImport;
use App\Imports\ArticlesImport;
use Maatwebsite\Excel\Facades\Excel;

class ImportController extends Controller
{
    /**
     * Import students from Excel file
     */
    public function importStudents(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,xls,csv',
        ]);

        try {
            Excel::import(new StudentsImport, $request->file('file'));

            return response()->json([
                'message' => 'Estudiantes importados exitosamente',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al importar estudiantes',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Import judges from Excel file
     */
    public function importJudges(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,xls,csv',
        ]);

        try {
            Excel::import(new JudgesImport, $request->file('file'));

            return response()->json([
                'message' => 'Jurados importados exitosamente',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al importar jurados',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Import articles from Excel file
     */
    public function importArticles(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,xls,csv',
        ]);

        try {
            Excel::import(new ArticlesImport, $request->file('file'));

            return response()->json([
                'message' => 'Artículos importados exitosamente',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al importar artículos',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
