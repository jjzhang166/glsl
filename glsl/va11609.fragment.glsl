#ifdef GL_ES
precision mediump float;
#endif

// HELP Please! I don't understand why pos isn't scaled 0 to 1
// based on the box which should show col.g for the upper/right edge.

uniform vec2 resolution;
uniform float time;

void main( void ) {
	
	vec2 pos =  ((  (gl_FragCoord.xy / resolution.xy) ) - 0.5) ; // position of our pixel, with vec2(0.0, 0.0) centred

	pos.x *= resolution.x / resolution.y; // correct for aspect ratio, e.g. 1024/768

	//pos *= vec2(1.13,2.02);

	float len = sqrt(pos.x*pos.x + pos.y*pos.y); // pythagorus, aka len(), how far is our pixel from centre
//        float len = length(pos);
	
        vec3 col = vec3(0.0,0.0,0.0); // col is the colour we'll return

	if (len < 0.3) { col.rgb = vec3(0.4,1.0,0.0); } // if we are not far from centre, set our colour to a green	
	
	if (pos.x < 0.0) { col.rgb *= 0.75; } // darken left hand side
	if (pos.y > 0.0) { col.r *= 2.5; }

	// red/green border to box 
	//if (pos.y > .999) { col.g = 1.; }	
	//if (pos.x > .999) { col.g = 1.; }	
	//if (pos.x < .001) { col.r = 1.; }	
	//if (pos.y < .001) { col.r = 1.; }	
//	col *= .3 * (2.*sin(time)+.5);
	gl_FragColor = vec4(col, 1.0); // return the colour

}