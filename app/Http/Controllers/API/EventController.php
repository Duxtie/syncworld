<?php

namespace App\Http\Controllers\API;

use App\helpers\ApiResponse;
use App\Http\Requests\EventRequest;
use App\Http\Resources\EventResource;
use App\Models\Authorization;
use App\Models\Event;
use App\Http\Controllers\Controller;

class EventController extends Controller
{
    public function index()
    {
        $authorisation = Authorization::where('token', request()->token)->first();

        if (!$authorisation) {
            return ApiResponse::error('Invalid Token', 404);
        }

        $events = Event::where('organization_id', $authorisation->id)->simplePaginate(10);

        return EventResource::collection($events);
    }

    public function show($id)
    {
        try {
            $event = Event::findOrFail($id);
            return new EventResource($event);
        } catch (\Exception $e) {
            return ApiResponse::error('Event not found', 404);
        }
    }

    public function store(EventRequest $request)
    {
        $event = Event::create($request->all());
        return new EventResource($event);
    }

    public function update(EventRequest $request, $id)
    {
        try {
            $event = Event::findOrFail($id);
            $event->update($request->all());
            return new EventResource($event);
        } catch (\Exception $e) {
            return ApiResponse::error('Event not found', 404);
        }
    }

    public function partialUpdate(EventRequest $request, $id)
    {
        try {
            $event = Event::findOrFail($id);
            $event->update($request->only(['event_title', 'event_start_date', 'event_end_date']));
            return new EventResource($event);
        } catch (\Exception $e) {
            return ApiResponse::error('Event not found', 404);
        }
    }

    public function destroy($id)
    {
        try {
            $event = Event::findOrFail($id);
            $event->delete();
            return ApiResponse::success([], 'Event deleted successfully');
        } catch (\Exception $e) {
            return ApiResponse::error('Event not found', 404);
        }
    }
}
