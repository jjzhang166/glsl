#ifdef GL_ES
precision highp float;
precision highp int;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


int mortonEncode(vec2 p) 
{
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

void main( void ) {

	vec2 p = gl_FragCoord.xy;
	vec2 q = mouse * resolution;

	gl_FragColor = vec4( vec3( 1.0 ), 1.0 );

}