// @rotwang: an antialiased disk rotating around the center
// softness and color controlled by time so that it looks
// blurred when in 'background'

// @mod+ disk is now a function, more convenient for multiple shapes

#ifdef GL_ES
precision lowp float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sint = sin(time);
float cost = cos(time);
float soft = 0.3 + 0.28* sint;
float invsoft = 1.0-soft;
float radius = 0.5;
vec3 clr_back = vec3(0.1, 0.1, 0.1);

vec3 disk(vec2 pos, vec2 shapepos, vec3 clr)
{
	
	float shape_radius = 0.3 - 0.15 *sint;

	float x = shape_radius - distance(pos, shapepos);
	
	float m = smoothstep(shape_radius*0.01, shape_radius*soft, x);
	vec3 color = mix(clr_back, clr, m);

	 return color;
}

void main()
{
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;

	vec2 pos_a = vec2(cost*radius, sint*radius);
	vec2 pos_b = vec2(cost*0.5*radius, sint*0.5*radius);
	vec2 pos_c = vec2(cost*2.5*radius, sint*0.25*radius);
	
	vec3 clr_a = vec3(0.99 + 0.13*sint, 0.66, 0.3+0.25*sint);
	vec3 clr_b = vec3(0.33 + 0.33*sint, 0.33, 0.66+0.33*sint);
	vec3 clr_c = vec3(0.33 + 0.33*sint, 0.66*sint, 0.66-0.33*sint);
	
	clr_a = disk(pos, pos_a, clr_a);
	clr_b = disk(pos, pos_b, clr_b);
	clr_c = disk(pos, pos_c, clr_c);
	
	vec3 rgb = mix(clr_a, clr_b, 0.5+0.5*cost);
	rgb = mix(rgb, clr_c, 0.5+0.5*sint);
	
	gl_FragColor = vec4(rgb, 1.0);
}