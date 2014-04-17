#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 resolution;

uniform float time;

void main( void ) {
	
	vec2 pos =  (2.0*(gl_FragCoord.xy / resolution.xy) ) - 1. ; // position of our pixel, with vec2(0.0, 0.0) centred
	float x2 = pos.x*(resolution.x/resolution.y);
	float len = sqrt( x2*x2+pos.y*pos.y);
	// pythagorus, aka len(), how far is our pixel from centre
        vec3 col = vec3(0.0,0.0,0.0); // col is the colour we'll return

	if (len < cos(time * 1.3) * .7) { col.rgb = vec3(0.4,1.0,0.0); } // if we are not far from centre, set our colour to a green

	if (len < sin(time) * 1.2 ) { col.rgb = vec3(1.0,0.4,0.0); } // if we are not far from centre, set our colour to a green

	
	if (pos.x < 0.0) { col.rgb *= 0.75; } // darken left hand side

	if (pos.y > 0.0) { col.r *= 2.5; }

	// red/green border to box 
	if (pos.y > .99) { col.g += 1.; }	
	if (pos.x > .99) { col.g += 1.; }	
	if (pos.x < -.5) { col.r += .5; }	
	if (pos.y < -.5) { col.r += .5; }		
	if (pos.y > .5) { col.b += .3; }	
	if (pos.x > .5) { col.b += .3; }
	gl_FragColor = vec4(col, 1.0); 

}