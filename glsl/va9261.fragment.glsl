//
// Visualization of distance field in 2D Morton order
// with distance between pixel and mouse coordinates defined as:
// D = | Morton(pixel) - Morton(mouse) |
// and normalized with maximum integer value given by resolution
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
	int b = mortonEncode(mouse * resolution);
	int m = mortonEncode(resolution);
	float dist = abs(float(a-b)) / float(m);
	vec3 c[3];
	c[0] = vec3(0.0, 0.0, 1.0);
 	c[1] = vec3(1.0, 1.0, 0.0);
 	c[2] = vec3(1.0, 0.0, 0.0);
	
	int i = (dist < 0.5)? 0:1;
	vec3 th;
 	th = (i==0) ? mix(c[0], c[1], (dist-float(i) * 0.5) / 0.5) : mix(c[1], c[2], (dist-float(i) * 0.5) / 0.5);
	
	gl_FragColor = vec4(th, 1.0);
}