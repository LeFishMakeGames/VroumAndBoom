#pragma once
#include "raylib.h"
#include "raymath.h"
#include "rcamera.h"

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
    Vector3 target{ 0.0f, 0.0f, 0.0f };
    float yaw = 0.0f;
    float pitch = 0.5f;
    float distance = 10.0f;

    enum CameraMode
    {
        ORBITAL,
        FREECAM
    };
    CameraMode camera_mode = CameraMode::ORBITAL;
};
