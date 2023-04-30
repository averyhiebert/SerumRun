// Controls what happens between traveling segments

// Roadhouse state
VAR fire_lit = false
VAR has_bed = false
VAR has_piano = false
VAR has_old_man = false

// Encounters that *must* happen before roadhouse
=== check_blocking_encounters ===
{current_location == bear_roadhouse and not bear_attack:
    -> bear_attack(-> choose_next_destination, ->roadhouse)
}
->->

// Encounters that are merely an additional option
=== get_additional_encounters(-> back)
{current_location == old_man_roadhouse:
    <- angry_old_man(back)
}
{current_location == gambling_roadhouse:
    <- gamblers(back)
}
{current_location == last_roadhouse:
    This is the last place to rest before your final destination.
}
-> DONE


=== roadhouse_arrival ===
-> reset_activities ->
-> check_blocking_encounters ->
~fire_lit = RANDOM(1,100) <= FIRE_LIT_PROB
~has_bed = RANDOM(1,100) <= BED_PROB
~has_piano = RANDOM(1,100) <= PIANO_PROB
{current_location == bear_roadhouse:
    ~fire_lit = false // for narrative consistency
}
You arrive at a small roadhouse. <>
-> roadhouse

// TODO Move time costs to constants for better balancing
// TODO Piano, bed could be handled better as threads
=== roadhouse ===
- (options)
# CLEAR
{fire_lit:A fire crackles in the fireplace.|The fireplace is unlit and the room is cold and damp.}  {has_bed: This room is equipped with adequate bedding for your whole party.}  {has_piano: There is {a tack piano|an upright piano} in the corner of the room.}
<- standard_menu_options(-> options)
<- get_additional_encounters(-> options)
+ {not fire_lit} [Light a fire. (1 hour)]
    After spending some time chopping wood you are able to light a fire in the fireplace.
    ~fire_lit = true
    ~hours_remaining -= 1
    -> confirm ->
+ {fire_lit}[Rest by the fire. (1 hour)]
    -> activity.warm_rest ->
    ~hours_remaining -= 1
+ {not ate} [Eat a cold meal. (1 hour)]
    -> activity.eat_meal(false) ->
    ~hours_remaining -= 1
+ {not ate}{fire_lit} [Eat a warm meal. (2 hours)]
    -> activity.eat_meal(true) ->
    ~hours_remaining -= 2
+ {not slept}{has_bed} [Get a good night's sleep. (6 hours)]
    -> activity.sleep(fire_lit) ->
    ~hours_remaining -= 6
+ {not slept}{inventory has bedroll}{not has_bed} [Get a good night's sleep (using bedroll). (6 hours)]
    -> activity.sleep(fire_lit) ->
    ~hours_remaining -= 6
+ {not played_music}{inventory has harmonica}{not has_piano} [Play the harmonica. (1 hour)]
    // TODO better handling of various recreation items.
    -> activity.play_harmonica ->
    ~hours_remaining -= 1
+ {not played_music}{has_piano} [Play the piano. (1 hour)]
    // TODO better handling of various recreation items.
    -> activity.play_piano ->
    ~hours_remaining -= 1
+ [Get back on the road.]
    -> choose_next_destination
- -> options

