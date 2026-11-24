#pragma once
#include "CameraManager.h"
#include "raylib.h"
class Game
{
public:
    void Init();
    void Run();
    
private:
    void Update(float dt);
    void Render();
    
    CameraManager camera_manager;
    
};
