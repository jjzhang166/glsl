// Psycoflowers - @h3r3
// now with more psycho ;)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getVal(in vec2 position) {
	float u = sqrt(dot(position, position));
	float v = atan(position.y, position.x);
	float t = time + 1.0 / u;
	float val = sin(((sin(time*10.)/10.+(sin(time)+2.))*5.) * (time * 3.0 + 10.0 * v) );
	return max(-0.5,val);
}

float getMix(in vec2 position, float n) {
	float val1 = getVal(position + vec2(cos(time * 0.35 + n + n), sin(time * 0.23 + n + 10.0)) * 0.8);
	float val2 = getVal(position + vec2(sin(time * 0.21 + n * n), cos(time * 0.36 + n + 4.2)) * 0.8);
	return (val1 * val2 + val1 + val2) * 0.6;
}

vec3 colorMix(in vec2 position, in vec3 color, in float n) {
	float val = getMix(position, n);
	return color * val + (1.0 - val) * vec3(0.1, 0.05, 0.1);
}

void main()
{
	vec2 position = -1.0 + 2.0 * (gl_FragCoord.xy / resolution.xy);
	position.x *= resolution.x / resolution.y;


	vec3 color = vec3(0.0);
	for (float i = 0.; i <2.; i++) {
		float fi = i * i + i;
		color += colorMix(position, vec3(sin(fi * 0.8), sin(fi * 0.7) * 0.4, sin(fi * 0.7 + 2.0)), fi);
	}
	
	gl_FragColor = vec4(color, 1.0);

}