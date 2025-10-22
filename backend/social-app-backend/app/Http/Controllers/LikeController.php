<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Like;
use App\Models\Post;

class LikeController extends Controller
{
    public function toggle(Request $request, $postId)
    {
        $userId = auth()->id();
        $like = Like::where('user_id', $userId)->where('post_id', $postId)->first();

        if ($like) {
            $like->delete();
            return response()->json(['message' => 'Unliked']);
        } else {
            Like::create(['user_id' => $userId, 'post_id' => $postId]);
            return response()->json(['message' => 'Liked']);
        }
    }
}