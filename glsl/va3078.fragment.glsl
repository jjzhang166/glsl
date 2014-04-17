// @rotwang: an antialiased disk rotating around the center
// softness and color controlled by time so that it looks
// blurred when in 'background'

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;

	
	float sint = sin(time);
	float cost = cos(time);
	float soft = 0.3 + 0.28* sint;
	
	float radius = 0.5;
	vec2 shapepos = vec2(cost*radius, sint*radius);
	
	float invsoft = 1.0-soft;
	
	vec3 clr_b = vec3(0.66 - 0.33*sint, 0.66, 0.3+0.25*sint);
	vec3 clr_a = vec3(0.1, 0.1, 0.1);
	float shape_radius = 0.3 - 0.15 *sint;

	float x = shape_radius - distance(pos, shapepos);
	
	
	
	
	float m = smoothstep(shape_radius*0.01, shape_radius*soft, x);
	vec3 color = mix(clr_a, clr_b, m);


	gl_FragColor = vec4(color, 1.0);
}