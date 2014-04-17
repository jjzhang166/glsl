//Dr.Zoidberg, i think this is a 3d sinc. i graphed it in wolframalpha first.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	vec2 p = gl_FragCoord.xy / resolution.y;
	vec3 color = vec3(0.0,0.0,0.0);
	vec2 mouse_normalize = mouse;
	mouse_normalize.y -= 0.5;
	mouse_normalize.x *= (resolution.x / resolution.y);
	mouse_normalize.x -= (resolution.x / resolution.y) / 2.0;
	p.y -= 0.5;
	p.x -= (resolution.x / resolution.y) * 0.5;
	p *= 55.0;
	mouse_normalize*=55.0;
	float intensity = 1.0;
	float grid_intensity = 0.10;
	
	//3d sinc / sombrero function i think
	float fx1 = 0.25*(15.0*cos(sqrt(p.x*p.x+p.y*p.y)-time*0.75)/sqrt(p.x*p.x+p.y*p.y)+0.5);
	float fx2 = 0.25*(10.0*cos(sqrt((p.x-mouse_normalize.x)*(p.x-mouse_normalize.x)+(p.y-mouse_normalize.y)*(p.y-mouse_normalize.y))-time*0.75)/sqrt((p.x-mouse_normalize.x)*(p.x-mouse_normalize.x)+(p.y-mouse_normalize.y)*(p.y-mouse_normalize.y))+0.5);
	color = vec3(0.2*intensity*fx1, intensity*fx1,intensity*fx1);	
	color += vec3(intensity*fx2,intensity*fx2,0.2*intensity*fx2);
	color += vec3(0.3);

	gl_FragColor = vec4(color,1.0);
}