#pragma once
#include "Game.h"

class Colors
{
public : 
    
    auto gray = LIGHTGRAY;
    auto white = RAYWHITE;
    
};

struct rectangle
{
private:
    Game* game;

public:
    
    int Left = 0;
    int Top = 0;
    int Width = game->getWidth();
    int Height = game->getHeight();
    Colors colors ;
};


class menu_template
{
    public:
    
    
    virtual void Init();
    virtual void Update(float dt);
    virtual void Render(rectangle rect);
    
};




