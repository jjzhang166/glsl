// Conway's Game of Life
// By Nop Jiarathanakul
// http://www.iamnop.com/
// Adopted by Joshua Moerman

#ifdef GL_ES
precision highp float;
#endif

#define EPS       0.001
#define EPS1      0.01
#define PI        3.1415926535897932
#define HALFPI    1.5707963267948966
#define QUARTPI   0.7853981633974483
#define ROOTTHREE 0.57735027
#define HUGEVAL   1e20

#define EQUALS(A,B) ( abs((A)-(B)) < EPS )
#define EQUALSZERO(A) ( ((A)<EPS) && ((A)>-EPS) )

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 origin = vec2(0.0);
vec2 uv, pos, pmouse, uvUnit;
float aspect;

float circle (vec2 center, float radius) {
    float dist = distance(center, pos);
    
    return dist < radius ? 1.0 : 0.0;
}

float rect (vec2 center, vec2 b) {
    vec2 bMin = center-b;
    vec2 bMax = center+b;
    return ( 
        pos.x > bMin.x && pos.y > bMin.y && pos.x < bMax.x && pos.y < bMax.y 
        ) ? 
        1.0 : 0.0;
}

float countNeighbors(vec2 p) {
    float count = 0.0;
    
    #define KERNEL_R 2
    for (int y=-KERNEL_R; y<=KERNEL_R; ++y)
    for (int x=-KERNEL_R; x<=KERNEL_R; ++x) {
        vec2 spoint = uvUnit*vec2(float(x),float(y));
        count += texture2D(backbuffer, uv+spoint).r;
    }
    
    return count;
}

vec3 gameStep() {
    float isLive = texture2D(backbuffer, uv).r;
    float neighbors = countNeighbors(uv) - isLive;
    
    if (isLive > 0.0) {
        if (neighbors < 7.0)
            return vec3(0.0, 1.0, 0.0);
        else if (neighbors > 21.0)
            return vec3(0.0, 0.0, 1.0);
        else 
            return vec3(1.0, 1.0, 0.0);
    }
    else {
        if (neighbors > 18.0)
            return vec3(1.0, 0.0, 1.0);
        else if (neighbors == 4.0)
	    return vec3(1.0, 1.0, 1.0);
	else
            return vec3(0.0);
    }
}

void main( void ) {
    aspect = resolution.x/resolution.y;
    uvUnit = 1.0 / resolution.xy;
    
    uv = ( gl_FragCoord.xy / resolution.xy );
    pos = (uv-0.5);
    pos.x *= aspect;
    
    pmouse = mouse-vec2(0.5);
    pmouse.x *= aspect;
    
    vec3 cout = vec3(0.0);

    float radius = 0.05;    
    cout += circle(pmouse, radius);
    //cout += rect(pmouse, vec2(radius, radius));
    
    
    cout += gameStep();
    cout += 0.9*vec3(0.0, texture2D(backbuffer, uv).gb);
    
    // clear;
    //cout = vec3(0.0);
	
    gl_FragColor = vec4(cout, 1.0);
}