<?php

namespace Database\Seeders;

use App\Models\Authorization;
use App\Models\Event;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
         \App\Models\User::factory(10)->create();

        // Create 10 Authorization records
        Authorization::factory(10)->create();

        // Create 50 Event records associated with random Authorization records
        Event::factory(50)->create();
    }
}
