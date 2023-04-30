LIST weather = (normal), blizzard, aurora_good, aurora_bad, hail

=== describe_weather ===
{weather:
-normal:
    The sky is clear.
-blizzard:
    A blizzard rages around you.
-aurora_good:
    In the clear sky, {~beautiful|awe-inspiring|calming|gentle} aurorae {~shimmer and dance|undulate|smile down upon you|accompany you|inspire you}.
-aurora_bad:
    In the clear sky, {~terrifying|ominous|deeply menacing|terrible} aurorae {~burn angrily|flicker strangely|obscure the lonely stars|glare down upon you}.
-hail:
    Hailstones the size of {~eggs|fists|very large hailstones} are falling all around you.
}
->->

=== process_weather ===
{weather:
-normal: // Nothing happens
-blizzard:
    // TODO Frostbite chance?
    ~for_each(party,->cold_sim)
-aurora_good:
    ~for_each(party,->cheer_up)
-aurora_bad:
    ~maybe_effect(party, stressed, "stressed", STRESS_PROB)
-hail:
    ~maybe_effect(party, bruised, "bruised", HAIL_BRUISE_PROB)
}
{RANDOM(1,100) <= WEATHER_BACK_TO_NORMAL_PROB:
    ~weather = normal
}
->->