#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
 float ROTATION_RATE = cos(time)*mouse.x;

vec3 colors(vec2 uv){
 	vec3 c;
	float cs = time+.5*atan(uv.x, uv.y);
	c.r = cos(cs-1.);
	c.g = sin(cs-1.6);
	c.b = cos(cs+1.);
	return c;
}

void main( void ) {

//	vec2 center = vec2( sin( time ), cos( time ) );
	vec2 center = ( resolution.xy / 2.0 ) + (resolution.y / 2.0) * vec2( sin( ROTATION_RATE * time ), cos( ROTATION_RATE * time ) );
	
//	vec2 center = vec2( 100.0, 10.0 );
	float dist = abs( distance( gl_FragCoord.xy, center ) ); 
//	vec3 color = vec3( sin( dist + time ), cos( dist + time ), tan( dist + time ) );
//	color += 20.0 * noise3( gl_FragCoord.x + time );
	
	vec3 color = vec3( sin( dist ), sin( dist ), sin( dist ) );

	color += .05 * colors(center);
	
	vec2 p = vec2(1.)/gl_FragCoord.xy;
	vec4 b0 = texture2D(backbuffer, gl_FragCoord.xy/resolution.xy + vec2( 1.,  1.) * p);
	vec4 b1 = texture2D(backbuffer, gl_FragCoord.xy/resolution.xy + vec2(-1., -1.) * p);
	vec4 b2 = texture2D(backbuffer, gl_FragCoord.xy/resolution.xy + vec2( 1., -1.) * p);
	vec4 b3 = texture2D(backbuffer, gl_FragCoord.xy/resolution.xy + vec2(-1.,  1.) * p);
	
	vec4 buffer = b0 - b1 * b2 - b3;
	
	gl_FragColor = .075 * vec4( color, 1.0 ) + buffer;
}