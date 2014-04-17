//Conway's Game of Life
//By: Flyguy

//Old shader I made, now works properly.

// Hooray for Mazetric!
// Also modified cell die (I don't know why but it really bugs me cells when aren't either dead or alive)

// Color changes by @emackey

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 position = vec2(0);

vec3 dead = vec3(0);
vec3 alive_color = vec3(0.1, 0.1, 0);

bool isAlive(vec3 color)
{
	return ((color.r == 1.0) || (color.g == 1.0) || color.b == 1.0);
}

vec3 getcell()
{
    return texture2D(backbuffer, position/resolution.xy).xyz;
}

vec3 getcell(float ox, float oy)
{
    return texture2D(backbuffer, mod((position+vec2(ox, oy)), resolution)/resolution.xy).xyz;
}

int neighbors(vec3 color)
{
    int i = 0;
    //Left/Right/Up/Down
    if(isAlive(getcell(-1.0,0.0))) { i++; }
    if(isAlive(getcell(1.0,0.0))) { i++; }
    if(isAlive(getcell(0.0,-1.0))) { i++; }
    if(isAlive(getcell(0.0,1.0))) { i++; }
	
    //Diagonals
    if(isAlive(getcell(-1.0,-1.0))) { i++; }
    if(isAlive(getcell(1.0,-1.0))) { i++; }
    if(isAlive(getcell(1.0,1.0))) { i++; }
    if(isAlive(getcell(-1.0,1.0))) { i++; }
	
    return i;
}

bool rand(vec2 co){
    float v = fract(sin(dot(co.xy+time ,vec2(12.9898,78.233))) * 43758.5453+time);
    if(v>0.5) return true;
    else return false;
}

vec3 endColor = vec3(0);

void main( void ) 
{
    position = gl_FragCoord.xy;
    float modTime = mod(floor(mod(time * 0.1, 4.0)) + distance(gl_FragCoord.xy, mouse*resolution) * 0.02, 4.0);
    vec3 myColor = getcell();

	if (modTime < 1.0) {
		alive_color = vec3(1.0, 1.0, 0.0);
	} else if (modTime < 2.0) {
		alive_color = vec3(0.0, 1.0, 0.0);
	} else if (modTime < 3.0) {
		alive_color = vec3(0.0, 1.0, 1.0);
	} else {
		alive_color = vec3(1.0, 0.0, 1.0);
	}

    int n1 = neighbors(alive_color);

    endColor = myColor - vec3(1.01 / 255.0);
	
    if (distance(gl_FragCoord.xy, mouse*resolution) < 8.0) {
        endColor = alive_color;
    }
    else if (myColor == alive_color)
    {
	if(n1 <= 4 && n1 >= 1)
	{
	    endColor = alive_color;
	}
    } else if (!isAlive(myColor)) {
	if(n1 == 3)
	{    
	    endColor = alive_color;
	}
    }
    
    gl_FragColor = vec4(endColor, 1.0);
}
