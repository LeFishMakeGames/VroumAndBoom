#include "Game.h"
#include "raylib.h"

#include "resource_dir.h"	// utility header for SearchAndSetResourceDir

int main ()
{
    Game game;
    game.Init();
    game.Run();
    return 0;
}
