// by @eddbiddulph
//
// Please note that this shader takes around 5 minutes to compile on my desktop machine, so expect
// a long wait.
//
// Columns!
// ---------------------
// This is the classic game of columns, kind of how it was on the Sega Genesis. Forgive me if I have got
// any details wrong, and also please inform me (through Twitter) of any bugs you find! Hopefully the
// game logic engine will run correctly for most other people. It stores and manipulates state through the
// alpha channel. See below for instructions:
//
// * Hover over the buttons at the top of the well to indicate which column you want to drop your stack down.
// * Hover over the big long button at the top to rotate.
// * Hover over the big button at the lower-left to reset. This will reset the whole game!
// * There is a 5-digit display at the bottom-right to show your score, and a next-stack preview at the top-right.
//
// Points are awarded for getting a column or row of three identical colours. If this happens, then
// a chain reaction will begin through that same colour. If you get a chain reaction, there is a bonus
// multiplier for the score you got. The game tries to award more points for bigger chain reactions
// and big groups of colours, but doesn't do very well... I have left this as my work for the future.
//
// Note: This game only seems to work on 1x resolution mode.
//
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define EPS vec3(0.0001, 0.0, 0.0)

#define SLIME_FIELD_WIDTH                       6
#define SLIME_FIELD_HEIGHT                      17
#define NUM_SCORE_DIGITS                        5
#define MELTING_SLIME_COUNT_BANK_ORG            vec2(3.0, 3.0)
#define FALLING_SLIME_COUNT_BANK_ORG            vec2(3.0, 4.0)
#define SLIME_FIELD_ORG                         vec2(3.0, 10.0)
#define FRAME_COUNTER_LOC_0                     vec2(2.0, 1.0)
#define FRAME_COUNTER_LOC_1                     vec2(3.0, 1.0)
#define SCORE_COUNTER_LOC_0                     vec2(4.0, 1.0)
#define SCORE_COUNTER_LOC_1                     vec2(5.0, 1.0)
#define MELTING_SLIME_CHAIN_COUNTER_LOC         vec2(6.0, 1.0)
#define SLIME_NEXT_LOC_0                        vec2(7.0, 1.0)
#define SLIME_NEXT_LOC_1                        vec2(8.0, 1.0)
#define SLIME_NEXT_LOC_2                        vec2(9.0, 1.0)
#define MEM_LOC                                 floor(gl_FragCoord.xy * 0.25)
#define MEM_LOC_NORTH                           (MEM_LOC + vec2( 0.0, -1.0))
#define MEM_LOC_SOUTH                           (MEM_LOC + vec2( 0.0, +1.0))
#define MEM_LOC_EAST                            (MEM_LOC + vec2(+1.0,  0.0))
#define MEM_LOC_WEST                            (MEM_LOC + vec2(-1.0,  0.0))
#define MEM_LOC_EAST_EAST                       (MEM_LOC + vec2(+2.0,  0.0))
#define MEM_LOC_WEST_WEST                       (MEM_LOC + vec2(-2.0,  0.0))
#define MEM_LOC_NORTH_EAST                      (MEM_LOC + vec2(+1.0, -1.0))
#define MEM_LOC_NORTH_WEST                      (MEM_LOC + vec2(-1.0, -1.0))
#define MEM_LOC_SOUTH_EAST                      (MEM_LOC + vec2(+1.0, +1.0))
#define MEM_LOC_SOUTH_WEST                      (MEM_LOC + vec2(-1.0, +1.0))
#define MEM_LOC_NORTH_NORTH_EAST                (MEM_LOC + vec2(+1.0, -2.0))
#define MEM_LOC_NORTH_NORTH_WEST                (MEM_LOC + vec2(-1.0, -2.0))
#define MEM_LOC_SOUTH_SOUTH_EAST                (MEM_LOC + vec2(+1.0, +2.0))
#define MEM_LOC_SOUTH_SOUTH_WEST                (MEM_LOC + vec2(-1.0, +2.0))
#define MEM_LOC_SOUTH_SOUTH                     (MEM_LOC + vec2( 0.0, +2.0))
#define MEM_LOC_NORTH_NORTH                     (MEM_LOC + vec2( 0.0, -2.0))
#define NUM_TO_ALPHA(x_)                        (floor(x_) * 1.0 / 255.0)
#define ALPHA_TO_NUM(x_)                        floor(x_ * 255.0)
#define SET_MEM(x_)                             gl_FragColor.a = NUM_TO_ALPHA(x_);
#define MEM_AT(coord_)                          (ALPHA_TO_NUM(texture2D(backbuffer, floor(coord_.xy) / resolution.xy * 4.0 + vec2(0.0001)).a))
#define EMPTY_SLIME_TYPE                        0.0
#define STATIONARY_SLIME_TYPE                   1.0
#define MELTING_SLIME_TYPE                      2.0
#define FALLING_SLIME_TYPE                      3.0
#define FIELD_BORDER_SLIME_TYPE                 4.0
#define SLIME_TYPE_AT(coord_)                   slimeTypeFromNum(MEM_AT(coord_))
#define SLIME_COLOUR_AT(coord_)                 slimeColourFromNum(MEM_AT(coord_))
#define MEM_IS_FRAME_COUNTER_0                  (MEM_LOC == FRAME_COUNTER_LOC_0)
#define MEM_IS_FRAME_COUNTER_1                  (MEM_LOC == FRAME_COUNTER_LOC_1)
#define MEM_IS_SCORE_COUNTER_0                  (MEM_LOC == SCORE_COUNTER_LOC_0)
#define MEM_IS_SCORE_COUNTER_1                  (MEM_LOC == SCORE_COUNTER_LOC_1)
#define MEM_IS_MELTING_SLIME_CHAIN_COUNTER      (MEM_LOC == MELTING_SLIME_CHAIN_COUNTER_LOC)
#define FRAME_COUNTER                           (MEM_AT(FRAME_COUNTER_LOC_0) + MEM_AT(FRAME_COUNTER_LOC_1) * 256.0)
#define SCORE_COUNTER                           (MEM_AT(SCORE_COUNTER_LOC_0) + MEM_AT(SCORE_COUNTER_LOC_1) * 256.0)
#define MELTING_SLIME_CHAIN_COUNT              MEM_AT(MELTING_SLIME_CHAIN_COUNTER_LOC)
#define SET_MEM_FRAME_COUNTER_INCREMENTED       SET_MEM(mod(THIS_MEM + 1.0, 256.0))
#define FALLING_SLIME_ANIMATION_LENGTH          40.0
#define MELTING_SLIME_ANIMATION_LENGTH          22.0
//#define CONTROL_ANIMATION_LENGTH                5.0
#define FIRST_FRAME_OF_FALLING_SLIME_ANIMATION  (mod(FRAME_COUNTER, FALLING_SLIME_ANIMATION_LENGTH) == 0.0)
#define FIRST_FRAME_OF_MELTING_SLIME_ANIMATION  (mod(FRAME_COUNTER, MELTING_SLIME_ANIMATION_LENGTH) == 0.0)
//#define FIRST_FRAME_OF_CONTROL_ANIMATION        (mod(FRAME_COUNTER, CONTROL_ANIMATION_LENGTH) == 0.0)
#define FIRST_FRAME_OF_CONTROL_ANIMATION        (mod(FRAME_COUNTER + FALLING_SLIME_ANIMATION_LENGTH - 1.0, FALLING_SLIME_ANIMATION_LENGTH) == 0.0)
#define FALLING_SLIME_COUNT                     MEM_AT(FALLING_SLIME_COUNT_BANK_ORG + vec2(float(SLIME_FIELD_WIDTH), 0.0))
#define MELTING_SLIME_COUNT                     MEM_AT(MELTING_SLIME_COUNT_BANK_ORG + vec2(float(SLIME_FIELD_WIDTH), 0.0))
#define NO_FALLING_SLIMES                       (FALLING_SLIME_COUNT == 0.0)
#define NO_MELTING_SLIMES                       (MELTING_SLIME_COUNT == 0.0)
#define MEM_IS_EMPTY_SLIME                      (SLIME_TYPE_AT(MEM_LOC) == EMPTY_SLIME_TYPE)
#define MEM_IS_STATIONARY_SLIME                 (SLIME_TYPE_AT(MEM_LOC) == STATIONARY_SLIME_TYPE)
#define MEM_IS_MELTING_SLIME                    (SLIME_TYPE_AT(MEM_LOC) == MELTING_SLIME_TYPE)
#define MEM_IS_FALLING_SLIME                    (SLIME_TYPE_AT(MEM_LOC) == FALLING_SLIME_TYPE)
#define NORTH_MEM                               MEM_AT(MEM_LOC_NORTH)
#define SOUTH_MEM                               MEM_AT(MEM_LOC_SOUTH)
#define NORTH_NORTH_MEM                         MEM_AT(MEM_LOC_NORTH_NORTH)
#define SOUTH_SOUTH_MEM                         MEM_AT(MEM_LOC_SOUTH_SOUTH)
#define EAST_MEM                                MEM_AT(MEM_LOC_EAST)
#define WEST_MEM                                MEM_AT(MEM_LOC_WEST)
#define EAST_EAST_MEM                           MEM_AT(MEM_LOC_EAST_EAST)
#define WEST_WEST_MEM                           MEM_AT(MEM_LOC_WEST_WEST)
#define THIS_MEM                                MEM_AT(MEM_LOC)
#define NORTH_MEM_IS(type_)                     (SLIME_TYPE_AT(MEM_LOC_NORTH) == type_)
#define SOUTH_MEM_IS(type_)                     (SLIME_TYPE_AT(MEM_LOC_SOUTH) == type_)
#define EAST_MEM_IS(type_)                      (SLIME_TYPE_AT(MEM_LOC_EAST)  == type_)
#define WEST_MEM_IS(type_)                      (SLIME_TYPE_AT(MEM_LOC_WEST)  == type_)
#define NORTH_EAST_MEM_IS(type_)                (SLIME_TYPE_AT(MEM_LOC_NORTH_EAST) == type_)
#define SOUTH_EAST_MEM_IS(type_)                (SLIME_TYPE_AT(MEM_LOC_SOUTH_EAST) == type_)
#define NORTH_WEST_MEM_IS(type_)                (SLIME_TYPE_AT(MEM_LOC_NORTH_WEST) == type_)
#define SOUTH_WEST_MEM_IS(type_)                (SLIME_TYPE_AT(MEM_LOC_SOUTH_WEST) == type_)
#define NORTH_NORTH_EAST_MEM_IS(type_)          (SLIME_TYPE_AT(MEM_LOC_NORTH_NORTH_EAST) == type_)
#define SOUTH_SOUTH_EAST_MEM_IS(type_)          (SLIME_TYPE_AT(MEM_LOC_SOUTH_SOUTH_EAST) == type_)
#define NORTH_NORTH_WEST_MEM_IS(type_)          (SLIME_TYPE_AT(MEM_LOC_NORTH_NORTH_WEST) == type_)
#define SOUTH_SOUTH_WEST_MEM_IS(type_)          (SLIME_TYPE_AT(MEM_LOC_SOUTH_SOUTH_WEST) == type_)
#define NORTH_NORTH_MEM_IS(type_)               (SLIME_TYPE_AT(MEM_LOC_NORTH_NORTH) == type_)
#define SOUTH_SOUTH_MEM_IS(type_)               (SLIME_TYPE_AT(MEM_LOC_SOUTH_SOUTH) == type_)
#define CONTROLLED_SLIME_NONE_VAL               0.0
#define CONTROLLED_SLIME_TOP_VAL                1.0
#define CONTROLLED_SLIME_MID_VAL                2.0
#define CONTROLLED_SLIME_BOTTOM_VAL             3.0
#define CONTROLLED_SLIME_TYPE_AT(coord_)        floor(MEM_AT(coord_) / 64.0)
#define EAST_MEM_IS_CONTROLLED_SLIME_TOP        (CONTROLLED_SLIME_TYPE_AT(MEM_LOC_EAST) == CONTROLLED_SLIME_TOP_VAL)
#define EAST_MEM_IS_CONTROLLED_SLIME_MID        (CONTROLLED_SLIME_TYPE_AT(MEM_LOC_EAST) == CONTROLLED_SLIME_MID_VAL)
#define EAST_MEM_IS_CONTROLLED_SLIME_BOTTOM     (CONTROLLED_SLIME_TYPE_AT(MEM_LOC_EAST) == CONTROLLED_SLIME_BOTTOM_VAL)
#define WEST_MEM_IS_CONTROLLED_SLIME_TOP        (CONTROLLED_SLIME_TYPE_AT(MEM_LOC_WEST) == CONTROLLED_SLIME_TOP_VAL)
#define WEST_MEM_IS_CONTROLLED_SLIME_MID        (CONTROLLED_SLIME_TYPE_AT(MEM_LOC_WEST) == CONTROLLED_SLIME_MID_VAL)
#define WEST_MEM_IS_CONTROLLED_SLIME_BOTTOM     (CONTROLLED_SLIME_TYPE_AT(MEM_LOC_WEST) == CONTROLLED_SLIME_BOTTOM_VAL)
#define MEM_IS_CONTROLLED_SLIME_TOP             (CONTROLLED_SLIME_TYPE_AT(MEM_LOC) == CONTROLLED_SLIME_TOP_VAL)
#define MEM_IS_CONTROLLED_SLIME_MID             (CONTROLLED_SLIME_TYPE_AT(MEM_LOC) == CONTROLLED_SLIME_MID_VAL)
#define MEM_IS_CONTROLLED_SLIME_BOTTOM          (CONTROLLED_SLIME_TYPE_AT(MEM_LOC) == CONTROLLED_SLIME_BOTTOM_VAL)
#define MEM_IS_CONTROLLED_SLIME                 (CONTROLLED_SLIME_TYPE_AT(MEM_LOC) != CONTROLLED_SLIME_NONE_VAL)
#define SET_MEM_COPY_OF_NORTH_MEM               SET_MEM(NORTH_MEM)
#define SET_MEM_COPY_OF_SOUTH_MEM               SET_MEM(SOUTH_MEM)
#define SET_MEM_COPY_OF_EAST_MEM                SET_MEM(EAST_MEM)
#define SET_MEM_COPY_OF_WEST_MEM                SET_MEM(WEST_MEM)
#define MEM_SLIME_COLUMN                        (MEM_LOC.x - SLIME_FIELD_ORG.x)
#define SET_MEM_EMPTY_SLIME                     SET_MEM(0.0)

