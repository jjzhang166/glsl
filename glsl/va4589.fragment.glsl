#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 ColorMap(float f, float m) {
	f = mod(f, m);
	float i = f/m;
	float r = min(clamp(6.0*i, 0.0, 1.0),clamp(6.0-6.0*i, 0.0, 1.0));
	float g = min(clamp(6.0*i-1.0, 0.0, 1.0),clamp(5.0-6.0*i, 0.0, 1.0));
	float b = min(clamp(6.0*i-2.0, 0.0, 1.0),clamp(4.0-6.0*i, 0.0, 1.0));
	return vec3(r, g, b);
}


void main(void) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis

	pos.x -= 0.5;
	pos.y -= 0.5;
	pos.x *= 2.0;
	pos.y *= 2.0;

	pos.x *= (resolution.x / resolution.y);

	float p = 100.0;
	float b = 0.0000000001;
	float t = mod(time, p)/p;
	if (t>0.5) {
		pos *= pow(0.5, (1.0-t)*30.0)+b;
	}
	else {
		pos *= pow(0.5, t*30.0)+b;
	}

	vec2 center = vec2(-0.61100,-0.624069);//vec2(-0.61100,-0.624069);//vec2(-0.615548,-0.6253);//vec2(-0.734,-0.25);//vec2(-1.18219,-0.30957);

	pos += center;

	vec2 x = pos;
	float l;
	bool conv = true;
	float esum = 0.0;
	int breakloop = 0;
	float bound = pow(10.0, 5.0);
	for(int i = 1; i < 100; i++) {
		x = vec2((x.x*x.x) - (x.y*x.y), (x.x*x.y) + (x.y*x.x)) + pos;
		l = (x.x*x.x) + (x.y*x.y);
		if (l>bound) {
			conv = false;
			break;
		}
		breakloop += 1;
		esum += exp(-l);
	}
	vec3 c;
	if (conv) {
		c = vec3(0.0, 0.0, 0.0);
	}
	else {
		c = ColorMap(esum, 20.0);
		//c = ColorMap(float(breakloop), 50.0);
	}
	gl_FragColor=vec4(c,0.0);
}
