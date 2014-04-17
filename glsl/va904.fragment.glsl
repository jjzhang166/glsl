//Simple and very slow raytracing :-)
//
//OnScript

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void) {
	vec2 position = gl_FragCoord.xy / resolution.x;
	float color = 0.0;
	vec3 dr = normalize(vec3(position.x - 0.5, position.y - (resolution.y / resolution.x) / 2.0, 1.0));
	vec3 r = vec3(0.0);
	vec3 sphere = vec3(32.0 * cos(time), 16.0 * sin(2.0 * time), 128.0);
	float radius = 32.0;
	vec3 light = vec3(0.0, 0.0, 112.0);
	//Raytracing (too many iterations because otherwise result will be worse)
	for (int i = 0; i < 512; i++) {
		vec3 n = r - sphere;
		if (length(n) <= radius) {
			//Calculate light
			vec3 l = normalize(sphere - light);
			vec3 nn = normalize(n);
			float f = (l.x * nn.x + l.y * nn.y + l.z * nn.z);
			vec3 a;
			if (f < 0.0) {
				a = l - 2.0 * f * nn;
				color = - (dr.x * a.x + dr.y * a.y + dr.z * a.z);
			}
			break;
		}
		r += dr / 2.0;
	}
	//Just playing with colors
	gl_FragColor = vec4(color * abs(cos(time)), color * abs(sin(time)), color * abs(sin(2.0 * time)), 0.0);
}