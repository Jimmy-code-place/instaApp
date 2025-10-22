<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class PostFactory extends Factory
{
    public function definition(): array
    {
        return [
            'user_id' => \App\Models\User::factory(),
            'content' => fake()->paragraph(),
            'image_url' => 'https://picsum.photos/seed/' . Str::random(10) . '/400/300',// Fake image path
        ];
    }
}