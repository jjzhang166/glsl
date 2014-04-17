// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define pi 3.1415927410125
	
float rand(vec2 co){
	return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
	vec2 pos = gl_FragCoord.xy / resolution - vec2(0.5);
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos);
	float v = atan(pos.y, pos.x);
	float t = time / 0.8 + abs(sin(cos(time))+1.0*2.9) / u;
	
	float intensity = abs(sin(t * 4.0 + v)+sin(v*1.0)) * 0.325 * u * 0.325;
	
	float one = -sin(v*4.0+v*2.0+time);
	float two = sin(u*8.0+v-time);
	float three = cos(u+v*3.0+time);
	
	float t1 = abs(sin(time + (2.0 * pi / 3.0 * 0.0) ));
	float t2 = abs(sin(time + (2.0 * pi / 3.0 * 1.0) ));
	float t3 = abs(sin(time + (2.0 * pi / 3.0 * 2.0) ));
	float use = t1 * one + t2 * two + t3 * three;
	
	float d = abs(sin(cos(time*35.0))*4.0) + 5.0;
	vec3 col2 = vec3(use, use, use) * d;
	col2 /= abs(sin(time)+2.0)*1.0;
	col2 /= 5.0;

	col2 += rand(pos+time)*((sin(time*57.0)*0.35)+0.15);

	gl_FragColor = vec4(col2 * intensity * (u * 5.0), 1.0);
}