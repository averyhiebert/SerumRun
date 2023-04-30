// Small random events that happen while traveling

=== random_event ===
{RANDOM(1,100) <= NO_EVENT_PROB:
    ->->
}
{RANDOM(1,11):
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
}
+ [Ok]
-
->->

=== get_dysentery ===
{select_from(party - dysentery):
    ~dysentery += WHO
    {name(WHO)} seems to have contracted dysentery. # bad
-else:
    Everyone in your party continues to have dysentery.
}
->->

=== unsettling_experience ===
{~The sky almost seems... too far away?|The wind shouldn't sound like that, should it?|It ain't being dead - it's the awful dread of the icy grave that pains...|You get the feeling that there's something unnatural out there in the darkness.}
{select_from(party - stressed):
    ~stressed += WHO
    {name(WHO)} is not feeling great. # bad
}
->->

=== argument ===
{LIST_COUNT(party) < 2:
    ~select_from(party)
    ~agitated += WHO
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
~agitated += loser
{name(loser)} didn't like that. # bad
->->

=== sled_bump ===
You hit a bump in the trail.
{select_from(party - bruised):
    ~bruised += WHO
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
        ~broken_leg += WHO
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
        ~terrified += WHO
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
// TODO make this make people colder?
// TODO risk of frostbite?
A blizzard starts.
~weather = blizzard
->->

=== aurora_good_start ===
// TODO Make this cheer people up
The sky {~lights up|comes alive} in a {~stunning|dazzling|awe-inspiring} array of colours.
~weather = aurora_good
->->

=== aurora_bad_start ===
// TODO Make this make people anxious
The sky {~erupts|is set aflame} in {~a terrifying|an ominous|a deeply menacing} shade of red.
~weather = aurora_bad
->->

=== hail_start ===
// TODO Should have risk of bruising
A hailstorm starts.
~weather = hail
->->







