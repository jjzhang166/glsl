#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(.5);
	float len = length(position.y);
	
	float hr = position.y - sin(time);
	float hg = sin(position.x * time * 10.0);
	float hb = position.y - sin(position.x * time * 100.0);
	
	vec4 newColor = vec4( vec3(hr, hg, hb), 1.0 );
	vec4 mask = vec4(vec3(len),1.0);
	gl_FragColor = newColor * (1.0 - mask);
}