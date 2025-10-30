<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Login for Admin (Email + Password)
     */
    public function loginAdmin(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)
            ->whereHas('role', function ($query) {
                $query->where('name', 'admin');
            })
            ->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Las credenciales proporcionadas son incorrectas.'],
            ]);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Login exitoso',
            'user' => $user->load('role'),
            'token' => $token,
        ]);
    }

    /**
     * Login for Student (DNI + Student Code)
     */
    public function loginStudent(Request $request)
    {
        $request->validate([
            'dni' => 'required',
            'student_code' => 'required',
        ]);

        $user = User::where('dni', $request->dni)
            ->where('student_code', $request->student_code)
            ->whereHas('role', function ($query) {
                $query->where('name', 'alumno');
            })
            ->first();

        if (!$user) {
            throw ValidationException::withMessages([
                'dni' => ['Las credenciales proporcionadas son incorrectas.'],
            ]);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Login exitoso',
            'user' => $user->load('role'),
            'token' => $token,
        ]);
    }

    /**
     * Login for Judge (Username + DNI)
     */
    public function loginJudge(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'dni' => 'required',
        ]);

        $user = User::where('username', $request->username)
            ->where('dni', $request->dni)
            ->whereHas('role', function ($query) {
                $query->where('name', 'jurado');
            })
            ->first();

        if (!$user) {
            throw ValidationException::withMessages([
                'username' => ['Las credenciales proporcionadas son incorrectas.'],
            ]);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Login exitoso',
            'user' => $user->load('role'),
            'token' => $token,
        ]);
    }

    /**
     * Logout
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout exitoso',
        ]);
    }

    /**
     * Get authenticated user
     */
    public function me(Request $request)
    {
        return response()->json([
            'user' => $request->user()->load('role', 'articles'),
        ]);
    }
}
