LIST notification_types = good, bad

=== function for_each(ls, -> func) ===
    {LIST_COUNT(ls) == 0:
        ~return
    }
    ~temp item = LIST_MIN(ls)
    {func(item)}
    ~return for_each(ls - item, func)

// Generate a list of options to apply func
// Usage example:
// <- therad_for_each(party, "kill ", ->kill, ->options)
=== thread_for_each(ls, msg, -> func, -> back) ===
    {LIST_COUNT(ls) == 0:
        -> DONE
    }
    ~temp item = LIST_MIN(ls)
    <- thread_for_each(ls - item, msg, func, back)
    + [{msg}{item}]
        ~func(item)
        -> back
    -> DONE

=== function note(msg, type) ===
    // Display given string as a "notification"
    // TODO decide what this looks like.
    {not DO_NOTIFICATIONS:
        ~return
    }
    {type == good:
        # good
        //# CLASS: notification-good
    -else:
        # bad
        //# CLASS: notification-bad
    }
    {msg}

=== confirm ===
// Get user confirmation before going somewhere that clears screen.
// usage: -> confirm ->
+ [Ok]
->->

// Person selected most recently by select_from.
// This global variable saves a lot of writing in some cases.
VAR WHO = ()
=== function select_from(people) ===
    ~people = people ^ party // Just in case.
    {LIST_COUNT(people) == 0:
        ~return false
    -else:
        ~WHO = LIST_RANDOM(people)
        ~return true
    }

// From Inkle documentation, modified to use names
=== function listNamesWithCommas(list, if_empty) 
    {LIST_COUNT(list): 
    - 2: 
        	{name(LIST_MIN(list))} and {listNamesWithCommas(list - LIST_MIN(list), if_empty)}
    - 1: 
        	{name(list)}
    - 0: 
			{if_empty}	        
    - else: 
      		{name(LIST_MIN(list))}, {listNamesWithCommas(list - LIST_MIN(list), if_empty)} 
    }