#define SET_MEM_MELTING_SLIME  SET_MEM(makeSlimeNum(SLIME_COLOUR_AT(MEM_LOC), MELTING_SLIME_TYPE, CONTROLLED_SLIME_NONE_VAL))
#define SET_MEM_FALLING_SLIME  SET_MEM(makeSlimeNum(SLIME_COLOUR_AT(MEM_LOC), FALLING_SLIME_TYPE, CONTROLLED_SLIME_TYPE_AT(MEM_LOC)))
#define SET_MEM_STATIONARY_SLIME  SET_MEM(makeSlimeNum(SLIME_COLOUR_AT(MEM_LOC), STATIONARY_SLIME_TYPE, CONTROLLED_SLIME_NONE_VAL))

#define NORTH_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR  (SLIME_TYPE_AT(MEM_LOC_NORTH) == MELTING_SLIME_TYPE && SLIME_COLOUR_AT(MEM_LOC_NORTH) == SLIME_COLOUR_AT(MEM_LOC))

#define SOUTH_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR  (SLIME_TYPE_AT(MEM_LOC_SOUTH) == MELTING_SLIME_TYPE && SLIME_COLOUR_AT(MEM_LOC_SOUTH) == SLIME_COLOUR_AT(MEM_LOC))

#define EAST_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR  (SLIME_TYPE_AT(MEM_LOC_EAST) == MELTING_SLIME_TYPE && SLIME_COLOUR_AT(MEM_LOC_EAST) == SLIME_COLOUR_AT(MEM_LOC))
            
