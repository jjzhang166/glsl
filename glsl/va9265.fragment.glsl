//
// Visualization of distance field in 2D Morton order
//
// TODO: could use a different color scale to visualize small changes
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

void main( void ) 
{
	int a = mortonEncode(gl_FragCoord.xy);
	int c = mortonEncode(vec2(0.5 + (.5 * sin(time)), 0.5) * resolution);
	
	int m = mortonEncode(resolution);
	float dist = (float(a-c) / (float(m)/resolution.x));

	gl_FragColor = vec4(dist);
}