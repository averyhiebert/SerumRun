// Contains most of the survival logic

// What survival activities have been performed this cycle?
VAR ate = true
VAR rested = true
VAR slept = true
VAR played_music = true

=== reset_activities ===
~ate = false
~rested = false
~slept = false
~played_music = false
->->

// Basic activities
=== activity ===
= eat_meal(warm)
{warm:
    You eat a hearty meal of warm stew.
    ~for_each(party,->less_hungry)
    ~for_each(party,->less_cold)
    ~for_each(party,->maybe_heal)
    ~for_each(party, ->cheer_up)
-else:
    You eat a meagre meal of cold bread and cheese.
    ~for_each(party,->less_hungry)
}
~ate = true
-> confirm ->
->->

= sleep(warm)
{warm:
    You spend an unpleasant night tossing and turning.
    ~for_each(party, ->less_cold)
    ~for_each(party,->maybe_heal)
-else:
  // TODO Decide on severity of coldness penalty
    You go to sleep shivering.  You wake up even colder.
    ~for_each(party, ->cold_sim)
    ~for_each(party, ->cold_sim)
}
~slept = true
~for_each(party,->less_tired)
~for_each(party,->less_tired)
-> confirm ->
->->

= warm_rest
You rest for a while by the fire
~for_each(party, ->less_cold)
~for_each(party,->maybe_heal)
~rested = true
-> confirm ->
->->

= play_harmonica
You take a break to play the harmonica and dance, lightening spirits somewhat.
~for_each(party, ->cheer_up)
~played_music = true
-> confirm ->
->->

= play_piano
You take a break to play the piano and dance, lightening spirits somewhat.
~for_each(party, ->cheer_up)
~played_music = true
-> confirm ->
->->

// Simulate getting cold, hungry, tired, etc.
//  (loop over all party members
=== function survival_sim(people) ===
    {for_each(people, ->check_death)}
    ~people -= dead // Just in case
    {for_each(people ^ in_relationship, ->heartbreak_sim)}
    {for_each(people, ->hunger_sim)}
    {for_each(people, ->cold_sim)}
    {for_each(people, ->tired_sim)}
    ~return


=== function hunger_sim(person)
    {(not ate) and (RANDOM(1,100) <= HUNGER_PROB):
        ~more_hungry(person)
    }
    ~return

=== function cold_sim(person)
    {RANDOM(1,100) <= COLD_PROB:
        ~more_cold(person)
    }
    ~return

=== function tired_sim(person)
    {not (rested or slept) and (RANDOM(1,100) <= TIRED_PROB):
        ~more_tired(person)
    }
    ~return

=== function heartbreak_sim(person)
    {(in_relationship? person) and LIST_COUNT(in_relationship ^ party) == 1:
        // The person's lover has died.
        ~unflag(person, in_relationship)
        ~flag(person, heartbroken)
        {name(person)} is now heartbroken after losing their lover. # bad
    }

// Make people more/less hungry/cold/tired

=== function more_hungry(person)
    {
    -hungry? person:
        ~unflag(person, hungry)
        ~flag(person, starving)
        ~note(name(person) + " is now starving!", bad)
    -starving? person:
        ~return // TODO Should there be a penalty?
    -else:
        ~flag(person, hungry)
        ~note(name(person) + " is now hungry.", bad)
    }

=== function less_hungry(person)
    {
    -hungry? person:
        ~unflag(person, hungry)
        ~note(name(person) + " is no longer hungry.", good)
    -starving? person:
        ~unflag(person, starving)
        ~flag(person, hungry)
        ~note(name(person) + " is now merely hungry.", good)
    }

=== function more_tired(person)
    {
    -tired? person:
        ~unflag(person, tired)
        ~flag(person, exhausted)
        ~note(name(person) + " is now exhausted!", bad)
    -exhausted? person:
        ~return
    -else:
        ~flag(person, tired)
        ~note(name(person) + " is now tired.", bad)
    }

=== function less_tired(person)
    {
    -tired? person:
        ~unflag(person, tired)
        ~note(name(person) + " is no longer tired.", good)
    -exhausted? person:
        ~unflag(person, exhausted)
        ~flag(person, tired)
        ~note(name(person) + " is now merely tired.", good)
    }

=== function more_cold(person)
    {
    -cold? person:
        ~unflag(person, cold)
        ~flag(person, hypothermic)
        ~note(name(person) + " is now hypothermic!", bad)
    -hypothermic? person:
    -else:
        ~flag(person, cold)
        ~note(name(person) + " is now cold.", bad)
    }

=== function less_cold(person)
    {
    -cold? person:
        ~unflag(person, cold)
        ~note(name(person) + " is no longer cold.", good)
    -hypothermic? person:
        ~unflag(person, hypothermic)
        ~flag(person, cold)
        ~note(name(person) + " is now merely cold.", good)
    }
    ~return //TODO

