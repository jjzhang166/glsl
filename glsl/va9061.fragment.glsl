#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float smooth=0.002;
const float PI = 3.14159265359;
const float slow = 0.5;

float aspect = resolution.x/resolution.y;

vec2 rotate( vec2 p, float angle ) {
	return p * mat2( 
		vec2( cos(angle), -sin(angle) ),
		vec2( sin(angle), cos(angle) )
	);	
}

float rot_rect( vec2 p, vec2 center, vec2 size, float angle ) {
	p = rotate(p-center, -angle);
	vec2 hs = size / 2.0;	
	//return p.x > -hs.x && p.x < hs.x && p.y > -hs.y && p.y < hs.y ? 1.0 : 0.0;
	
	vec2 s = smoothstep( -hs-smooth, -hs, p ) - smoothstep( hs, hs+smooth, p );
	return s.x * s.y;
}

float circle( vec2 p, vec2 center, float rad ) {
	return smoothstep( rad+smooth, rad, distance(p,center) ); 
}

float ring( vec2 p, vec2 center, float rad, float rad_inner ) {
	return circle( p, center, rad ) - circle( p, center, rad_inner );
}

vec4 comp( vec4 a, vec4 b ) {
	float alpha_out = b.a + (1.0-b.a)*a.a;
	vec3 rgb = b.a * b.rgb + (1.0-b.a)*a.a*a.rgb;
	return vec4( rgb * (1.0/alpha_out), alpha_out );
}

float noise(vec2 n) {
	return fract(sin(dot(n.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(float n) {
	return noise(vec2(0.1, n));
}

vec4 layer( vec2 p, float y ) {
	float time_offset = rand(y) * 100.0;
	
	y = y + (rand(y)-0.5)*0.1; //*2.0-1.0;
	float time_mult = 1.0 + rand(y);
	float t = slow*(time*time_mult + time_offset);
	vec2 center = vec2(aspect/2.0, y );
	vec2 offset = rotate( vec2(0.02, 0.0), t*0.13*PI*2.0); 
	float rect = rot_rect( p, center+offset, vec2(aspect*1.2, 0.2), 0.01*sin(t*0.2*PI*2.0) );

	return vec4( 0.5, 0.45, 0.4, rect * 0.2);
}


void main( void ) {
	vec2 p = gl_FragCoord.xy / resolution.y;
	
	vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
	
	//color = comp( color, layer(p, ));
	
	const int count=12;
	for( int i=0; i<count; i++ ) {
		color = comp( color, layer(p, float(i)*1.0/float(count-1)) );
	}

	//color = comp( color, vec4( 0.0, 0.0, 1.0, 0.8*ring( p, center, 0.007, 0.005 ) ) );
	
	gl_FragColor = vec4( color.rgb*color.a, color.a ); // vec4( vec3(rect), 1.0 );
}