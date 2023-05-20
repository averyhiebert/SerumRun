// ALL external functions should be in this file,
//  to make keeping track of them easier.

// This must be handled in-engine to allow free text entry
EXTERNAL name(person)
=== function name(person) ===
    {person:
    -_p1:
        ~return "Alice"
    -_p2:
        ~return "Bob"
    -_p3:
        ~return "Charlie"
    -_p4:
        ~return "Devon"
    }

// Stuff used by godot ========================================================

// This is used to communicate with Godot, so I've put it here as well:
// These variables are used to communicate with Godot, so they're included
//  in this file as well.
VAR currently_moving = false
VAR remaining_party_members = 4


// Return true if person is at risk of dying.
=== function risk_of_death(person_str) ===
    ~temp person = _p1
    {person_str:
    -"_p1":
        ~person = _p1
    -"_p2":
        ~person = _p2
    -"_p3":
        ~person = _p3
    -"_p4":
        ~person = _p4
    }
    ~return total_health(person) >= LOW_DEATH_THRESHOLD

# Some other notes about API stuff:
#  - Options formatted like ((this)) are not displayed to player
#  - Tags # good, bad, severe control text display
#  - currently_moving and weather are observed by the engine
#  - should s/_/ / in all displayed text