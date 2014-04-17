#ifdef GL_ES
precision highp float;
#endif

uniform float time;

uniform vec2 mouse;
uniform vec2 resolution;

// These enable pan/zoom controls
uniform vec2 surfaceSize;
varying vec2 surfacePosition;

void main( void ) {
	vec2 coord = gl_FragCoord.xy / resolution;
		
	float r = coord.x;//sin(time);
	float g = mouse.y;//sin(time + 10.0);
	float b = mouse.x;//sin(time + 20.0);
	vec3 rgb = vec3(r,g,b);
	
	gl_FragColor = vec4( rgb, 1.0 );
}