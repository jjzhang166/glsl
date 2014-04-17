// @timb

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	
	float maxbarlength = (mouse.x * mouse.y * (200.0 + (sin(time+position.x+position.y)*sin(time)*mouse.y*mouse.x*300.0) ));
	
	float px = mouse.x + position.x;
	float py = mouse.y + position.y;
	
	float randxy1 = rand(vec2(floor(gl_FragCoord.x / maxbarlength), py))  * ((1.0 - mouse.x) * ((sin(time)+10.0)*5.0) );
	float randxy2 = rand(vec2(px, floor(gl_FragCoord.y / maxbarlength))) * ((1.0 - mouse.y) * ((sin(time)+10.0)*5.0) );
	
	float sx = floor(gl_FragCoord.x / (randxy1 * maxbarlength));
	float sy = floor(gl_FragCoord.y / (randxy2 * maxbarlength));

	float s = (sx + sy) ;
	
	float r1 = rand(vec2(s, s)) * s + (1.0 - s);
	float r2 = rand(vec2(s+1.0, s+1.0)) * s + (1.0 - s);
	float r3 = rand(vec2(s+2.0, s+2.0)) * s + (1.0 - s);
	
	float rr = (r1 + mouse.y) / 2.0;
	float rg = (r2 + mouse.x) / 2.0;
	
	gl_FragColor = vec4( rr, rg, r3,  1.0);
	
}