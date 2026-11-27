#include "SceneObjects.h"


template <typename ... Args>
EntityId SceneObjects::Create(Args&&... args)
{
    return pool.Create();
}

GameEntity* SceneObjects::Get(EntityId id)
{
    GameEntity* entity = pool.Get(id);
    return entity;
}

void SceneObjects::RequestRemove(EntityId id)
{
    removals.push_back(id);
}

void SceneObjects::FlushRemovals()
{
    for (EntityId id : removals)
    {
        pool.Destroy(id);
    }
    removals.clear();
}