#define WEST_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR  (SLIME_TYPE_AT(MEM_LOC_WEST) == MELTING_SLIME_TYPE && SLIME_COLOUR_AT(MEM_LOC_WEST) == SLIME_COLOUR_AT(MEM_LOC))

#define MOUSE_COORD             (mouse * vec2(resolution.x / resolution.y, -1.0) + vec2(0.0, 1.0))

#define DESIRED_SLIME_COLUMN    desiredSlimeColumn()
#define ROTATION_IS_DESIRED     rotationIsDesired()
#define RESET_IS_DESIRED        resetIsDesired()


const vec2 slime_field_display_org = vec2(0.5, 0.2), slime_field_display_size = vec2(0.3, 0.7);
const vec2 slime_cell_size = slime_field_display_size / vec2(float(SLIME_FIELD_WIDTH), float(SLIME_FIELD_HEIGHT));

const vec2 slime_preview_org = vec2(0.9, 0.2), slime_preview_size = vec2(slime_cell_size.x, slime_cell_size.y * 3.0);

const vec2 score_display_org = vec2(0.9, 0.8), score_display_size = vec2(0.4, 0.1);

                                                    
                                                    
float square(vec2 o, vec2 s, vec2 p)
{
   return length(max(vec2(0.0), abs(p - o) - s));
}


// a zone is an area in which the mouse cursor can hover, for the purpose
// of effecting player controls.

vec2 obj_union(vec2 obj_a, vec2 obj_b)
{
    return mix(obj_a, obj_b, step(obj_b.x, obj_a.x));
}

// there are six zones which the player can use to indicate where
// they want the controlled slimes to drop.
float columnZoneDistance(vec2 p, float i)
{
    return square(vec2(slime_field_display_org.x + slime_cell_size.x * (i + 0.5), 0.12), vec2(0.01, 0.01), p) - 0.01;
}

float rotateZoneDistance(vec2 p)
{
    return square(vec2(slime_field_display_org.x + slime_field_display_size.x * 0.5, 0.07), vec2(slime_field_display_size.x * 0.5, 0.01), p) - 0.01;
}

float resetZoneDistance(vec2 p)
{
    return square(vec2(0.2, 0.7), vec2(0.1, 0.05), p) - 0.01;
}

float desiredSlimeColumn()
{
    vec2 result = vec2(0.0, 0.0), p = MOUSE_COORD;

    for(int x = 0; x < SLIME_FIELD_WIDTH; ++x)
    {
        result = obj_union(result, vec2(columnZoneDistance(p, float(x)), float(x) + 1.0));
    }
    
    return (result.x < 0.0) ? result.y : 0.0;
}

bool rotationIsDesired()
{
    return rotateZoneDistance(MOUSE_COORD) < 0.0;
}

bool resetIsDesired()
{
    return resetZoneDistance(MOUSE_COORD) < 0.0;
}

float slimeTypeFromNum(float num)
{
    return floor(mod(num, 64.0) / 8.0);
}

float slimeColourFromNum(float num)
{
    return mod(num, 8.0);
}

float makeSlimeNum(float colour, float type, float control_val)
{
    return colour + type * 8.0 + control_val * 64.0;
}

bool memIsInCountBank(vec2 org)
{
    // width of bank == SLIME_FIELD_WIDTH + 1
    return MEM_LOC.y == org.y && MEM_LOC.x >= org.x && MEM_LOC.x <= (org.x + float(SLIME_FIELD_WIDTH));
}

