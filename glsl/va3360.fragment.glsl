#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float width = 1.0; // line width
	float scale = 1.0; // increase to see the pixels
	float fudge = 0.7; // width-invariant
	float timescale = 0.1;
	vec2 dir = vec2(cos(time*timescale), sin(time*timescale));
	vec2 pt = vec2(64.0, 128.0) / scale;
	
	vec3 plane = vec3(dir, -dot(dir, pt));
	vec2 coord = floor(gl_FragCoord.xy / scale);
	vec3 pos = vec3(coord - (resolution.xy / (scale * 2.0)), 1.0);
	
	float dp = dot(pos, plane);
	float coverage = abs(dp*fudge) - (width - 1.0);
	
	gl_FragColor = vec4( vec3(coverage), 0.0 );
}
