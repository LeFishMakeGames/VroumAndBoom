#pragma once
#include <vector>

#include "EntityId.h"
#include "ObjectPool.h"
#include "GameEntity.h"

class SceneObjects
{
public:
    
    template <typename... Args>
    EntityId Create(Args&&... args);
    
    GameEntity* Get(EntityId id);
    
    void RequestRemove(EntityId id);
    
    void FlushRemovals();
    
    
private:
    static constexpr std::size_t maxEntities = 1000;
    
    ObjectPool<GameEntity, maxEntities> pool;
    std::vector<EntityId> removals;
    
};