void pumpCountBank(vec2 bank_org, float counted_type)
{
    float xofs = MEM_LOC.x - bank_org.x;
    
    if(xofs < float(SLIME_FIELD_WIDTH))
    {
        float count = 0.0;
        
        for(int y = 0; y < SLIME_FIELD_HEIGHT; ++y)
        {
            if(SLIME_TYPE_AT(SLIME_FIELD_ORG + vec2(xofs, float(y))) == counted_type)
            {
                count += 1.0;
            }
        }
        
        SET_MEM(count);
    }
    else if(MEM_LOC == (bank_org + vec2(float(SLIME_FIELD_WIDTH), 0.0)))
    {
        float count = 0.0;

        for(int x = 0; x < SLIME_FIELD_WIDTH; ++x)
        {
            count += MEM_AT(bank_org + vec2(float(x), 0.0));
        }

        SET_MEM(count);
    }
    
    // so, with a one-frame latency, the total count for the playfield
    // will always be written to bank[SLIME_FIELD_WIDTH]
}

void doLogic()
{
    // ready for new set of falling slimes to control and place into position? we need
    // to make sure that there are no falling or melting slimes, or that any falling or melting
    // slimes may be introduced in this frame.
    bool ready_for_new_set = (FRAME_COUNTER > 0.0 && mod(FRAME_COUNTER, 50.0) == 0.0 &&
            NO_MELTING_SLIMES && NO_FALLING_SLIMES && !FIRST_FRAME_OF_FALLING_SLIME_ANIMATION &&
            !FIRST_FRAME_OF_MELTING_SLIME_ANIMATION);

    // slight hack here to ensure that the first falling slimes will have a nonzero set of colours to use
    if(ready_for_new_set || FRAME_COUNTER == 0.0)
    {
        if(MEM_LOC == SLIME_NEXT_LOC_0)
        {
            SET_MEM(mod(floor(time * 197.0), 6.0));
        }
        else if(MEM_LOC == SLIME_NEXT_LOC_1)
        {
            SET_MEM(mod(floor(time * 281.0), 6.0));
        }
        else if(MEM_LOC == SLIME_NEXT_LOC_2)
        {
            SET_MEM(mod(floor(time * 373.0), 6.0));
        }
    }
        
    if(memIsInCountBank(MELTING_SLIME_COUNT_BANK_ORG))
    {
        pumpCountBank(MELTING_SLIME_COUNT_BANK_ORG, MELTING_SLIME_TYPE);
    }
    else if(memIsInCountBank(FALLING_SLIME_COUNT_BANK_ORG))
    {
        pumpCountBank(FALLING_SLIME_COUNT_BANK_ORG, FALLING_SLIME_TYPE);
    }
    else if(MEM_IS_FRAME_COUNTER_0)
    {
        SET_MEM_FRAME_COUNTER_INCREMENTED;
        
        if(RESET_IS_DESIRED)
        {
            SET_MEM(0.0);
        }
    }
    else if(MEM_IS_FRAME_COUNTER_1)
    {
        if(MEM_AT(FRAME_COUNTER_LOC_0) == 255.0)
        {
            SET_MEM_FRAME_COUNTER_INCREMENTED;
        }
        
        if(RESET_IS_DESIRED)
        {
            SET_MEM(0.0);
        }
    }
    else if(MEM_IS_MELTING_SLIME_CHAIN_COUNTER)
    {
        if(mod(FRAME_COUNTER + MELTING_SLIME_ANIMATION_LENGTH - 1.0, MELTING_SLIME_ANIMATION_LENGTH) == 0.0)
        {
            if(!NO_MELTING_SLIMES)
            {
                SET_MEM(min(THIS_MEM + 1.0, 4.0)); // limit chain bonus to x4
            }
            else
            {
                SET_MEM(1.0);
            }
        }
    }
    else if(MEM_IS_SCORE_COUNTER_0)
    {
        // if previous frame was third frame of melting slimes cycle (to give count banks a chance to flush)
        if(mod(FRAME_COUNTER + MELTING_SLIME_ANIMATION_LENGTH - 3.0, MELTING_SLIME_ANIMATION_LENGTH) == 0.0)
        {
            SET_MEM(mod(THIS_MEM + MELTING_SLIME_COUNT * MELTING_SLIME_CHAIN_COUNT, 256.0))
        }

        if(RESET_IS_DESIRED)
        {
            SET_MEM(0.0);
        }
    }
    else if(MEM_IS_SCORE_COUNTER_1)
    {
        // if previous frame was third frame of melting slimes cycle (to give count banks a chance to flush)
        if(mod(FRAME_COUNTER + MELTING_SLIME_ANIMATION_LENGTH - 3.0, MELTING_SLIME_ANIMATION_LENGTH) == 0.0)
        {
            float s = MEM_AT(SCORE_COUNTER_LOC_0);
            
            if(s + MELTING_SLIME_COUNT * MELTING_SLIME_CHAIN_COUNT > 255.0)
            {
                // carry and saturate (do not penalise epic players!)
                SET_MEM(THIS_MEM + floor((s + MELTING_SLIME_COUNT * MELTING_SLIME_CHAIN_COUNT) / 256.0));
            }
        }

        if(RESET_IS_DESIRED)
            SET_MEM(0.0);
    }
    else if(MEM_LOC.y == (SLIME_FIELD_ORG.y + float(SLIME_FIELD_HEIGHT)))
    {
        SET_MEM(makeSlimeNum(0.0, FIELD_BORDER_SLIME_TYPE, 0.0));
    }
    else if(MEM_LOC.x >= SLIME_FIELD_ORG.x && MEM_LOC.y >= SLIME_FIELD_ORG.y && // is mem in slime field?
            MEM_LOC.x < (SLIME_FIELD_ORG.x + float(SLIME_FIELD_WIDTH)) && MEM_LOC.y < (SLIME_FIELD_ORG.y + float(SLIME_FIELD_HEIGHT)))
    {

        // if we are ready for a new set of falling slimes
        if(ready_for_new_set)
        {
            // create a new set of three falling slimes for the player to place (carefully!)
            if(MEM_LOC.x == SLIME_FIELD_ORG.x + 3.0)
            {
                if(MEM_LOC.y == SLIME_FIELD_ORG.y)
                {
                    SET_MEM(makeSlimeNum(MEM_AT(SLIME_NEXT_LOC_0), STATIONARY_SLIME_TYPE, CONTROLLED_SLIME_TOP_VAL));
                }
                else if(MEM_LOC.y == (SLIME_FIELD_ORG.y + 1.0))
                {
                    SET_MEM(makeSlimeNum(MEM_AT(SLIME_NEXT_LOC_1), STATIONARY_SLIME_TYPE, CONTROLLED_SLIME_MID_VAL));
                }
                else if(MEM_LOC.y == (SLIME_FIELD_ORG.y + 2.0))
                {
                    SET_MEM(makeSlimeNum(MEM_AT(SLIME_NEXT_LOC_2), STATIONARY_SLIME_TYPE, CONTROLLED_SLIME_BOTTOM_VAL));
                }
            }
        }

    
        // falling slime animation goes from the cell occupied with the 'falling slime' type to the cell just below.
        // all animations are synched, to make things a bit simpler.
        // when an animation frame is tested, this will be the frame of the CURRENT IMAGE. so if we are testing for the
        // first frame of an animation cycle then the backbuffer holds data from the LAST frame of that animation.
        
        if(MEM_IS_FALLING_SLIME && SOUTH_MEM_IS(STATIONARY_SLIME_TYPE))
        {
            SET_MEM_STATIONARY_SLIME;
        }
        
        if(FIRST_FRAME_OF_FALLING_SLIME_ANIMATION && NO_MELTING_SLIMES)
        {
            bool any_empty = false;
            
            for(int y = 0; y < SLIME_FIELD_HEIGHT; ++y)
            {
                if((MEM_LOC.y + float(y)) < (SLIME_FIELD_ORG.y + float(SLIME_FIELD_HEIGHT)) &&
                   SLIME_TYPE_AT(MEM_LOC + vec2(0.0, float(y))) == EMPTY_SLIME_TYPE)
                {
                    any_empty = true;
                    break;
                }
            }
        
            if(MEM_IS_STATIONARY_SLIME && any_empty)
            {
                SET_MEM_FALLING_SLIME;
            }

            if((MEM_IS_EMPTY_SLIME || MEM_IS_FALLING_SLIME) && NORTH_MEM_IS(FALLING_SLIME_TYPE))
            {
                if(SOUTH_MEM_IS(STATIONARY_SLIME_TYPE) || MEM_LOC.y == (SLIME_FIELD_ORG.y + float(SLIME_FIELD_HEIGHT) - 1.0))
                {
                    SET_MEM(makeSlimeNum(SLIME_COLOUR_AT(MEM_LOC_NORTH), STATIONARY_SLIME_TYPE, CONTROLLED_SLIME_NONE_VAL))
                }
                else if(SOUTH_MEM_IS(EMPTY_SLIME_TYPE) || SOUTH_MEM_IS(FALLING_SLIME_TYPE))
                {
                    SET_MEM_COPY_OF_NORTH_MEM;
                }
            }

            if(NORTH_MEM_IS(EMPTY_SLIME_TYPE) && MEM_IS_FALLING_SLIME)
            {
                SET_MEM_EMPTY_SLIME;
            }
            
        }
        else if(FIRST_FRAME_OF_MELTING_SLIME_ANIMATION && NO_FALLING_SLIMES)
        {
            if(MEM_IS_STATIONARY_SLIME)
            {
                // at this point, all slime cells should be either empty or stationary coloured.
                // here, a row or column of 3 identically-coloured slimes is detected.
                if((NORTH_MEM == THIS_MEM && SOUTH_MEM == THIS_MEM) ||
                   (EAST_MEM == THIS_MEM && WEST_MEM == THIS_MEM) ||
                   (EAST_MEM == THIS_MEM && EAST_EAST_MEM == THIS_MEM) ||
                   (WEST_MEM == THIS_MEM && WEST_WEST_MEM == THIS_MEM) ||
                   (NORTH_MEM == THIS_MEM && NORTH_NORTH_MEM == THIS_MEM) ||
                   (SOUTH_MEM == THIS_MEM && SOUTH_SOUTH_MEM == THIS_MEM))
                {
                    // start a flood fill
                    SET_MEM_MELTING_SLIME; // must retain the same colour!
                }

                if(NORTH_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR || EAST_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR ||
                   SOUTH_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR || WEST_MEM_IS_MELTING_SLIME_OF_EQUAL_COLOUR)
                {
                    // continue flood fill
                    SET_MEM_MELTING_SLIME; // must retain the same colour!
                }
            }

            // here we are checking that the pixel from the PREVIOUS FRAME is of the 'melting slime' type, meaning that
            // if the CURRENTLY RENDERING frame is the FIRST frame of the melting animation cycle, the pixel must have just
            // been through all frames of the melting animation and must be cleared.
            if(MEM_IS_MELTING_SLIME)
            {
                // flood fills need only a wavefront of 1 slime. the fill is
                // complete once all of the melting slime pixels have turned empty.
                SET_MEM_EMPTY_SLIME;
            }
        }
        
        if(FIRST_FRAME_OF_CONTROL_ANIMATION && ROTATION_IS_DESIRED)
        {
            // rotate colours only
            if(MEM_IS_CONTROLLED_SLIME_TOP && SLIME_TYPE_AT(MEM_LOC + vec2(0.0, 3.0)) == EMPTY_SLIME_TYPE)
            {
                SET_MEM(makeSlimeNum(SLIME_COLOUR_AT(MEM_LOC_SOUTH_SOUTH), SLIME_TYPE_AT(MEM_LOC), CONTROLLED_SLIME_TOP_VAL))
            }
            else if(MEM_IS_CONTROLLED_SLIME_MID && SOUTH_SOUTH_MEM_IS(EMPTY_SLIME_TYPE))
            {
                SET_MEM(makeSlimeNum(SLIME_COLOUR_AT(MEM_LOC_NORTH), SLIME_TYPE_AT(MEM_LOC), CONTROLLED_SLIME_MID_VAL))
            }
            else if(MEM_IS_CONTROLLED_SLIME_BOTTOM && SOUTH_MEM_IS(EMPTY_SLIME_TYPE))
            {
                SET_MEM(makeSlimeNum(SLIME_COLOUR_AT(MEM_LOC_NORTH), SLIME_TYPE_AT(MEM_LOC), CONTROLLED_SLIME_BOTTOM_VAL))
            }
        }
        
        float desired_column = DESIRED_SLIME_COLUMN;
        
        if(desired_column >= 1.0 && FIRST_FRAME_OF_CONTROL_ANIMATION && NO_MELTING_SLIMES)
        {
            desired_column -= 1.0;
            
            if(MEM_IS_EMPTY_SLIME)
            {
                // check for proximity to the currently falling column of 3 slimes.
                // it is also ensured that the controlled column will not break up or slice through
                // any stationary slimes.
                if(desired_column == MEM_SLIME_COLUMN || desired_column > MEM_SLIME_COLUMN)
                {
                    if(WEST_MEM_IS_CONTROLLED_SLIME_TOP && SOUTH_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_SOUTH_MEM_IS(EMPTY_SLIME_TYPE) &&
                       SLIME_TYPE_AT(MEM_LOC + vec2(-1.0, 3.0)) == EMPTY_SLIME_TYPE)
                    {
                        SET_MEM_COPY_OF_WEST_MEM;
                    }
                    else if(WEST_MEM_IS_CONTROLLED_SLIME_MID && SOUTH_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_MEM_IS(EMPTY_SLIME_TYPE) &&
                       SOUTH_SOUTH_WEST_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_COPY_OF_WEST_MEM;
                    }
                    else if(WEST_MEM_IS_CONTROLLED_SLIME_BOTTOM && NORTH_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_NORTH_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_WEST_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_COPY_OF_WEST_MEM;
                    }
                }
                
                if(desired_column == MEM_SLIME_COLUMN || desired_column < MEM_SLIME_COLUMN)
                {
                    if(EAST_MEM_IS_CONTROLLED_SLIME_TOP && SOUTH_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_SOUTH_MEM_IS(EMPTY_SLIME_TYPE) &&
                       SLIME_TYPE_AT(MEM_LOC + vec2(+1.0, 3.0)) == EMPTY_SLIME_TYPE)
                    {
                        SET_MEM_COPY_OF_EAST_MEM;
                    }
                    else if(EAST_MEM_IS_CONTROLLED_SLIME_MID && SOUTH_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_MEM_IS(EMPTY_SLIME_TYPE) &&
                        SOUTH_SOUTH_EAST_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_COPY_OF_EAST_MEM;
                    }
                    else if(EAST_MEM_IS_CONTROLLED_SLIME_BOTTOM && NORTH_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_NORTH_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_EAST_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_COPY_OF_EAST_MEM;
                    }
                }
            }
            else if(MEM_IS_CONTROLLED_SLIME)
            {
                if(desired_column > MEM_SLIME_COLUMN)
                {
                    if(MEM_IS_CONTROLLED_SLIME_TOP && EAST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_EAST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_SOUTH_EAST_MEM_IS(EMPTY_SLIME_TYPE) && SLIME_TYPE_AT(MEM_LOC + vec2(0.0, 3.0)) == EMPTY_SLIME_TYPE)
                    {
                        SET_MEM_EMPTY_SLIME;
                    }
                    else if(MEM_IS_CONTROLLED_SLIME_MID && EAST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_EAST_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_EAST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_SOUTH_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_EMPTY_SLIME;
                    }
                    else if(MEM_IS_CONTROLLED_SLIME_BOTTOM && EAST_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_EAST_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_NORTH_EAST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_EMPTY_SLIME;
                    }
                }
                else if(desired_column < MEM_SLIME_COLUMN)
                {
                    if(MEM_IS_CONTROLLED_SLIME_TOP && WEST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_WEST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_SOUTH_WEST_MEM_IS(EMPTY_SLIME_TYPE) && SLIME_TYPE_AT(MEM_LOC + vec2(0.0, 3.0)) == EMPTY_SLIME_TYPE)
                    {
                        SET_MEM_EMPTY_SLIME;
                    }
                    else if(MEM_IS_CONTROLLED_SLIME_MID && WEST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_WEST_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_WEST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_SOUTH_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_EMPTY_SLIME;
                    }
                    else if(MEM_IS_CONTROLLED_SLIME_BOTTOM && WEST_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_WEST_MEM_IS(EMPTY_SLIME_TYPE) && NORTH_NORTH_WEST_MEM_IS(EMPTY_SLIME_TYPE) && SOUTH_MEM_IS(EMPTY_SLIME_TYPE))
                    {
                        SET_MEM_EMPTY_SLIME;
                    }
                }
            }
        }
        
        if(RESET_IS_DESIRED)
        {
            SET_MEM_EMPTY_SLIME;
        }
        
    }
}

