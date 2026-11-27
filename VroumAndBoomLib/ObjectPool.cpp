#include "ObjectPool.h"

template <typename T, std::size_t Capacity>
ObjectPool<T, Capacity>::ObjectPool()
{
    for (std::size_t i = 0; i < Capacity; ++i)
    {
        freeList[i] = static_cast<int>(Capacity - 1 - i);
    }
    freeCount = Capacity;
}

template <typename T, std::size_t Capacity>
template <typename ... Args>
EntityId ObjectPool<T, Capacity>::Create(Args&&... args)
{
    if (freeCount == 0)
    {
        return EntityId{};
    }
    
    const std::uint32_t index = freeList[--freeCount];
    Slot& slot = slots[index];

    slot.object.emplace(std::forward<Args>(args)...);

    return EntityId{ index, slot.generation };
}

template <typename T, std::size_t Capacity>
T* ObjectPool<T, Capacity>::Get(EntityId id)
{
    return &slots[id.slot].object.value;
}

template <typename T, std::size_t Capacity>
void ObjectPool<T, Capacity>::Destroy(EntityId id)
{
    Slot& slot = slots[id.slot];

    slot.object.reset();
    ++slot.generation;

    freeList[freeCount++] = id.slot;
}

template <typename T, std::size_t Capacity>
void ObjectPool<T, Capacity>::Clear()
{
    for (int i = 0; i < Capacity; i++)
    {
        Slot& slot = slots[i];
        
        if (slot.object.has_value())
        {
            slot.object.reset();
            ++slot.generation;
        }
        freeList[i] = Capacity -1 - i;
    }
    freeCount = Capacity;
}


