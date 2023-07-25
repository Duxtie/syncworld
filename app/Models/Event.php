<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    use HasFactory;

    protected $table = 'events';

    protected $fillable = ['event_title', 'event_start_date', 'event_end_date', 'organization_id'];

    public static $rules = [
        'event_title' => 'required',
        'event_start_date' => 'required|date_format:Y-m-d H:i:s',
        'event_end_date' => 'required|date_format:Y-m-d H:i:s|after:event_start_date|before:+12 hours',
        'organization_id' => 'required|exists:authorization,id',
    ];


    public function authorization()
    {
        return $this->belongsTo(Authorization::class, 'organization_id');
    }
}
