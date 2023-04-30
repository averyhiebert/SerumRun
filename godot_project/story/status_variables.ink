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
LIST party = (p1), (p2), (p3), (p4)
VAR dead = ()

// Possible conditions
//  (Implemented as a list of who has the condition)
VAR terrified = ()
VAR stressed = ()
VAR traumatized = ()
VAR agitated = ()
VAR guilty = ()
//VAR frostbite = ()
//VAR bored = ()
VAR broken_nose = ()
VAR broken_leg = ()
VAR bruised = ()
VAR dysentery = ()
VAR in_pain = ()

// Values for survival sim
VAR hungry = ()
VAR starving = ()

VAR cold = ()
VAR hypothermic = ()

VAR tired = ()
VAR exhausted = ()


// UI functions for summarizing people's state
//  (ideally will be replaced with GUI in-engine, if time allows)

=== function if(cond, text) ===
    {cond:
        ~return text
    -else:
        ~return ""
    }

// TODO Also summarize dead/abandoned people
=== function summarize_status(person) ===
    {name(person)}{total_health(person) >= LOW_DEATH_THRESHOLD: (risk of death!)}: {if(hungry?person,"hungry,")} {if(starving?person,"starving,")} {if(cold?person,"cold,")} {if(hypothermic?person,"hypothermic,")} {if(tired?person,"tired,")} {if(exhausted?person,"exhausted,")} {if(broken_nose?person,"broken nose,")} {if(broken_leg?person,"broken leg,")} {if(in_pain?person,"in pain,")} {if(terrified?person,"terrified,")} {if(stressed?person,"stressed,")} {if(traumatized?person,"traumatized,")} {if(bruised?person,"bruised,")} {if(agitated?person,"agitated,")} {if(guilty?person,"guilty,")} {if(dysentery?person,"dysentery,")}















