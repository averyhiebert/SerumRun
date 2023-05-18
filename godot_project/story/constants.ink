// Note: probabilities are percentages (out of 100)

CONST DEBUG_MODE = false

// Status effects stuff
CONST HUNGER_PROB = 10
CONST COLD_PROB = 15
CONST TIRED_PROB = 10

CONST HEAL_PROB = 5   // Probability of healing when resting/sleeping
CONST NO_EVENT_PROB = 50 // Probability of no event happening
CONST STRESS_PROB = 25 // Only triggered in stressful situations
CONST DEAD_BODY_TRAUMA_PROB = 30 // Weather seeing a dead body causes trauma
CONST CHEER_UP_PROB = 50    // To remove a condition when cheering up
CONST HAIL_BRUISE_PROB = 5
CONST WEATHER_BACK_TO_NORMAL_PROB = 15

// Roadhouse procgen
CONST FIRE_LIT_PROB = 50
CONST BED_PROB = 40
CONST PIANO_PROB = 40
CONST KITCHEN_PROB = 40

// Settings for death mechanics
CONST LOW_DEATH_THRESHOLD = 3
CONST HIGH_DEATH_THRESHOLD = 5
CONST LOW_DEATH_CHANCE = 20
CONST HIGH_DEATH_CHANCE = 100

// Probability of succeeding at things
// TODO Maybe some sort of ability check system? For fights, at least?
CONST FIGHT_SUCCESS = 50
CONST DICE_WINNING_PROB = 50


// For text-based testing vs. in-engine mode
CONST DO_NOTIFICATIONS = true
CONST SHOW_TEXT_MENU = true