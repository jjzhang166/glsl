#ifdef GL_ES
precision mediump float;
#endif 

// Simple classic game in GLSL
// Higly UNOPTIMIZED
//
// Try to leave clean the screen!!!
// Go to the far top-right of the screen in order to clean and restart
//
// by guti @ http://www.nonacaso.net/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

float random(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	
	if (length(gl_FragCoord.xy-resolution.xy)<resolution.x*0.025) {
		gl_FragColor = vec4( 1.0, 1.0, 1.0, .0);
	} else if (mouse.x > 0.98 && mouse.y > 0.98) {
		gl_FragColor = vec4( .0, .0, .0, .0);
	} else if ((abs(gl_FragCoord.y - mouse.y*resolution.y) < resolution.y*0.005) &&
	    (abs(gl_FragCoord.x - mouse.x*resolution.x) < resolution.x/20.0)) {
		gl_FragColor = vec4( 0.0 , 1.0, .0, 1.0 );
	} else if (gl_FragCoord.y - mouse.y*resolution.y < 1.0 &&
		 gl_FragCoord.y - mouse.y*resolution.y > -resolution.y*0.025 &&
		 (abs(gl_FragCoord.x - mouse.x*resolution.x) < resolution.x/20.0)) {
		gl_FragColor = vec4( 0.0 , 0.0, 0.0, 1.0 );
	} else if(gl_FragCoord.y >= resolution.y-0.5) {
		gl_FragColor = vec4( 1.0, .0, .0, .0);
	} else {
		vec2 p = gl_FragCoord.xy / resolution.xy;
		vec2 pup = vec2(p.x, (gl_FragCoord.y+1.5)/resolution.y);
		
		float rup = texture2D(bb, pup).x;
		float rp = texture2D(bb, p).x;
	
		float rand;
		rand = random(vec2(floor(p.x*100.0)+floor(time*3.0), floor(p.y*200.0)));
		rand += random(vec2(floor(p.x*21.13), floor(p.y*20.0))); 
		rand *= 0.18;
		
		gl_FragColor = vec4( rp * 0.01 + rup*rand + rp*(1.0-rand), .0, .0, .0);
		
		//gl_FragColor = vec4( .0, .0, .0, .0);
		//gl_FragColor = vec4(mouse.x, mouse.y, .0, 1.0);
	}
}