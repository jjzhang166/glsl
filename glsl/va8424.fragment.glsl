#ifdef GL_ES
precision mediump float;
#endif 

/*
	@jimhejl
	4/30/13
*/

uniform float time;
uniform vec2 resolution;

uniform float mouse;

float s(float s, float magR, float d)
{
    float ood = (1.0 / d);
    float lx = s * exp(1.0-(magR));
    lx = log((lx * ood) + 1.0) * d;
    return (lx); 	
}

float lerp(float a, float b, float i)
{
    return ((a*(1.0-i)) + (b*i));
}

vec3 lerp(vec3 a, vec3 b, float i)
{
    return ((a*(1.0-i)) + (b*i));
}

void main( void ) {
    
    float halo = 0.0;
    float flare = 0.0;
    float size = resolution.x / 2.0;
    float g = 0.99;
    const int CNT = 9;
	
    // screen space intensity (1.0 at center, 0.0 at corners)
    float hUV =1.0 - length((gl_FragCoord.xy-vec2(resolution.x*.5,resolution.y*.5))/vec2(resolution.x,resolution.y));
    hUV = (hUV - 0.5) * 2.0;		// uv (0,0) at center
    float intensity = length(hUV);	// magnitude is intensity

    // create bar pattern
    float pattern = intensity * sin(gl_FragCoord.x);

    for (int i = 0; i < CNT; ++i) 
    {
	float illum;
        vec2 position = resolution / 2.0;
        position.x += sin(time / 3.0 + 1.0 * float(i)) * resolution.x * 0.25;
        position.y += tan(time / 556.0 + (2.0 + sin(time) * 0.01) * float(i)) * resolution.y * 0.25;
        
        float dist = length(gl_FragCoord.xy - position) * .88;

	illum  = s(1.0,dist*0.06,.85) * 0.5;	// internal flare
	    
        halo  += s(pattern,pow(dist,0.44)*0.2,.2);
 	flare += s(.4,dist*0.009,.33)*.5;	// glow
	    
	// accumulate
        halo  += illum * 2.0;
	flare += illum * 2.0;
    }
	
    halo  *= pattern;	// create bars
    flare *= lerp(1.0-pattern,intensity,1.0-intensity);	// keep off the corners
	
    // colorize the 2 terms
    vec3 vH = vec3(halo,halo,halo) * vec3(1.2,0.98,0.8) * 1.2;	// pattern / background
    vec3 vF = vec3(flare,flare,flare) * vec3(0.7,.87,1.45);	// lights
    vec3 vOut = max(vH,vF*.55);

    gl_FragColor = vec4(vOut.r,vOut.g,vOut.b,1);
}