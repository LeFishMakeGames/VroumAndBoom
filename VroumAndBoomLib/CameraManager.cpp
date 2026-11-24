#include "CameraManager.h"

#include <iostream>
#include <ostream>

void CameraManager::Init()
{
    camera.position = { 10.0f, 10.0f, 10.0f };
    camera.target = { 0.0f, 0.0f, 0.0f };
    camera.up = { 0.0f, 1.0f, 0.0f };
    camera.fovy = 45.0f;
    camera.projection = CAMERA_PERSPECTIVE; 
}

void CameraManager::Update(float dt)
{
    if (IsKeyPressed(KEY_C))
    {
        if (camera_mode == CameraMode::ORBITAL)
        {
            camera_mode = CameraMode::FREECAM;
        }
        else if (camera_mode == CameraMode::FREECAM)
        {
            camera_mode = CameraMode::ORBITAL;
        }
    }

    switch (camera_mode)
    {
    case FREECAM:
        UpdateCamera(&camera, CAMERA_FREE);
        HideCursor();
        DisableCursor();
        break;
    case ORBITAL:
        if (IsMouseButtonDown(MOUSE_BUTTON_RIGHT))
        {
            Vector2 delta = GetMouseDelta();
            yaw -= delta.x * 0.005f;
            pitch += delta.y * 0.005f;
            pitch = Clamp(pitch, -1.5f, 1.5f); 
        }
    
        distance -= GetMouseWheelMove() * 0.5f;
        distance = Clamp(distance, 2.0f, 50.0f);

        camera.target = target;
        camera.position.x = target.x + distance * cosf(pitch) * sinf(yaw);
        camera.position.y = target.y + distance * sinf(pitch);
        camera.position.z = target.z + distance * cosf(pitch) * cosf(yaw);
        break;
    }
}

void CameraManager::Render()
{
    DrawText(TextFormat("Mode de camera: %s", CameraModeToString(camera_mode)), 10, 10, 20, BLACK);
}
