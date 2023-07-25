<?php

namespace App\helpers;

use Illuminate\Http\JsonResponse;

class ApiResponse
{
    public static function success($data = null, $message = null, $statusCode = 200): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'data' => $data,
            'message' => $message,
        ], $statusCode);
    }
    public static function paginatedSuccess($data, $message = null, $statusCode = 200)
    {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data,
//            'pagination' => [
//                'current_page' => $data['meta']['current_page'],
//                'from' => $data['meta']['from'],
//                'to' => $data['meta']['to'],
//                'per_page' => $data['meta']['per_page'],
//                'total' => $data['meta']['total'],
//            ],
        ], $statusCode);
    }

    public static function error($message = 'An error occurred', $statusCode = 500): JsonResponse
    {
        return response()->json([
            'status' => 'error',
            'message' => $message,
        ], $statusCode);
    }
}
