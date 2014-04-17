// by rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265358979323;
const float TWOPI = PI*2.0;

vec2 rotated(float a, float r) {
	
	return vec2(cos(a*TWOPI)*r, sin(a*TWOPI)*r);
}

float circle(vec2 pos, float radius, float smooth) {
	
	float len = length( pos );
	float d = smoothstep( radius-smooth, radius+smooth, len );
	return d;
}

float circles(vec2 pos, float ring_radius, float radius, float smooth) {
	
	float d = 1.0;
	
	for( int i=0; i<12; i++)
	{
		float a = 1.0/12.0*float(i);
		vec2 p = rotated( a,ring_radius)-pos;
		d *=  circle(p, radius, smooth);
	}
	
	
	return d;
}

void main( void ) {

	float speed = time *0.5;
	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
	
	float sint = sin(time);
	float usint = sint*0.5+0.5;
	
	float x = log(length(pos)*4.0);
	float y = abs(pos.y);
	
	
	float shade_a = circles( pos, 0.75,0.125, 0.01);
	vec2 p1 = rotated( fract(speed),0.75);
	float shade_b = circle( p1-pos, 0.125, 0.01);
	
	
	vec3 clr_a = vec3( shade_a, shade_a*0.6, shade_a*0.2 );
	vec3 clr_b = vec3( shade_b*0.2, shade_b*0.6, shade_b*1.0 );
	vec3 clr = mix(clr_a, clr_b, usint);
	
	gl_FragColor = vec4(  clr, 1.0 );

}