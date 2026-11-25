#include "Menu.h"

void Menu::Init()
{
    
}

void Menu::Render(rectangle rect)
{
    BeginDrawing();
    
    
    
    DrawRectangle(rect.Left, rect.Top, rect.Width, rect.Height, rect.colors.gray);
    
    EndDrawing();
}
