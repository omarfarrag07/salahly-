<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $fillable = ['name_ar','name_en'
    // ,'description_ar','description_en'
];
    //
    public function services()
    {
        return $this->hasMany(Service::class);
    }
}
