#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 position = gl_FragCoord.xy / resolution.y;
	vec3 dd = vec3(time, mouse.y * 50.0, 0.0);
  	vec3 v = vec3(position.xy - 0.5, 0.5) + 0.0001;
	float vxr = v.x * cos(mouse.x * 2.5) + v.z * sin(mouse.x * 2.5);
	v.z = -v.x * sin(mouse.x * 2.5) + v.z * cos(mouse.x * 2.5);
	v.x = vxr;
	vec3 ddt = fract(dd);
	ivec3 ddi = ivec3(dd);
	vec3 d = 1.0 / v;
	vec3 ll = d * (1.0 - ddt);

	ivec3 p = ivec3(sign(d));

	if (d.x < 0.0)
		ll.x = -d.x * ddt.x;
	if (d.y < 0.0)
		ll.y = -d.y * ddt.y;
	if (d.z < 0.0)
		ll.z = -d.z * ddt.z;

    	d = abs(d);

	int P = ddi.x + ddi.y + ddi.z;
	float color = 1.0;
	float k2;
	for (int i=0; i<40; i++) {
		float k;
		if ((ll.x <= ll.y) && (ll.x <= ll.z)) {
			P += p.x;
			ll.x += d.x;
			k = 0.75;
		} else {
			if (ll.y <= ll.z) {
				P += p.y;
				ll.y += d.y;
				k = 0.9;
			} else {
				P += p.z;
				ll.z += d.z;
				k = 1.0;
			}
		}

		if ((fract(float(P) / 8.0) < 0.01) && (color == 1.0)) {
			color = float(i) / 16.0;
			k2 = k;
		}
	}
  
	gl_FragColor = vec4(k2 * (1.0 - color), k2 * (1.0 - color), k2 * k2 * (1.0 - color), 1.0);

}
