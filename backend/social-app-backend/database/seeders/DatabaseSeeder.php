<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Post;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::factory(5)->create()->each(function ($user) {
            Post::factory(2)->create(['user_id' => $user->id]);
        });
    }
}