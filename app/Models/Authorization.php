<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Authorization extends Model
{
    use HasFactory;

    protected $table = 'authorization';

    protected $fillable = ['token'];

    public function events()
    {
        return $this->hasMany(Event::class, 'organization_id');
    }
}