vec3 slimeRGBFromColour(float colour)
{
    if(colour < 1.0)
        return vec3(0.3, 0.3, 1.0); // blue
    else if(colour < 2.0)
        return vec3(1.0, 0.3, 1.0); // purple
    else if(colour < 3.0)
        return vec3(1.0, 0.3, 0.3); // red
    else if(colour < 4.0)
        return vec3(1.2, 0.5, 0.1); // orange
    else if(colour < 5.0)
        return vec3(1.5, 1.1, 0.3); // yellow
    else
        return vec3(0.0, 1.0, 0.0); // green
}


float qshape(vec2 p)
{
   return p.x * p.x * p.x * p.x + p.y * p.y * p.y * p.y;
}

float slimeBlueMask(vec2 p)
{
   p -= vec2(0.5);
   return step(qshape(p), 0.01) * 0.5 +
          step(qshape(p + vec2(-0.02, 0.02)), 0.005) * 0.1 +
          step(qshape(p + vec2(-0.08, 0.08)), 0.001) * 0.1 +
          step(length(p - vec2(0.18, -0.15)), 0.05) * 0.7;
}

float slimePurpleMask(vec2 p)
{
   p -= vec2(0.5);

   vec2 tp = p;

   p.x = 0.707 * tp.x - 0.707 * tp.y;
   p.y = 0.707 * tp.y + 0.707 * tp.x;

   return step(qshape(p), 0.008) * 0.5 +
          step(qshape(p + vec2(-0.02, -0.01)), 0.005) * 0.1 +
          step(qshape(p + vec2(-0.08, -0.03)), 0.001) * 0.1 +
          step(length(p - vec2(0.18, -0.0)), 0.05) * 0.7;
}

