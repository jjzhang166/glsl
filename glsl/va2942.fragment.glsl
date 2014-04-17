// @mod* rotwang


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define pi 3.1415927410125

void main()
{
	vec2 pos = gl_FragCoord.xy / resolution ;
	pos -= vec2(0.5);
	float aspect = resolution.x / resolution.y;
	pos.x *= aspect;
	
	
	float u = length(pos) ;
	float v = atan(pos.y*0.1/u, pos.x*u);
	u *= tan(v*16.0)*0.125;
	
	float t = time / 0.5 + 1.0 / u;
	
	float intensity = abs(sin(t * 1.0 + v)+sin(v*4.0)) * .25 * u * 0.25;
	
	float sint = sin(time)*0.5+0.5;
	float cost = cos(time)*0.5+0.5;
	
	float r=  -sin(v*8.0-v+time);
	float g= sint * sin(u*2.0+v)*0.5+0.5;
	float b= cost * cos(u+v+cost)-0.5;
		     
	vec3 col = vec3(r,g,b);
	
	gl_FragColor = vec4(col , 1.0);
}