<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::prefix('v1')
    ->namespace('App\Http\Controllers\API')->group(function () {

        Route::post('/register', 'AuthController@register')->name('register');
        Route::post('/login', 'AuthController@login')->name('login');

        Route::middleware('auth:sanctum')->group(function () {
            Route::post('/logout', 'AuthController@logout');

            Route::get('/list', 'EventController@index');
            Route::post('/', 'EventController@store');
            Route::get('/{id}', 'EventController@show');
            Route::put('/{id}', 'EventController@update'); // Use PUT for replacing the entire event
            Route::patch('/{id}', 'EventController@partialUpdate'); // Use PATCH for partial updates
            Route::delete('/{id}', 'EventController@destroy');

        });

    });
