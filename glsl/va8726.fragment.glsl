// used to be XOR'd carpets

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
varying vec2 surfacePosition;
bool hit(vec2 p)
{
    float direction = .1; // -1.0 to zoom out
    ivec2 sectors;
    const int lim = 5;
    vec2 coordIter = p; // pow(3.0, mod(direction*time, 1.0));
	
    for (int i=0; i < lim; i++) {
        sectors = ivec2(floor(coordIter.xy * 3.0));
        if (sectors.x == 1 && sectors.y == 1) {
            // make a hole
            return false;
        } else {
            // map current sector to whole carpet
            coordIter.xy = coordIter.xy * 3.0 - vec2(sectors.xy);
        }
    }

    return true;
}

void main(void)
{
	vec2 coordOrig = surfacePosition;//abs(gl_FragCoord.xy / resolution.xy-0.5);
    	//coordOrig.y *= resolution.y / resolution.x;
    	//coordOrig = mod(coordOrig, 1.0);
	float t = time*0.5;
	vec4 color = vec4(1.0-length(coordOrig));
	coordOrig = vec2(length(coordOrig)-(time*0.15), sin(t+(length(coordOrig)*(cos(time)*10.0)))*2.0+ atan(coordOrig.x, coordOrig.y));
	for(float i = 0.; i < 3.0; i++) {
		if (hit(i*0.01 + coordOrig))
			color = 1.0 - color;
	}
	gl_FragColor = vec4(1.0-sin(time+color.r+3.0), 1.0-sin(time+color.g+2.0), 1.0-sin(time+color.b+1.0), 1.0);
} 