float donut(float r0, float r1, vec2 p)
{
   return max(length(p) - r1, -(length(p) - r0));
}

float slimeRedMask(vec2 p)
{
   p -= vec2(0.5);
   return step(donut(0.1, 0.33, p), 0.0) * 0.5 +
          step(donut(0.11, 0.30,p - vec2(0.01, -0.01)), 0.0) * 0.1 +
          step(donut(0.15, 0.28,p - vec2(0.01, -0.01)), 0.0) * 0.1 +
          step(length(p - vec2(0.18, -0.15)), 0.03) * 0.7;
}

float slimeOrangeMask(vec2 p)
{
   p -= vec2(0.5);
   return step(length(p), 0.35) * 0.5 +
          step(distance(p, vec2(0.02, -0.02)), 0.3) * 0.1 +
          step(distance(p, vec2(0.08, -0.08)), 0.2) * 0.1 +
          step(length(p - vec2(0.18, -0.15)), 0.05) * 0.7;
}

float curl(float r0, float r1, vec2 p)
{
   float d0 = max(0.0, donut(r0, r1, p));
   float d1 = max(0.0, -p.x - 0.1);

   return length(vec2(d0, d1)) - 0.04;
}

float slimeYellowMask(vec2 p)
{
   p -= vec2(0.5);
   p.x += 0.1;
   return step(curl(0.2, 0.32, p), 0.01) * 0.5 +
          step(curl(0.21, 0.30,p - vec2(0.01, -0.01)), 0.0) * 0.1 +
          step(curl(0.25, 0.28,p - vec2(0.01, -0.01)), 0.0) * 0.1 +
          step(length(p - vec2(0.23, -0.17)), 0.03) * 0.7;
}

