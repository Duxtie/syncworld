<?php

namespace Database\Factories;

use App\Models\Authorization;
use Illuminate\Database\Eloquent\Factories\Factory;

class EventFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'event_title' => $this->faker->sentence,
            'event_start_date' => $this->faker->dateTimeBetween('-1 week', '+1 week')->format('Y-m-d H:i:s'),
            'event_end_date' => $this->faker->dateTimeBetween('+1 week', '+2 weeks')->format('Y-m-d H:i:s'),
            'organization_id' => function () {
                return Authorization::inRandomOrder()->first()->id;
            },
        ];
    }
}
