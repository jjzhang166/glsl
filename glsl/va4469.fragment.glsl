//Dr.Zoidberg, i think this is a 3d sinc. i graphed it in wolframalpha first.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float intensity = 1.9;
vec3 color = vec3(.3);

float val(vec2 p, vec2 offset) {
   vec2 o = p - offset;
   return sqrt(o.x*o.x + o.y*o.y)*10.0;
}

void main( void ) {
	float rel_factor = resolution.x / resolution.y;
	
	vec2 p = gl_FragCoord.xy / resolution.y;
	p.y -= 0.5;
	p.x -= rel_factor * 0.5;
	p *= 55.0;
	
	vec2 m_n = vec2(rel_factor * (mouse.x - .5), mouse.y - .5);
	m_n *= 55.0;
	
	
	
	float p_rt = val(p, vec2(-5.0, 0.0));
	float fx1 = 30.0*cos(p_rt - time*5.0)/p_rt + .5;
	
	p_rt = val(p, vec2(5.0, 0.0));
	float fx2 = 30.0*cos(p_rt - time*5.0)/p_rt + .5;
	
	
	p_rt = val(p, vec2(0, 8.66));
	float fx3 = 30.0*cos(p_rt - time*5.0)/p_rt + .5;
	
	p_rt = val(p, vec2(0.0, 3.0));
	float fx4 = 30.0*cos(p_rt - time*5.0)/p_rt + .5;
	
	color *= intensity*fx1 * vec3(1.0, 1.0, 0.0);
	color *= intensity*fx2 * vec3(1.0, 1.0, 0.0);
	color *= intensity*fx3 * vec3(1.0, 1.0, 0.0);
	color *= intensity*fx4 * vec3(1.0, 1.0, 0.0);
	

	gl_FragColor = vec4(color, 1.0);
}