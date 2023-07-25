<?php

namespace Tests\Feature;

use App\Models\Authorization;
use App\Models\Event;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class EventControllerTest extends TestCase
{
    use RefreshDatabase;

    private $authorization;

    private $user;

    protected function setUp(): void
    {
        parent::setUp();

        // Create an authorization token for testing purposes
        $this->authorization = Authorization::factory()->create();
        Sanctum::actingAs(
            User::factory()->create(),
            ['*']
        );
    }

    /** @test */
    public function it_can_create_a_new_event()
    {
        $eventData = [
            'event_title' => 'Test Event',
            'event_start_date' => '2023-07-30 10:00:00',
            'event_end_date' => '2023-07-30 12:00:00',
            'organization_id' => $this->authorization->id,
        ];

        $response = $this->postJson('/api/v1', $eventData);

        $response->assertStatus(201)
            ->assertJson([
                'data' => $eventData
            ]);

        $this->assertDatabaseHas('events', $eventData);
    }

    /** @test */
    /** @test */
    public function it_can_partially_update_an_event_using_patch_method()
    {
        $event = Event::factory()->create(['organization_id' => $this->authorization->id]);

        $partialData = [
            'event_title' => 'Updated Title',
        ];

        $response = $this->patchJson("/api/v1/{$event->id}", $partialData);

        $response->assertStatus(200)
            ->assertJson([
                'data' => array_merge($event->toArray(), $partialData)
            ]);

        $this->assertDatabaseHas('events', array_merge(['id' => $event->id], $partialData));
    }


    /** @test */
    public function it_can_show_an_event()
    {
        $event = Event::factory()->create(['organization_id' => $this->authorization->id]);

        $response = $this->actingAs($this->user)
            ->getJson("/api/v1/{$event->id}");

        $response->assertStatus(200)
            ->assertJson([
                'data' => $event->toArray()
            ]);
    }



}