float slimeGreenMask(vec2 p)
{
   p -= vec2(0.5);
   p += vec2(cos(p.y * 50.0) * 0.03, 0.0);
   return step(length(p), 0.35) * 0.5 +
          step(distance(p, vec2(0.02, -0.02)), 0.3) * 0.1 +
          step(distance(p, vec2(0.08, -0.08)), 0.2) * 0.1 +
          step(length(p - vec2(0.18, -0.15)), 0.05) * 0.7;
}

// p must be within unit square centred at 0.5, 0.5
// p must be within unit square centred at 0.5, 0.5
vec3 slimeTileGraphic(vec2 p, float colour)
{
   float mask = 0.0;

   p *= 0.75;
   p += vec2(0.12);

   if(colour < 1.0)
      mask = slimeBlueMask(p);
   else if(colour < 2.0)
      mask = slimePurpleMask(p);
   else if(colour < 3.0)
      mask = slimeRedMask(p);
   else if(colour < 4.0)
      mask = slimeOrangeMask(p);
   else if(colour < 5.0)
      mask = slimeYellowMask(p);
   else if(colour < 6.0)
      mask = slimeGreenMask(p);

    return mask * slimeRGBFromColour(colour);
}



// 7-segment digital display!
float digit(vec2 p, float n)
{
   float dist = 1000.0;

   if(n < 1.0)
   {
      dist = square(vec2(0.5, 0.2), vec2(0.25, 0.01), p);
   }
   else if(n < 2.0)
   {
      dist = square(vec2(0.25, 0.125 * 3.0), vec2(0.01, 0.125), p);
   }
   else if(n < 3.0)
   {
      dist = square(vec2(0.75, 0.125 * 3.0), vec2(0.01, 0.125), p);
   }
   else if(n < 4.0)
   {
      dist = square(vec2(0.5, 0.5), vec2(0.25, 0.01), p);
   }
   else if(n < 5.0)
   {
      dist = square(vec2(0.25, 0.125 * 5.0), vec2(0.01, 0.125), p);
   }
   else if(n < 6.0)
   {
      dist = square(vec2(0.75, 0.125 * 5.0), vec2(0.01, 0.125), p);
   }
   else
   {
      dist = square(vec2(0.5, 0.8), vec2(0.25, 0.01), p);
   }

   return dist - 0.04;
}

float numberMask(vec2 p, float n)
{
   float dist;

   if(n < 1.0) // 0
   {
      dist = min(min(min(min(min(
                 digit(p, 0.0), digit(p, 1.0)),
                 digit(p, 2.0)), digit(p, 4.0)),
                 digit(p, 5.0)), digit(p, 6.0));
   }
   else if(n < 2.0) // 1
   {
      dist = min(digit(p, 2.0), digit(p, 5.0));
   }
   else if(n < 3.0) // 2
   {
      dist = min(min(min(min(
                  digit(p, 0.0), digit(p, 2.0)),
                  digit(p, 3.0)), digit(p, 4.0)),
                  digit(p, 6.0));
   }
   else if(n < 4.0) // 3
   {
      dist = min(min(min(min(
                  digit(p, 0.0), digit(p, 2.0)),
                  digit(p, 3.0)), digit(p, 5.0)),
                  digit(p, 6.0));
   }
   else if(n < 5.0) // 4
   {
      dist = min(min(min(
                  digit(p, 1.0), digit(p, 2.0)),
                  digit(p, 3.0)), digit(p, 5.0));
   }
   else if(n < 6.0) // 5
   {
      dist = min(min(min(min(
                  digit(p, 0.0), digit(p, 1.0)),
                  digit(p, 3.0)), digit(p, 5.0)),
                  digit(p, 6.0));
   }
   else if(n < 7.0) // 6
   {
      dist = min(min(min(min(min(
                  digit(p, 0.0), digit(p, 1.0)),
                  digit(p, 3.0)), digit(p, 5.0)),
                  digit(p, 6.0)), digit(p, 4.0));
   }
   else if(n < 8.0) // 7
   {
      dist = min(min(
                  digit(p, 0.0), digit(p, 2.0)),
                  digit(p, 5.0));
   }
   else if(n < 9.0) // 8
   {
      dist = min(min(min(min(min(min(
                 digit(p, 0.0), digit(p, 1.0)),
                 digit(p, 2.0)), digit(p, 4.0)),
                 digit(p, 5.0)), digit(p, 6.0)),
                 digit(p, 3.0));
   }
   else // 9
   {
      dist = min(min(min(min(min(
                  digit(p, 0.0), digit(p, 1.0)),
                  digit(p, 3.0)), digit(p, 5.0)),
                  digit(p, 6.0)), digit(p, 2.0));
   }

   return step(dist, 0.0);
}


