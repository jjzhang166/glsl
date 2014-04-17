// @rotwang: The impossible lattice (2012) variation D-13x207-n

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

float contour(float a, float m)
{
	float shade = sin(unipos.x*a);
	shade += abs(sin(unipos.x*a))*0.25* sin(time);
	shade *= shade ;
	return shade;
}


void main()
{
	

	
	float sint = sin(time);
	float cost = cos(time);
	
	float ax = 32.0;
	float ay = 32.0;
	float shade_x = contour(ax, 0.5);
	float shade_y = sin(unipos.y*ay);
	float shade_a = max(  shade_x, shade_y);
	

	vec3 color = vec3(shade_a*0.25, shade_a*0.6, shade_a);
	gl_FragColor = vec4(color, 1.0);
}