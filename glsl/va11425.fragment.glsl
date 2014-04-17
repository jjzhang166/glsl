#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main (void)
{
	vec4 final_color = vec4(sin(time), mouse.x, mouse.y, 1.0); 
	gl_FragColor.r = final_color.x; 
	gl_FragColor.g = final_color.y; 
	gl_FragColor.b = final_color.z;  
	gl_FragColor.a = final_color.w;
}