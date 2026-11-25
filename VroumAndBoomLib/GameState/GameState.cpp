#include "GameState.h"

#include "raylib.h"

void GameState::Init()
{
    if (gslist == unassigned) return;
    
    menu = new Menu();
    
}

void GameState::Update(float dt)
{
    if (IsKeyPressed(KEY_ESCAPE) || ! gslist == Menus)
    {
        gslist = Menus;
    }
    if (IsKeyPressed(KEY_SPACE) ||  ! gslist == Playing)
    {
        gslist = Playing;
    }
    if (IsKeyPressed(KEY_P) ||  ! gslist == Paused)
    {
        gslist = Paused;
    }
    if (IsKeyPressed(KEY_P) ||   gslist == Paused)
    {
        gslist = Playing;
    }
    
    switch (gslist)
    {
        
    case Menus:
        menu->Render(rect);
        break;
        
    case Playing:
        
        break;
        
    case Paused:
        
        break;
    }
    
    
}

void GameState::Render()
{
}
