#pragma once

#include "State/Menu/Menu.h"

enum GameStateList
{
    unassigned,
    Menus,
    Playing,
    Paused,
};

class GameState
{
public:
    GameStateList gslist;
    
    Menu* menu = nullptr;
    
    void Init();
    void Update(float dt);
    void Render();
    
    rectangle rect;
};

