#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
	
const int counter = 0;


void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy/resolution );
	position.x *= resolution.x/resolution.y;
	vec2 myMouse = vec2( mouse.x * resolution.x/resolution.y, mouse.y);
	
	float color = 0.0;
	
	float radius = .025;
	
	
	vec2 p = position;
	p.x -= myMouse.x;
	p.y -= myMouse.y;
	
	float r = sqrt(dot(p,p));
	
	if( r < radius) {
		color = 1.0;
		
	}
	
	vec3 b = vec3(color);
	
	b += texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).rgb;
	b += vec3(color);
	
	gl_FragColor = vec4( b, 1.0 );

}