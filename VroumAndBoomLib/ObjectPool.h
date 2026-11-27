#pragma once
#include <cstddef>
#include <optional>

#include "EntityId.h"

template <typename T, std::size_t Capacity> 
class ObjectPool
{
    
public:
    ObjectPool();
    
    template <typename... Args>
    EntityId Create(Args&&... args);
    
    T* Get(EntityId id);
    void Destroy(EntityId id);
    void Clear();
private:
    
    struct Slot
    {
        std::optional<T> object;
        std::uint32_t generation = 0; 
    };

    std::array<Slot, Capacity> slots;
    
    std::array<int, Capacity> freeList;
    std::size_t freeCount;
    
};