=== function cheer_up(person)
    // TODO Make sure this is up to date with all recoverable mental health effects
    // Resolve one or more bad mental health effects
    {terrified? person and RANDOM(1,100) <= CHEER_UP_PROB:
        ~unflag(person, terrified)
        ~note(name(person) + " is no longer terrified.", good)
    }
    {stressed? person and RANDOM(1,100) <= CHEER_UP_PROB:
        ~unflag(person, stressed)
        ~note(name(person) + " is no longer stressed.", good)
    }
    {agitated? person and RANDOM(1,100) <= CHEER_UP_PROB:
        ~unflag(person, agitated)
        ~note(name(person) + " is no longer agitated.", good)
    }
    {guilty? person and RANDOM(1,100) <= CHEER_UP_PROB:
        ~unflag(person, guilty)
        ~note(name(person) + " no longer feels guilty.", good)
    }
    {lonely? person and RANDOM(1,100) <= CHEER_UP_PROB:
        ~unflag(person, lonely)
        ~note(name(person) + " no longer feels so lonely.", good)
    }
    ~return

// Apply effect to each player with given probability
=== function maybe_effect(people, ref effect, effect_name, prob)
    {LIST_COUNT(people) == 0:
        ~return
    }
    ~temp person = LIST_MIN(people)
    {RANDOM(1,100) <= prob and not (effect? person):
        ~flag(person, effect)
        ~note(name(person) + " is now " + effect_name, bad)
    }
    ~return maybe_effect(people-person, effect, effect_name, prob)

// People may become traumatized when they see a dead body
=== function dead_body_seen()
    {RANDOM(1,100) <= DEAD_BODY_TRAUMA_PROB:
        {select_from(party - traumatized):
            ~flag(WHO, traumatized)
            ~note(name(WHO) + " is now traumatized.", bad)
        }
    }

// Situations that have a chance to heal someone
=== function maybe_heal(person)
    {broken_nose? person and RANDOM(1,100) <= HEAL_PROB:
        ~unflag(person, broken_nose)
        ~note(name(person) + "'s broken nose has healed.",good)
    }
    {broken_leg? person and RANDOM(1,100) <= HEAL_PROB:
        ~unflag(person, broken_leg)
        ~note(name(person) + "'s broken leg has healed.",good)
    }
    {dysentery? person and RANDOM(1,100) <= HEAL_PROB:
        ~unflag(person, dysentery)
        ~note(name(person) + " no longer has dysentery",good)
    }


// Death-checking stuff ================================================

=== function total_health(person) ===
    ~temp person_flags = all_flags(person)
    ~temp score = 2 * LIST_COUNT(person_flags ^ severe_conditions)
    ~score += LIST_COUNT(person_flags ^ moderate_conditions)
    ~score += 0.5 * LIST_COUNT(person_flags ^ mild_conditions)
    ~return score


// TODO Move death thresholds to constants.ink ?
=== function check_death(person) ===
    ~temp health = total_health(person)
    ~temp died = false
    {
    -health >= HIGH_DEATH_THRESHOLD:
        ~died = (RANDOM(1,100) <= HIGH_DEATH_CHANCE)
    -health >= LOW_DEATH_THRESHOLD:
        ~died = (RANDOM(1,100) <= LOW_DEATH_CHANCE)
    }
    {died:
        {death_message(person)} # bad # severe
        ~kill(person)
    }

=== function death_message(person) ===
    # bad
    {
    - dysentery? person:
        ~return name(person) + " has died of dysentery."
    - hypothermic? person:
        ~return name(person) + " has died of hypothermia."
    - broken_leg? person:
        ~return name(person) + " has died of complications from their broken leg."
    - exhausted? person:
        ~return name(person) + " has died of exhaustion."
    - broken_nose? person:
        ~return name(person) + " has died of complications from their broken nose."
    - traumatized? person:
        ~return name(person) + " couldn't handle it.  They ran off into the night, never to be seen again."
    - heartbroken? person:
        ~return name(person) + " has died of a broken heart."
    - terrified? person:
        ~return name(person) + " has died from sheer terror."
    - in_pain? person:
        ~return name(person) + " has died from sheer pain."
    - starving? person:
        ~return name(person) + " has died of malnutrition."
    - (stressed? person) or (agitated? person):
        ~return name(person) + " has died of a heart attack.  The stress was just too much for them."
    - else:
        ~return "Sadly, " + name(person) + " has died of their many ailments."
    }

=== function kill(person) ===
    ~dead += person
    ~party -= person
    ~remaining_party_members = LIST_COUNT(party)










