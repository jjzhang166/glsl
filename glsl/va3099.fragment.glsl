// @rotwang:
// The impossible lattice (2012)
// variation D-13x208-n a bit perspective

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	//pos.x *=aspect;

float contour(float a)
{
	a*=48.0 - 16.0*a;
	float shade = (cos(a+1.57) * sign(sin(a+1.57))+1.0);
	return shade;
}




void main()
{
	

	
	float sint = sin(time);
	float cost = cos(time);
	
	float ax = 32.0;
	float ay = 32.0;
	float shade_x = contour(unipos.x);
	float shade_y = sin(unipos.y*ay);
	shade_y *= unipos.x;
	float shade_a = max(  shade_x, shade_y);
	

	vec3 color = vec3(shade_a*0.25, shade_a*0.6, shade_a);
	gl_FragColor = vec4(color, 1.0);
}