#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );	
	uv.x += cos(uv.x + time/uv.y) / mouse.y;
	uv.y += sin(uv.x + time/uv.y) / mouse.x;
	gl_FragColor = vec4(0.25,0.75,0.25,1) * atan(uv.x / uv.y);			
}