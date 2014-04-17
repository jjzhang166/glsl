precision mediump float;

uniform float time;

const float SQUARE_LENGTH = 100.0;
const float BORDER_LENGTH = 2.0;

const vec4 BORDER_COLOR = vec4(0.0, 0.0, 0.0, 30.0);
const vec4 OFF_COLOR = vec4(0.15, 0.15, 0.15, 50.0);

vec4 uvToSquareCoords(vec2 uv);
vec4 color(vec2 square);

void main( void ) {
    vec2 uv = gl_FragCoord.xy;
    float angle = atan(uv.x/uv.y);
    float l = length(uv);
    
    angle = angle + cos (time / 2.0) *(l / 1500.0);
    
    uv = l * vec2(cos(angle), sin(angle));
    uv += vec2(time * 600.0, 0.0);
    //uv = mat2(cos(time / 2.0), sin(time / 2.0), -sin(time / 2.0), cos(time / 2.0)) * uv;
    vec4 sqr_coords = uvToSquareCoords(uv);
    
    if (sqr_coords.z <= BORDER_LENGTH || sqr_coords.z >= SQUARE_LENGTH - BORDER_LENGTH) {
        gl_FragColor = BORDER_COLOR;
        return;
    }
    
    if (sqr_coords.w <= BORDER_LENGTH || sqr_coords.w >= SQUARE_LENGTH - BORDER_LENGTH) {
        gl_FragColor = BORDER_COLOR;
        return;
    }
    
    gl_FragColor = (0.5 + abs(sin(time) + cos(2.0 * time))) * vec4(abs(sin(sqr_coords.x / 5.0 + time)),abs(cos(sqr_coords.y / 2.0 + time)), 0.0, 1.0) + OFF_COLOR;
}

vec4 uvToSquareCoords(vec2 uv) {
    vec4 sqr_coords;
    sqr_coords.xy = floor(uv / SQUARE_LENGTH);
    sqr_coords.zw = uv -  SQUARE_LENGTH * sqr_coords.xy;
    
    return sqr_coords;
}

vec4 effect1(vec2 pos);