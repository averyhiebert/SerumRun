// Major scripted events that occur at landmarks/roadhouses.

VAR knocked_out_old_man = false
=== angry_old_man(-> next) ===
// Note: intended to be "threaded" into a roadhouse menu
You are not alone here. <>
{knocked_out_old_man:
    The old man is still lying, unconscious, in the corner.
-else:
    {You notice a bearded old man eating at a table in the corner.|The old man is still sitting in the corner, ignoring you.}
}
* {knocked_out_old_man} [Loot the old man's belongings.]
    ~temp possible_loot = LIST_ALL(items) - inventory
    {LIST_COUNT(possible_loot) > 0:
        ~temp found = LIST_RANDOM(possible_loot)
        You take a {found} from the man's unconscious body.
        ~inventory += found
        {select_from(party - guilty):
            ~guilty += WHO
            {name(WHO)} feels guilty about this. # bad
        }
    -else:
        You don't find anything of value.
    }
    -> confirm ->
    -> next
* [Approach the old man.]
    You approach the old man.  He glares at you.
    "What are you doing around here?"
    ** "None of your business."
        The old man snorts. "Why are you talking to me, then?"
        *** "Just trying to be friendly."
            "Well, you're not, so stop trying." <>
        *** "I'm not sure, to be honest."
            "Then leave me alone." <>
        ---
        The old man goes back to his meal.
        -> confirm ->
        -> next
    ** "Delivering diptheria serum to avert an epidemic."
    --
    The man seems unimpressed.  "Why would you do that?"
    ** "To make a name for myself."
        "That's a shit reason.  Selfish.  Leave me alone."
        The man goes back to his meal.
        -> confirm ->
        -> next
    ** "To save hundreds of lives!"
        "Who says they need saving? What if it's just their time to die?"
        *** "What if it's not?"
        *** "Why would you say something like that?"
        ---
        The man grunts dismissively.  "If it wasn't their time to die then God wouldn't have sent them diptheria."
        //*** {inventory has shotgun}[Shoot him.] // TODO traumatized
        *** [Fight him.]
            // TODO pick a party member to fight?
            ~temp who = LIST_RANDOM(party)
            {name(who)} puches the man in the face.  A fracas ensues.
            {RANDOM(1,100) <= FIGHT_SUCCESS:
                He goes down quickly. You leave him unconscious in a corner.
                ~knocked_out_old_man = true
                -> confirm ->
                -> next
            -else:
                // TODO notification here?
                {name(who)} comes out of it with a broken nose. # bad
                ~broken_nose += who
                //~note(name(who) + " has a broken nose", bad)
                "That'll teach you to mess with God's plan!" cackles the old bastard.
                You decide not to pursue this any further.
                -> confirm ->
                -> next
            }
        *** [Leave him alone.]
            You decide not to pursue this any further.
            -> confirm ->
            -> next
-> DONE


=== gamblers(-> next) ===
You are not alone here.  {Some shady-looking folks are playing craps in the corner.|The gamblers are still playing craps in the corner.}
+ {not gambled}[Approach the gamblers.]
  ~select_from(party)
  {name(WHO)} approaches the gamblers.  One of them looks up.
  "Wanna play?" they ask.
  ++ "No"
    "Then leave us alone" one of the others pipes up.
    -> confirm -> next
  ++ (gambled) "Sure."
    ~temp their_wager = LIST_RANDOM(LIST_ALL(items) - inventory)
    ~temp your_wager = LIST_RANDOM(inventory)
    {not their_wager:
        The gamblers get excited, until they realize that they have nothing of value that you don't already have.
        -> confirm -> next
    }
    {not your_wager:
        {name(WHO)} tries to join the gamblers, but it turns out that they're not interested in anything you have to wager.
        -> confirm -> next
    }
    "How's this for a wager: my {their_wager} vs. your {your_wager}?"
    *** [Accept.]
        You accept. {name(WHO)} rolls the dice.
        // TODO Maybe properly simulate craps?
        {RANDOM(1,100) <= DICE_WINNING_PROB:
            It's a seven! You win!
            The gamblers grumble as you take their {their_wager}. # good
            ~inventory += their_wager
        -else:
            Snake eyes! You lose!
            The gamblers happily collect your {your_wager} from you. # bad
            ~inventory -= your_wager
        }
        -> confirm -> next
    *** [Decline.]
        You decline the wager.  The gamblers seem annoyed, and go back to ignoring you.
        -> confirm -> next
-> DONE


=== bear_attack(-> next_skip, -> next_noskip) ===
You approach the next roadhouse.  It looks dark. The door seems to be damaged, hanging off the hinges.
* [Carry on to the next roadhouse.]
    You decide to carry on to the next roadhouse.
    -> confirm ->
    -> next_skip
* [Investigate.]
-
There seems to be blood on the walls of the roadhouse.
Outside the building, two roughly human-sized objects are buried under freshly-fallen snow.
- (options)
* [Dig under the snow.]
    You uncover two bloody corpses.
    ~dead_body_seen()
    -> options
* {inventory has lamp}[Shine a light inside.]
    You shine your lamp through the door and see a large polar bear, its fur spattered with blood, sleeping in a corner.
    -> options
* [Leave immediately.]
    You decide to get the hell outta there.
    -> confirm ->
    -> next_skip
* [Enter the building.]
-
~select_from(party)
{name(WHO)} enters the building, waking the giant polar bear sleeping in a corner.  It rises up to a truly staggering height, growling and baring its sharp teeth.
* {LIST_COUNT(party) > 1}[Leave {name(WHO)} and run.]
    The rest of the party runs, leaving {name(WHO)} to die. # bad
    ~kill(WHO)
    -> confirm ->
    -> next_skip ->
* [Fight.]
    // Really matters if you have a shotgun.
    {inventory has shotgun:
        You grab the shotgun and shoot the bear several times.
        It puts up a brave fight, but you eventually kill it and escape mostly unharmed.
        {select_from(party - bruised):
            ~bruised += WHO
            {name(WHO)} obtains some minor injuries. # bad
        }
    -else:
        You attempt to engage in unarmed combat with a polar bear.
        // TODO Some chance of success?
        ~select_from(party)
        Amazingly, you kill the bear.
        But {name(WHO)} dies in the process. # bad
    }
-
-> confirm ->
-> next_noskip


















