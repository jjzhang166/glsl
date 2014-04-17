#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

float ratio = resolution.x / resolution.y;

vec3 bg_col = vec3(0.);
vec3 circle_col = vec3(0., 1., 0.);

#define PI 3.1416

void main(void)
{
	vec2 p = (-1. + 2. * ((gl_FragCoord.xy) / resolution.xy));
	p -= (2. * mouse.xy) - vec2(1.);
	p.x *= ratio;
	float len = dot(p,p);
	float theta = atan(p.y, p.x);
	
	vec3 color = vec3(0.);//vec3(0.0, 1.0, 0.0);
	
	if((len < 0.5 && len > 0.35) 
	   && (theta > 0.6 || theta < 0.5)
	   && (theta > 0.4 || theta < 0.3)
	   && (theta > 0.2 || theta < 0.1)
	  )
		color = vec3(0.0, 1.0, 0.0);
	
	
	gl_FragColor = vec4(color, 1.0);
}