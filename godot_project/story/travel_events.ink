// Small random events that happen while traveling

// Should only interact with main story by:
//  - adding/removing from inventory
//  - flagging/unflagging party member effects
//  - setting weather

=== random_event ===
{RANDOM(1,100) <= NO_EVENT_PROB:
    ->->
}
{RANDOM(1,12):
-1:
    -> sled_bump ->
-2:
    -> wolf_pack ->
-3:
    -> blizzard_start ->
-4:
    -> aurora_good_start ->
-5:
    -> aurora_bad_start ->
-6:
    -> hail_start ->
-7:
    -> cairn ->
-8:
    -> sled_obstacle ->
-9:
    -> unsettling_experience ->
-10:
    -> argument ->
-11:
    -> get_dysentery ->
-12:
    -> mysterious_cave ->
}
+ [Ok]
-
->->

=== mysterious_cave ===
{ // What if we already did this event?
- skip_cave_help_cries:
    ~select_from(party)
    ~flag(WHO, guilty)
    {name(WHO)} still feels bad about ignoring a cry for help. # bad
    ->->
- abandon_both:
    {select_from(party - terrified):
        ~flag(WHO,terrified)
        {name(WHO)} has only just now fully considered the implications of the doppelganger incident. # bad
    - else:
        Everyone is still pretty freaked out by the doppelganger incident.
    }
    ->->
 - keep_one:
    ~temp possible_impostor = LIST_MIN(maybe_impostor ^ possible_pms)
    {
    -not (party? possible_impostor):
        It occurs to you all that it no longer really matters whether you picked the correct {possible_impostor}.
    -LIST_COUNT(party) > 1:
        ~select_from(party - possible_impostor)
        {name(WHO)} keeps eyeing {name(possible_impostor)} nervously.
    -else:
        // Only the possible impostor is left.
        // TODO Actually resolve choice at this point?
        I sure hope you picked the right {possible_impostor}.
    }
    ->->
}// That SHOULD be fully exhaustive...
You pass by a jagged rock formation containing the entrance to a small cave.  You think you hear someone shouting for help from deep inside.
+ (skip_cave_help_cries) [Ignore the cries for help.]
    You continue past without stopping.  Your mission is more important.
    {select_from(party - guilty):
        ~flag(WHO,guilty)
        {name(WHO)} feels guilty about this. #bad
    }
    ->->
+ [Investigate.]
-
~select_from(party)
{name(WHO)} enters the cave to investigate.
A moment later, {name(WHO)} emerges from the cave with a horrified expression on their face, pursued by an equally horrified {name(WHO)}.
Both {name(WHO)}s beg you to take them with you and leave behind the other {name(WHO)}.
+ (abandon_both) [Leave them both.]
    You can't afford to take a risk on whatever is happening here.
    Against their protestations, you abandon both copies of {name(WHO)}. # bad # severe
    ~kill(WHO)
    {select_from(party - guilty):
        ~flag(WHO,guilty)
        {name(WHO)} feels haunted by this decision. # bad
    }
    ->->
+ [Take the {name(WHO)} who came out first.]
+ [Take the {name(WHO)} who came out second.]
- (keep_one)
You accept one of the {name(WHO)}s back into the party, and leave the other to their fate.  Hopefully you chose correctly.
~flag(WHO, maybe_impostor)
->->

=== get_dysentery ===
{select_from(party - dysentery):
    ~flag(WHO,dysentery)
    {name(WHO)} seems to have contracted dysentery. # bad
-else:
    Everyone in your party continues to have dysentery.
}
->->

=== unsettling_experience ===
{~The sky almost seems... too far away?|The wind shouldn't sound like that, should it?|It ain't being dead - it's the awful dread of the icy grave that pains...|You get the feeling that there's something unnatural out there in the darkness.}
{select_from(party - stressed):
    ~flag(WHO,stressed)
    {name(WHO)} is not feeling great. # bad
}
->->

=== argument ===
{LIST_COUNT(party) < 2:
    ~select_from(party)
    ~flag(WHO,agitated)
    {name(WHO)} has started mumbling angrily to themselves. # bad
    ->->
}
~temp person1 = LIST_RANDOM(party)
~temp person2 = LIST_RANDOM(party - person1)
~temp loser = person1
{name(person1)} and {name(person2)} are having a heated argument.
{name(person1)} {~believes|claims|says} that {~mankind is alone in the universe|there is no god|objective truth is unattainable|a communist revolution is inevitable|true altruism does not exist, and all seemingly 'selfless' acts are in fact selfishly motivated|happiness is unobtainable|there is some sense in which we die every time we go to sleep|the industrial revolution has done more harm than good|pineapple goes well on pizza|air travel will never be commercially viable}.  {name(person2)} disagrees.
+ [Resolve in favour of {name(person1)}.]
    ~loser = person2
+ [Resolve in favour of {name(person2)}.]
    ~loser = person1
-
~flag(loser, agitated)
{name(loser)} didn't like that. # bad
->->

=== sled_bump ===
You hit a bump in the trail.
{select_from(party - bruised):
    ~flag(WHO, bruised)
    {name(WHO)} gets roughed up a bit. # bad
}
->->

=== sled_obstacle ===
A log half-covered by the deep snow emerges out of the darkness ahead.
{inventory has lamp:
    Fortunately, the light of your lamp gives you adequate warning to avoid hitting it.
-else:
    By the time you see it there's no time to turn or stop the sled.
    {select_from(party - broken_leg):
        ~flag(WHO, broken_leg)
        {name(WHO)} breaks a leg in the ensuing collision. # bad
    }
}
->->

=== wolf_pack ===
A pack of wolves emerge from the night behind you, {~ long teeth glinting in the starlight|bearing down on you with a surprising sense of purpose and coordination|moving in unison with terrifying speed and precision|chasing after you with ravenous expressions and glowing eyes|led by a particularly ferocious animal covered in scars}.  They're coming quickly, but your dogs are faster (hopefully).
+ [Outrun them]
    You urge the dogs to run faster.  They don't need any convincing.
    Eventually the wolves give up and you escape with your life.
    {select_from(party - terrified):
        ~flag(WHO,terrified)
        {name(WHO)} seems shaken by the encounter. # bad
    }
    // TODO can be bitten and get rabies?
+ {LIST_COUNT(inventory) > 0}[Throw something at them]
    // TODO Choose what to throw?
    ~temp to_throw = LIST_RANDOM(inventory)
    ~inventory -= to_throw
    Terrified, you throw your {to_throw} at the wolves.  They appear to back off, but going back to retrieve the {to_throw} is definitely off the table.
+ {inventory has shotgun}[Shoot at them]
    You grab the shotgun and fire at the pack.  They back off.
-
->->

=== cairn ===
You spot a long-forgotten, lonely cairn of stones.
+ [Leave it.]
    You leave the cairn alone.
+ [Investigate.]
    Buried beneath the cairn you find only weathered, broken bones.
    ~dead_body_seen()
-
->->

=== blizzard_start ===
A blizzard starts.
~weather = blizzard
->->

=== aurora_good_start ===
The sky {~lights up|comes alive} in a {~stunning|dazzling|awe-inspiring} array of colours.
~weather = aurora_good
->->

=== aurora_bad_start ===
The sky {~erupts|is set aflame} in {~a terrifying|an ominous|a deeply menacing} shade of red.
~weather = aurora_bad
->->

=== hail_start ===
A hailstorm starts.
~weather = hail
->->







