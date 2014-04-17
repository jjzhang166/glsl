// @mod* rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(0,0))) * 431.5453);
}

void main()
{
	float tmin = time*0.25;
	float usint = sin(tmin)*0.5+0.5;
	vec2 pos = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos)*2.0;
	float v = atan(pos.y, pos.x);
	float t = tmin + 8.0 / u;
	
	vec3 color = vec3(abs(sin(t * 4.0 + v))) * u* 0.25;
	color += vec3(abs(sin(t - v))) * u * 0.29;
	
	color.y *= 0.6;
	color.z *= 0.2;
	color.yz *= rand(vec2(t, v)) +u*u;
	
	gl_FragColor = vec4(color, 1.0);
}