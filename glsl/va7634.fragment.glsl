#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float piMultiply;
uniform float interPatternWave;
uniform float accel;

uniform float patternResolve;

uniform float patternRc;
uniform float patternGc;
uniform float patternBc;

uniform float bgRc;
uniform float bgGc;
uniform float bgBc;

float PI = 3.141592;

vec2 adjustAspectRatio( vec2 v) {
	return v * vec2(resolution.x / resolution.y, 1.0) + vec2(-resolution.y / resolution.x * 0.3, 0.0);
}

float makePattern(float n, float m, float r, vec2 position, vec2 center, float phase) {
	float piMultiply = 1.0;	
	float patternResolve = .5;
	
	float c = 0.0;
	vec2 v = position - center;
	float theta = atan(v.y, v.x);
	float t = (theta + PI) / (PI * piMultiply) + phase;
	float d = distance(position, center);
	c = cos(t * (PI * 1.) * (n * 1.) + (r * 1.) * sin(d * (PI * 1.0) * (m * -11.3)));
	c = c > patternResolve ? 0.0 : 1.0;	// makes the round things round, and the square things square
	return c;
}

void main( void ) {
	float interPatternWave = 2.0;
	float interPatternRes = 100.0;
	float accel = 0.02;
	
	float patternRc = 0.0;
	float patternGc = 0.9;
	float patternBc = 0.2;
	
	vec2 position = adjustAspectRatio( gl_FragCoord.xy / resolution.xy );
	float c = 9.0;
	vec2 center = adjustAspectRatio(vec2(0.5, 0.5));
	float c1 = makePattern(interPatternRes, interPatternWave, 2.0, position, center, time * accel);
	float c2 = makePattern(interPatternRes, interPatternWave, 2.0, position, adjustAspectRatio(mouse), 0.03);
	c = max(pow(c1 + c2 - c1 * c2, 0.01), 0.0);
	
	vec3 color1 = vec3(patternRc, patternGc, patternBc);
	vec3 color2 = vec3(0.0, 0.0, 0.0);
	
	vec3 color = mix(color1, color2, c);
	
	gl_FragColor = vec4( color, 1.0 );

}