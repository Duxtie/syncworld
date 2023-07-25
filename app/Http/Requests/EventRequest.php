<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class EventRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        // Get the event ID from the route parameters if available (for edit)
        $eventId = $this->route('id');

        // Validation rules for both create and edit operations
        return [
            'event_title' => 'required|string|max:200',
            'event_start_date' => 'required|date_format:Y-m-d H:i:s',
            'event_end_date' => 'required|date_format:Y-m-d H:i:s|after:event_start_date|after:+12 hours',
            'organization_id' => 'required|integer|exists:authorization,id',
            'id' => 'sometimes|required|integer|exists:events,id' . ($eventId ? ",$eventId" : ''),
        ];
    }
}
