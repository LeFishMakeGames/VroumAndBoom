#pragma once
#include "../../MenuTemp.h"

class Menu : public menu_template
{
private : 
    
public:
    
    void Init() override;
    void Update(float dt) override;
    void Render(rectangle rect) override;
    rectangle rect;
};
