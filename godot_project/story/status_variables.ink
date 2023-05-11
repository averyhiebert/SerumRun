// Contains most of the global state
VAR hours_remaining = 72 // Hours until it is too late to avert a pandemic

// Starting supplies
VAR serum = 100    // Number of serum vials remaining
VAR dogs_remaining = 4

// For now, start with 2 of everything.
// TODO Stretch goal: choose starting loadout.
VAR morphine = 2   // 1 unit = cure 1 pain?
VAR whiskey = 2    // 1 unit = cure 1 despair or terrified?
VAR coffee = 2     // 1 unit = cure 1 tired?
//VAR kerosene = 0  // probably out-of-scope for lamp to consume fuel
//VAR ammo = 0      // ditto for gun consuming ammo
VAR sourdough = 0
VAR jerky = 0

// Discrete items that confer various benefits
// TODO Choose some subset of these at start
// All should have printable names.
LIST items = lamp, shotgun, harmonica, saucepan, bedroll, bible
//VAR starter_items = (lamp, shotgun, harmonica, bedroll)
VAR inventory = ()

// Party Members
LIST possible_pms = (_p1), (_p2), (_p3), (_p4)
VAR pm1 = ()
VAR pm2 = ()
VAR pm3 = ()
VAR pm4 = ()
VAR party = (_p1, _p2, _p3, _p4) // List of ALIVE pms
VAR dead = ()                    // List of dead pms

// Possible conditions
//  (Implemented as a list of who has the condition)
LIST terrified = (_terrified)
LIST stressed = (_stressed)
LIST traumatized = (_traumatized)
LIST agitated = (_agitated)
LIST guilty = (_guilty)
LIST broken_nose = (_broken_nose)
LIST broken_leg = (_broken_leg)
LIST bruised = (_bruised)
LIST dysentery = (_dysentery)
LIST in_pain = (_in_pain)

// Values for survival sim
LIST hungry = (_hungry)
LIST starving = (_starving)

LIST cold = (_cold)
LIST hypothermic = (_hypothermic)

LIST tired = (_tired)
LIST exhausted = (_exhausted)

// Functions for adding and removing flags from party members
=== function flag(pm, ref flag_list) ===
    // pm must be a list item
    // flag_list must be a list with a matching identifier
    //  element (e.g. list "tired" with identifier element "_tired")
    ~flag_list += pm
    ~temp flag_item = LIST_MIN(flag_list - possible_pms)
    {pm:
        -_p1:
            ~pm1 += flag_item
        -_p2:
            ~pm2 += flag_item
        -_p3:
            ~pm3 += flag_item
        -_p4:
            ~pm4 += flag_item
    }
    ~return

=== function unflag(pm, ref flag_list) ===
    // pm must be a list item
    // flag_list must be a list with a matching identifier
    //  element (e.g. list "tired" with identifier element "_tired")
    ~flag_list -= pm
    ~temp flag_item = LIST_MIN(flag_list - possible_pms)
    {pm:
        -_p1:
            ~pm1 -= flag_item
        -_p2:
            ~pm2 -= flag_item
        -_p3:
            ~pm3 -= flag_item
        -_p4:
            ~pm4 -= flag_item
    }
    ~return

// Return list of health/mental health effects on a person
// TODO If I add skills etc., this will need to be modified
// to get only status effects and not other things that might
// be found in the pm list
=== function all_effects(pm) ===
 {pm:
    -_p1:
        ~return pm1
    -_p2:
        ~return pm2
    -_p3:
        ~return pm3
    -_p4:
        ~return pm4
 }

// TODO Also summarize dead/abandoned people
=== function summarize_status(person) ===
    {name(person)}{total_health(person) >= LOW_DEATH_THRESHOLD: (risk of death!)}: {all_effects(person)}














