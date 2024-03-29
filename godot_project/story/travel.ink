LIST landmarks = start_location, rh1, rh2, old_man_roadhouse, gambling_roadhouse, rh3, missing_roadhouse, bear_roadhouse, rh4, last_roadhouse, final_destination, debug_location
VAR current_location = start_location
//VAR current_location = debug_location



=== choose_next_destination ===
# CLEAR
~currently_moving = true
You head {out|back out} into the endless night.
Where to next?
  {current_location:
   -debug_location:
     + [old man]
        -> traveling_loop(0, old_man_roadhouse)
     + [gambling]
        -> traveling_loop(0, gambling_roadhouse)
     + [missing roadhouse]
        -> traveling_loop(0, missing_roadhouse)
     + [bear roadhouse]
        -> traveling_loop(0, bear_roadhouse)
     + [rh1]
        -> traveling_loop(0, rh1)
     + [rh2]
        -> traveling_loop(0, rh2)
     + [last_roadhouse]
        -> traveling_loop(0, last_roadhouse)
   -start_location:
     + [First roadhouse (4 hours)]
        -> traveling_loop(2, rh1)
   - rh1:
     + [Next roadhouse (6 hours)]   
        -> traveling_loop(3, rh2)
   - rh2:
     + [Miser's Valley (6 hours)]   
        -> traveling_loop(3, old_man_roadhouse)
     + [Gamblers' Gulch (6 hours)]   
        -> traveling_loop(3, gambling_roadhouse)
   - old_man_roadhouse:
     + [Next roadhouse (6 hours)]   
        -> traveling_loop(3, rh3)
   - gambling_roadhouse:
     + [Next roadhouse (6 hours)]   
        -> traveling_loop(3, rh3)
   - rh3:
     + [Next roadhouse (6 hours)]   
        -> traveling_loop(3, bear_roadhouse)
   - missing_roadhouse:
     + [Next roadhouse (6 hours)]   
        -> traveling_loop(3, rh4)
   - bear_roadhouse:
     + [Next roadhouse (6 hours)]   
        -> traveling_loop(3, rh4)
   - rh4:
     // TODO Shortcut option?
     + [Last roadhouse (6 hours)]   
        -> traveling_loop(3, last_roadhouse)
   - last_roadhouse:
     + [10 hours to final destination]   
        -> traveling_loop(5, final_destination)
   - final_destination:
    // Note: technically this shouldn't happen
     + [Deliver the serum!]
        -> endings.win
  }

// TODO Really need a mroe robust travel/map system.
=== function travel_time_from(location) ===
    {location:
    - final_destination:
        ~ return 0
    - last_roadhouse:
        ~ return 10 + travel_time_from(final_destination)
    - rh4:
        ~ return 6 + travel_time_from(last_roadhouse)
    - bear_roadhouse:
        ~ return 6 + travel_time_from(rh4)
    - rh3:
        ~ return 6 + travel_time_from(bear_roadhouse)
    - gambling_roadhouse:
        ~ return 6 + travel_time_from(rh3)
    - old_man_roadhouse:
        ~ return 6 + travel_time_from(rh3)
    - rh2:
        ~ return 6 + travel_time_from(gambling_roadhouse)
    - rh1:
        ~ return 6 + travel_time_from(rh2)
    - start_location:
        ~ return 4 + travel_time_from(rh2)
    }

=== traveling_loop(turns_to_destination, destination) ===
~currently_moving = true
# CLEAR
-> random_event ->
# CLEAR
-> process_weather ->
{turns_to_destination == 0:
    ~currently_moving = false
    // TODO: Check to treat final destination differently
    ~current_location = destination
    {current_location == final_destination:
        -> endings.win
    -else:
        -> roadhouse_arrival
    }
}
{survival_sim(party)}
~hours_remaining -= 2
-> check_loss ->

- (options)
{~You continue past miles of inhospitable landscape.|The harsh and unforgiving landscape rushes past as you continue on your way.|Imposing scenery passes you by. It's too cold for you to appreciate the hostile beauty of the Arctic.|There isn't a breath in this land of death as you hurry, horror-driven.|There is no sound but the heavy breathing of the dogs.}
-> describe_weather -> 
~temp remaining_time_required = 2*(turns_to_destination-1) + travel_time_from(destination)
{remaining_time_required > 0:
    It will take at least {remaining_time_required} hours to reach your final destination.
-else:
    You finally see the remote town, your final destination, appearing on the horizon.
}
Only {hours_remaining} hours remain.  
<- standard_menu_options(->options)
+ [Continue...]
-
-> traveling_loop(turns_to_destination - 1, destination)
