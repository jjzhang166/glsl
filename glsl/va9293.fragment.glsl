//
// Relationship between morton distance and sdf circle
// explored visually
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

float sdfCircle(vec2 p, vec2 t, float r)
{
	return length(-t+p) - r;
}

float dmCirclish(vec2 p, vec2 t, float r)
{
	float d = mortonDist(p, t);
	return (d < r) ? d/r : 0.0;
}

void main( void ) 
{
	float maxv = float(mortonEncode(resolution));
	float maxw = length(resolution);
	float zdist = mortonDist(gl_FragCoord.xy, mouse*resolution) / maxv;
	float dist = sdfCircle(gl_FragCoord.xy, mouse*resolution, 5.0) / maxw;
	
	gl_FragColor = vec4(vec3(dist-zdist)*8.0, 1.0);
}