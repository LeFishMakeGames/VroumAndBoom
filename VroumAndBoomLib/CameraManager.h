#pragma once
#include "raylib.h"
class CameraManager
{
public:
    void Init();
    void Update(float dt);
    
    void begin() const {BeginMode3D(camera);}
    void End() const {EndMode3D();}
   
    Camera3D& GetCamera() {return camera;}
    
    
private:
    Camera3D camera;
};
