#include "Game.h"

void Game::Init()
{
    const int screenWidth = 1080;
    const int screenHeight = 720;
    
    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");
    SetTargetFPS(60);
    
    camera_manager.Init();
}

void Game::Run()
{
    while (!WindowShouldClose())
    {
        Update(GetFrameTime());
        
        BeginDrawing();

        ClearBackground(RAYWHITE);
        Render();
        EndDrawing();
    }
    CloseWindow();
}

void Game::Update(float dt)
{
    camera_manager.Update(dt);
}


void Game::Render()
{
    camera_manager.Render();
    camera_manager.begin();
    
    DrawCube({0,0,0}, 2.0f, 2.0f, 2.0f, RED);
    DrawCubeWires({0,0,0}, 2.0f, 2.0f, 2.0f, MAROON);
    DrawGrid(10, 1.0f);
    
    camera_manager.End();
}
