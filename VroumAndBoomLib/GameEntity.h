#pragma once

class GameEntity
{
public:
    virtual ~GameEntity() = default;
    virtual void Draw() = 0;
};