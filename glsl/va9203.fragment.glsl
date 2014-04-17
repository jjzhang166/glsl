#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(vec2 co){
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	
	float na = noise(vec2(0, time));
	float nb = noise(vec2(0, 2.0*time));
	float nc = noise(vec2(0, 4.0*time));
	float nd = noise(vec2(0, 8.0*time));
	
	float ca = step(gl_FragCoord.y, resolution.y*na) - step(gl_FragCoord.y, resolution.y*nb);
	float cb = step(gl_FragCoord.y, resolution.y*nc) - step(gl_FragCoord.y, resolution.y*nd);
	float cc = step(gl_FragCoord.y, resolution.y*na) - step(gl_FragCoord.y, resolution.y*nd);
	
	float c = 0.3 * (ca + cb + cc) + 0.3 * noise(0.00001*gl_FragCoord.xy+time);
	c = c * step(0.5, fract(gl_FragCoord.x)) * step(0.5, fract(gl_FragCoord.y));
	vec4 m = vec4(0.4*c,0.4*c,0.4*c,1);
	gl_FragColor = m;
}

