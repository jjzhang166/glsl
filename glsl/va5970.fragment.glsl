#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float aspect = 1280.0 / resolution.x;
	vec3 color;
	vec2 f1 = vec2(resolution.x * 0.33, resolution.y * 0.5);
	vec2 f2 = vec2(resolution.x * 0.66, resolution.y * 0.5);
	float sum = 300.0;
	
	float dist = length(f1-gl_FragCoord.xy) + length(f2-gl_FragCoord.xy);
	color = vec3(0,0.5,1) / (aspect*0.5) / abs(sum-dist);
	gl_FragColor = vec4( color, 1.0 );
}