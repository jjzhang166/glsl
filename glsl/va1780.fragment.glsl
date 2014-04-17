#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 core(vec2 pos)
{
	if(length(pos) > 0.4) return vec3(0.0);
	
	return vec3(1.0, 0.6, 0.0);
}

vec3 glow(vec2 pos)
{
	if(length(pos) > 0.6) return vec3(0.0);
	
	float grad = (0.6 - length(pos)) / 0.6;
	return vec3(grad, grad * 0.6, 0.0) * (sin(time) * 0.2 + 0.8) * 1.2;
}

vec3 rays(vec2 pos)
{
	if(sin(atan(pos.y, pos.x) * 10.0 + sin(time)) > 0.0 && length(pos) < 0.9)
	{
		float grad = (0.9 - length(pos)) / 0.9;
		return vec3(grad, grad * 0.6, 0.0) * (sin(time) * 0.2 + 0.8) * 0.1;
	}
	return vec3(0.0);
}

void main()
{
	vec2 uv = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
	uv.x *= (resolution.x / resolution.y);
	
	vec3 color = vec3(0.0, 0.0, 0.0);
	
	color += core(uv);
	color += glow(uv);
	color += rays(uv);
	color += rand(uv) * 0.08;
	
	gl_FragColor = vec4(color, 1.0);
}