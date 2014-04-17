#ifdef GL_ES
precision highp float;
#endif
#define PI 3.14159265

// green:  00ffcc
// yellow: ffed86
// red:    ff4d3e
const vec3 ff    = vec3( 0xff, 0xff, 0xff );
const vec3 green = vec3( 0x00, 0xff, 0xcc ) / ff;
const vec3 red   = vec3( 0xff, 0x4d, 0x3e ) / ff;
	
uniform float time;
uniform vec2 resolution;

float circle( float radius, float fuzzy, vec2 p ) {
	float d = length(p);
	return 1.0 - smoothstep( radius*(1.0-fuzzy), radius*(1.0+fuzzy), d );	
}

void main( void ) {
	vec2 center = resolution.xy / 2.0;
	vec2 position = gl_FragCoord.xy;
	vec2 p = (position-center) / resolution.y;
	float d = length(p); 
	
	
	float wipe_angle = mod( 0.2*time*PI*2.0-PI/2.0, PI*2.0 );
	float angle =  mod(  atan( p.y, p.x )-PI/2.0, 2.0*PI);
	
	float radar = circle( 0.5, 0.003, p );
	radar = clamp( radar - smoothstep( wipe_angle, wipe_angle+0.02, angle) , 0.0, 1.0);
	vec4 r = vec4( red,   circle( 0.5, 0.003, p) );
	vec4 g = vec4( green, radar );
	
	vec4 o = vec4(0);
	float white_circle = circle( 0.45, 0.003, p );
	
	o = vec4(r.a)*r  + vec4(1.0-r.a)*o;
	o = vec4(g.a)*g  + vec4(1.0-g.a)*o;
	o = vec4(1.0,1.0,1.0, white_circle)*white_circle  + vec4(1.0-white_circle)*o;
	
	gl_FragColor = o;
}