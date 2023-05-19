# theme: dark
# author: Avery Hiebert

INCLUDE utils.ink
INCLUDE status_variables.ink
INCLUDE survival.ink
INCLUDE roadhouse.ink
INCLUDE constants.ink
INCLUDE externals.ink
INCLUDE travel.ink
INCLUDE encounters.ink
INCLUDE travel_events.ink
INCLUDE weather.ink

{DEBUG_MODE:
    ~current_location = debug_location
}

-> start

=== start ===
A remote arctic town is facing an impending diptheria outbreak.
All of the town's antitoxin serum is expired.
The only way to get the serum to them in time is by dogsled.
The journey will be perilous. Godspeed.
+ [Start your journey...]
  -> select_starting_inventory(2)

=== select_starting_inventory(selections_remaining) ===
{selections_remaining == 0:
  -> choose_next_destination
}
# CLEAR
Select {selections_remaining} {|more} {selections_remaining > 1:items|item} before you set out:
// TODO Populate this menu dynamically.
* {not (inventory has shotgun)}[Shotgun]
    ~inventory += shotgun
* {not (inventory has bedroll)}[Bedroll]
    ~inventory += bedroll
* {not (inventory has harmonica)}[Harmonica]
    ~inventory += harmonica
* {not (inventory has lamp)}[Kerosene Lamp]
    ~inventory += lamp
* {not (inventory has saucepan)}[Saucepan]
    ~inventory += saucepan
-
-> select_starting_inventory(selections_remaining - 1)




=== standard_menu_options(-> back) ===
+ {SHOW_TEXT_MENU}[((debug menu))]
    Insert some debug options.
    ++ [Kill a party member.]
        <- thread_for_each(party, "kill ", ->kill, back)
        +++ [Done.]
            -> back
    ++ [Done.]
        # CLEAR
       -> back
+ {SHOW_TEXT_MENU}[((Check party status))]
    # CLEAR
    Inventory: {inventory}
    ~for_each(party,->summarize_status)
    ++ [Done.]
        # CLEAR
       -> back



// Check whether any loss conditions have been met.
=== check_loss ===
{
  - hours_remaining < 0:
    ~currently_moving = false
    -> endings.out_of_time
  - LIST_COUNT(party) == 0:
    ~currently_moving = false
    -> endings.all_dead
}
->->


=== endings ===

= out_of_time
Unfortunately, you did not get to the town fast enough to avert the epidemic. # bad
Thousands will perish. # bad # severe
{LIST_COUNT(dead) > 0:
    {listNamesWithCommas(dead,"")} died in vain. # bad # severe
}
-> END

= all_dead
Your entire party is dead. The serum is lost. # bad
Thousands will perish. # bad # severe
-> END

= win
~currently_moving = false
// TODO Check how much serum is intact?
// TODO Summarize how many party members died on the way
At last, you arrive at your destination with the serum safely intact.
The epidemic is averted! # good
{LIST_COUNT(dead) > 0:
    {listNamesWithCommas(dead,"")} may have perished, but they will be remembered as {LIST_COUNT(dead) > 1:heroes|a hero}. # good
}
-> END