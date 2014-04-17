//
// A "Circle" in morton distance, really?
// Who the heck would care about what that could look like?
// NOTE: if you also have a good friend who keeps talking about Z-order curves,
// you can pull this out, have fun and play.
//
// @rianflo 
//
//

#ifdef GL_ES
precision highp float;
precision highp int;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//
// 2d morton code for 14-bits each
// no overflow check
//
int mortonEncode(vec2 p) 
{
	// no bitwise in webgl, urgh...
	// somebody optimize this please :)
    	int c = 0;
    	for (int i=14; i>=0; i--) {
		float e = pow(2.0, float(i));
        	if (p.x/e >= 1.0) {
            		p.x -= e;
            		c += int(pow(2.0, 2.0*float(i)));
        	}
	    	if (p.y/e >= 1.0) {
            		p.y -= e;
            		c += int(pow(2.0, 1.0+2.0*float(i)));
		}
        }
    	return c;
}

float mortonDist(vec2 p, vec2 q)
{
	return abs(float(mortonEncode(p) - mortonEncode(q)));
}

float dmCirclish(vec2 p, vec2 t, float r)
{
	float d = mortonDist(p, t);
	return (d < r) ? d/r : 0.0;
}

void main( void ) 
{
	float maxv = float(mortonEncode(resolution));
	float dist = dmCirclish(gl_FragCoord.xy, mouse*resolution, 2048.0);
	
	gl_FragColor = vec4(vec3(dist), 1.0);
}