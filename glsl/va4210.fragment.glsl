// made by darkstalker
// mods by tudd

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.14159265358979323846

mat2 calcRotationMat2(float ang)
{
	return mat2(cos(ang), -sin(ang), sin(ang), cos(ang));
}



void main(void)
{
	mat2 rotMatrix = calcRotationMat2(M_PI*time/30.);
	vec2 screen_pos = gl_FragCoord.xy;
	vec2 mouse_pos = mouse*resolution;
	
	vec2 displacement = vec2(sin(time*0.3)*200.,cos(time*0.5)*200.);
	screen_pos += displacement;
	mouse_pos += displacement;
	
	vec2 p = rotMatrix*screen_pos * 0.1;
	float value = clamp((cos(p.x) + cos(p.y)) * 1000., 0., 1.);
	float light = clamp(1. - distance(screen_pos, mouse_pos) / (clamp(sin(time*3259.8614),.7,.9)*150.), 0., 1.);
	
	float result = value*light;
	
	gl_FragColor = vec4(result,result,result*clamp(sin(time*329.8614)+1.,1.5,3.), 1.);
}