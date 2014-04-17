#ifdef GL_ES
precision highp float;
#endif

//modification by nnorm

uniform float time;
uniform vec2 resolution;


vec3 image(vec2 p)
{
	float c = 1. - length(mod(abs(p), 0.7));
	return vec3(1. - c, c, c * 23.);
}

vec2 distort(vec2 p)
{
	float d = length(p) + sin(time * 0.05);
	float a = atan(p.y,p.x);

	vec2 uv;

	uv.x = sqrt(cos(pow(a,2.) + time)) / d;
	uv.y = sqrt(sin(pow(a,2.) + time)) / d;

	return p + uv + vec2(time * 0.5);
}

vec3 effect()
{
	vec3 color;
 	vec3 uv;
	vec2 pos = gl_FragCoord.xy / resolution - 0.5;

	color = image(distort(pos));

	return color;
}


void main()
{
	gl_FragColor = vec4(effect(), 1.);
}