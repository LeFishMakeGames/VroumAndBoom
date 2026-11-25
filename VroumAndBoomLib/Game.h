#pragma once
#include "CameraManager.h"
#include "GameState/GameState.h"
#include "raylib.h"
class Game
{
public:
    void Init();
    void Run();

    int getWidth() const
    {
        return screenWidth;
    }
    int getHeight() const
    {
        return screenHeight;
    }
    
private:
    void Update(float dt);
    void Render();
    
    CameraManager camera_manager;
    
    const int screenWidth = 1080;
    const int screenHeight = 720;
    
    GameState* state = nullptr;
};
