// pretty
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float flower(vec2 p, vec2 c, float r, float n, float a)
{
	p -= c;
	float t = atan(p.y, p.x); // + time;
	float d = length(p);
	d += sin(t*n)*a;
	//return smoothstep(r, r-0.01, d);
	return d;
}

float dots(vec2 p, vec2 c, float r, float n, float r2)
{
	p -= c;
	float t = (atan(p.y, p.x) + PI) / TWOPI;
	t = floor(t * n) / n; // integer part
	t += 0.5 / n;
	t = (t*TWOPI)-PI;
	vec2 dc = vec2(cos(t), sin(t))*r;
	float d = length(p - dc);
	
	return smoothstep(r2, r2-0.01, d);
	//return t;
	//return d;
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy)*2.0-1.;
	p.x *= resolution.x / resolution.y;
	
	p = (fract(p*3.0) - vec2(0.5, 0.5))*vec2(1.5);
	
	vec3 c;
	float f = flower(p, vec2(0, 0), 0.5, 8.0, 0.1);
	c = mix(c, vec3(1.0, 0.0, 0.1), smoothstep(0.5, 0.49, f));
	c = mix(c, vec3(0.0, 1.0, 1.0), smoothstep(0.4, 0.39, f));
	c = mix(c, vec3(1.0, 1.0, 0.0), smoothstep(0.2, 0.19, f));
	
	float d = dots(p, vec2(0.0, 0.0), 0.5, 8.0, 0.05);
	c = mix(c, vec3(1.0, 1.0, 1.0), d);

	d = dots(p, vec2(0.0, 0.0), 0.4, 16.0, 0.02);
	c = mix(c, vec3(1.0, 0.0, 0.0), d);
		
	//gl_FragColor = vec4( vec3(d), 1);
	gl_FragColor = vec4( c, 1);
}