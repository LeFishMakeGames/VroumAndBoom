#pragma once
#include "raylib.h"
#include "../../MenuTemp.h"

class Paused : public menu_template
{
public:
    
   
    
    void Init() override;
    void Update(float dt) override;
    void Render() override;
    
};
