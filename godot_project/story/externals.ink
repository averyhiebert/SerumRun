// ALL external functions should be in this file,
//  to make keeping track of them easier.

// This must be handled in-engine to allow free text entry
EXTERNAL name(person)
=== function name(person) ===
    {person:
    -p1:
        ~return "Alice"
    -p2:
        ~return "Bob"
    -p3:
        ~return "Charlie"
    -p4:
        ~return "Devon"
    }

// Stuff used by godot

// This is used to communicate with Godot, so I've put it here as well:
VAR currently_moving = false


// Return true if person is at risk of dying.
=== function risk_of_death(person_str) ===
    ~temp person = p1
    {person_str:
    -"p1":
        ~person = p1
    -"p2":
        ~person = p2
    -"p3":
        ~person = p3
    -"p4":
        ~person = p4
    }
    ~return total_health(person) >= LOW_DEATH_THRESHOLD