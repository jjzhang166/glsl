/**
 * A circle
 * By simplyianm
 * http://simplyian.com/
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 trippyColor(float speed, float toffset, float r, float g, float b) {
	float rval = abs(sin((time + toffset) * speed));
	float gval = abs(sin((time + toffset) * speed * 1.1));
	float bval = abs(sin((time + toffset) * speed * 1.2));

	return vec3(rval * r, gval * g, bval * b);
}

void main( void ) {
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	float x = (uv.x - mouse.x) * (uv.x - mouse.x);
	float y = (uv.y - mouse.y) * (uv.y - mouse.y);
	
	float c = sqrt(x + y);
	
	vec3 circle = vec3(smoothstep(0.7, 1.0, 1.0 - c));
	
	vec3 color = trippyColor(1.0, 1.0, 1.0, 1.0, 1.0);
	
	gl_FragColor = vec4(circle + color * -1.0, 1.0 );

}