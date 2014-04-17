/**
 * Trippy effect
 * By Ian Macalinao
 * http://simplyian.com/
 *
 * This is my first GLSL shader!
 */

//All scripture is God-breathed and is useful for teaching, rebuking, correcting and training in righteousness... 2 Timothy 3:16<-what are you the fucking tim tebow of the demoscene? Ever notice how DIVIDED people get when they fling their shit in other people's faces? Kinda against the point of it all, right? When you make divisions, you perpetuate them.

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


//Waves

vec3 sinwave(vec3 color, float pos, float xoffset, float yoffset, float slope) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	float x = (uv.x * 10.0) + (time * 10.0) - xoffset;
	
	float xclip = (sin(x) / 10.0) + yoffset;
	float step = smoothstep(0.9, 1.0, 1.0 - abs(uv.y - xclip));

	return color * step;
}

vec3 coswave(vec3 color, float pos, float xoffset, float yoffset, float slope) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	float x = (uv.x * 10.0) + (time * 10.0) - xoffset;
	
	float xclip = (cos(x) / 10.0) + yoffset;
	float step = smoothstep(0.9, 1.0, 1.0 - abs(uv.y - xclip));

	return color * step;
}

vec3 tanwave(vec3 color, float pos, float xoffset, float yoffset, float slope) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	float x = (uv.x * 10.0) + (time * 1.0) - xoffset;
	
	float xclip = (tan(x) / 10.0) + yoffset;
	float step = smoothstep(0.9, 1.0, 1.0 - abs(uv.y - xclip));

	return color * step;
}

vec3 waves() {
	
	vec3 color;
	
	vec3 wave1 = sinwave(trippyColor(1.0, 0.0, 1.0, 1.0, 1.0), 0.25, mouse.x * 10.0, mouse.y, 1.0);
	vec3 wave2 = coswave(trippyColor(1.0, 1.0, 1.0, 1.0, 1.0), 0.25, mouse.x * 10.0 + 5.0, mouse.y, 1.0);
	vec3 wave3 = tanwave(trippyColor(1.0, 0.0, 0.5, 0.75, 0.25), 0.25, 4.0, 0.5, 1.0);
	
	return wave1 + wave2 + wave3;
}

void main(void) {
	
	
	
	gl_FragColor = 	vec4(waves(), 0.0);
}