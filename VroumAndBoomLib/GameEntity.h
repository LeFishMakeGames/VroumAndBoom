#pragma once
#include <cstdint>

struct EntityId
{
    std::uint32_t InvalidSlot = 0;

    std::uint32_t slot = InvalidSlot;
    std::uint32_t generation = 0;

    bool IsValid() const { return slot != InvalidSlot; }
    
    bool operator==(const EntityId&) const = default;
};
