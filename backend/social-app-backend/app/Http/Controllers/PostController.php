<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Post;
use Illuminate\Support\Facades\Storage;

class PostController extends Controller
{
    public function index()
    {
        $posts = Post::with('user', 'likes', 'comments.user')->get();
        return response()->json($posts);
    }

    public function guestIndex()
    {
        $posts = Post::with('user', 'likes', 'comments.user')->get();
        return response()->json($posts);
    }

    public function store(Request $request)
    {
        $request->validate([
            'content' => 'string|nullable',
            'image' => 'image|nullable|max:2048',
        ]);

        $post = new Post();
        $post->user_id = auth()->id();
        $post->content = $request->content;

        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('public/post_images');
            $post->image_url = Storage::url($path);
        }

        $post->save();

        return response()->json($post->load('user', 'likes', 'comments.user'), 201);
    }

    public function show($id)
    {
        $post = Post::with('user', 'likes', 'comments.user')->findOrFail($id);
        return response()->json($post);
    }

    public function update(Request $request, $id)
    {
        $post = Post::findOrFail($id);
        if ($post->user_id !== auth()->id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'content' => 'string|nullable',
            'image' => 'image|nullable|max:2048',
        ]);

        $post->content = $request->content ?? $post->content;

        if ($request->hasFile('image')) {
            if ($post->image_url) {
                Storage::delete(str_replace('storage/', 'public/', $post->image_url));
            }
            $path = $request->file('image')->store('public/post_images');
            $post->image_url = Storage::url($path);
        }

        $post->save();

        return response()->json($post->load('user', 'likes', 'comments.user'));
    }

    public function destroy($id)
    {
        $post = Post::findOrFail($id);
        if ($post->user_id !== auth()->id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        if ($post->image_url) {
            Storage::delete(str_replace('storage/', 'public/', $post->image_url));
        }

        $post->delete();

        return response()->json(null, 204);
    }
}