void doSlimeFieldDisplay(vec2 p)
{
    if(p.x >= slime_preview_org.x && p.y >= slime_preview_org.y &&
       p.x < (slime_preview_org.x + slime_preview_size.x) &&
       p.y < (slime_preview_org.y + slime_preview_size.y))
    {
        // three-slime preview
        
        // hack hack hack
        
        vec2 slime_coord = floor((p - slime_preview_org) / slime_cell_size);
        vec2 cell_org = slime_preview_org + slime_coord * slime_cell_size;

        // a little hardcoding hack to get at the preview colours here....
        gl_FragColor.rgb = slimeTileGraphic((p - cell_org) / slime_cell_size, SLIME_COLOUR_AT(SLIME_NEXT_LOC_0 + vec2(slime_coord.y, 0.0)));
    }
    else if(p.x >= slime_field_display_org.x && p.y >= slime_field_display_org.y &&
       p.x < (slime_field_display_org.x + slime_field_display_size.x) &&
       p.y < (slime_field_display_org.y + slime_field_display_size.y))
    {
        // the in-play slime field
        
        vec2 slime_coord = floor((p - slime_field_display_org) / slime_field_display_size * vec2(float(SLIME_FIELD_WIDTH), float(SLIME_FIELD_HEIGHT)));
        
        vec2 cell_org = slime_field_display_org + slime_field_display_size * slime_coord / vec2(float(SLIME_FIELD_WIDTH), float(SLIME_FIELD_HEIGHT));
        
        gl_FragColor.rgb = vec3(0.0);
        
        float stype = SLIME_TYPE_AT(SLIME_FIELD_ORG + slime_coord), scol = SLIME_COLOUR_AT(SLIME_FIELD_ORG + slime_coord);
        
        if(stype == STATIONARY_SLIME_TYPE)
        {
            gl_FragColor.rgb = slimeTileGraphic((p - cell_org) / slime_cell_size, scol);
        }
        else if(stype == FALLING_SLIME_TYPE)
        {
            float ofs = slime_cell_size.y * mod(FRAME_COUNTER + FALLING_SLIME_ANIMATION_LENGTH - 1.0, FALLING_SLIME_ANIMATION_LENGTH) / FALLING_SLIME_ANIMATION_LENGTH;
            if(p.y > cell_org.y + ofs)
            gl_FragColor.rgb = slimeTileGraphic((p - cell_org - vec2(0.0, ofs)) / slime_cell_size, scol);
        }
        else if(stype == MELTING_SLIME_TYPE)
        {
            float fade = 1.0 - mod(FRAME_COUNTER + MELTING_SLIME_ANIMATION_LENGTH - 1.0, MELTING_SLIME_ANIMATION_LENGTH) / MELTING_SLIME_ANIMATION_LENGTH;
            gl_FragColor.rgb = slimeTileGraphic((p - cell_org) / slime_cell_size, scol) * fade;
        }
        
        if(SLIME_TYPE_AT(SLIME_FIELD_ORG + slime_coord + vec2(0.0, -1.0)) == FALLING_SLIME_TYPE)
        {
            float ofs = slime_cell_size.y * mod(FRAME_COUNTER + FALLING_SLIME_ANIMATION_LENGTH - 1.0, FALLING_SLIME_ANIMATION_LENGTH) / FALLING_SLIME_ANIMATION_LENGTH;
            if(p.y < cell_org.y + ofs)
            gl_FragColor.rgb = slimeTileGraphic((p - cell_org - vec2(0.0, ofs)) / slime_cell_size + vec2(0.0, 1.0), SLIME_COLOUR_AT(SLIME_FIELD_ORG + slime_coord + vec2(0.0, -1.0)));
        }
    }
}

void doBackgroundDisplay(vec2 p)
{
   const float bplas_cell_res = 50.0;
   vec2 bplas_loc = floor(p * bplas_cell_res + vec2(0.5)) / bplas_cell_res;
   
   float bplas_ofs = sin(bplas_loc.y * 6.0 - time * 0.7) * cos(bplas_loc.y * 10.0 + time * 1.5) * 0.1;
   float bplas_width = (1.0 + cos(time * 0.5)) * 0.2;

   float bplas = 2.0 * min(bplas_loc.x - 0.2 + bplas_ofs, -(bplas_loc.x - 0.5 + bplas_width + bplas_ofs));
   
   bplas = step(0.0, bplas + 0.5 - distance(p, bplas_loc) * bplas_cell_res);

   gl_FragColor.rgb = mix(vec3(0.1, 0.1, 0.2), vec3(0.2, 0.2, 0.3), bplas);

   // black region for slime field
    {
        vec2 fc = slime_field_display_org + slime_field_display_size * 0.5, fs = slime_field_display_size * 0.5;

        if(square(fc, fs, p) < 0.03)
          gl_FragColor.rgb = vec3(0.0);
    }
    
    // black region for three-slime preview
    {
        vec2 fc = slime_preview_org + slime_preview_size * 0.5, fs = slime_preview_size * 0.5;

        if(square(fc, fs, p) < 0.03)
          gl_FragColor.rgb = vec3(0.0);
    }
    
   // black region for score display (oh yes!!)
    {
        vec2 fc = score_display_org + score_display_size * 0.5, fs = score_display_size * 0.5;

        if(square(fc, fs, p) < 0.03)
          gl_FragColor.rgb = vec3(0.0);
    }
}

void doInterfaceDisplay(vec2 p)
{
    float dist;
    
    for(int x = 0; x < SLIME_FIELD_WIDTH; ++x)
    {
        dist = columnZoneDistance(p, float(x));
        
        if(dist < 0.0)
        {
            gl_FragColor.rgb = (columnZoneDistance(MOUSE_COORD, float(x)) < 0.0) ? vec3(0.7) : vec3(0.4);
        }
        else if(dist < 0.005)
        {
            gl_FragColor.rgb = vec3(0.0);
        }
    }
    
    dist = rotateZoneDistance(p);
    
    if(dist < 0.0)
    {
        gl_FragColor.rgb = (rotateZoneDistance(MOUSE_COORD) < 0.0) ? vec3(0.7) : vec3(0.4);
    }
    else if(dist < 0.005)
    {
        gl_FragColor.rgb = vec3(0.0);
    }

    dist = resetZoneDistance(p);
    
    if(dist < 0.0)
    {
        gl_FragColor.rgb = (resetZoneDistance(MOUSE_COORD) < 0.0) ? vec3(0.7) : vec3(0.4);
    }
    else if(dist < 0.005)
    {
        gl_FragColor.rgb = vec3(0.0);
    }
    
    if(p.x > score_display_org.x && p.y > score_display_org.y &&
       p.x <= (score_display_org.x + score_display_size.x) && p.y <= (score_display_org.y + score_display_size.y))
    {
        vec2 digit_size = score_display_size / vec2(float(NUM_SCORE_DIGITS), 1.0);

        float digit_index = floor((p.x - score_display_org.x) / digit_size.x);
        
        vec2 digit_org = score_display_org + vec2(digit_index * digit_size.x, 0.0);
        
        // extract a digit from the score
        digit_index = float(NUM_SCORE_DIGITS) - digit_index - 1.0; // fix the order of significance...
        float n = floor(mod(SCORE_COUNTER / pow(10.0, digit_index), 10.0));
        
        gl_FragColor.rgb = vec3(numberMask((p - digit_org) / digit_size, n));
    }
    
}

void doDisplay()
{
    vec2 p = gl_FragCoord.xy / resolution.xy * vec2(resolution.x / resolution.y, 1.0);
    
    p.y = 1.0 - p.y;
    
    doBackgroundDisplay(p);
    doSlimeFieldDisplay(p);
    doInterfaceDisplay(p);
}

void main(void)
{
    // pass through data from the backbuffer if no changes are made
    gl_FragColor.a = NUM_TO_ALPHA(MEM_AT(MEM_LOC));

    doLogic();
    doDisplay();

    //gl_FragColor.rgb += vec3(gl_FragColor.a * 10.0);
}
