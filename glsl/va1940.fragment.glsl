#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
	vec2 pos = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos);
	float v = atan(pos.y, pos.x);
	float t = time + 3.0 / u;
	
	vec3 color = vec3(abs(sin(t * 10.0 + v))) * u * .1;
	color += vec3(abs(sin(-t + v))) * u * 56.5;
	
	color.y *= 0.1;
	color.z *= 0.2;
	color *= rand(vec2(t, v)) * 0.42 + .21;
	
	gl_FragColor = vec4(color, 2.0);
}