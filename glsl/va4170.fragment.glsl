//MG
//Playing with water effects sourced from:
//	'Water' by Viktor Korsun (BIT_TEK) (2012)
//Which can be found at http://www.iquilezles.org/apps/shadertoy/
//under "water" in the presets list
#ifdef GL_ES
precision mediump float;
#endif
#define PI	3.1415926535897932
//speed
const float speed = 0.2;
const float speed_x = 0.3;
const float speed_y = 0.3;
// geometry
const float intensity = 3.;
const int steps = 8;
const float frequency = 4.0;
const int angle = 7; // better when a prime
// reflection and emboss
const float delta = 20.;
const float intence = 600.0;
const float emboss = 0.3;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void shader(vec2,float);
vec3 water_refract();
float col(vec2);

void main() {
	vec2 pos=(gl_FragCoord.xy/resolution.y);
	pos.x-=resolution.x/resolution.y/2.0;pos.y-=0.5;
	vec3 c1=water_refract();
	pos.xy+=c1.xy;
	
	shader(pos,c1[2]);
}

void shader(vec2 pos,float alpha) {
	pos+=time*0.1;
	gl_FragColor=vec4(mod(pos.x+pos.y,0.4)*2.5*alpha,mod(pos.x*2.0+pos.y,0.4)*2.5*alpha,mod(pos.x+pos.y*2.0,0.4)*2.5*alpha,1.0);
}

vec3 water_refract() {
	vec2 p=(gl_FragCoord.xy/resolution.y);
	p.x-=resolution.x/resolution.y/2.0;p.y-=0.5;
	vec2 c1 = p, c2 = p;
	float cc1 = col(c1);
	
	c2.x += resolution.x/delta;
	float dx = emboss*(cc1-col(c2))/delta;
	
	c2.x = p.x;
	c2.y += resolution.y/delta;
	float dy = emboss*(cc1-col(c2))/delta;
	
	c1.x = dx;
	c1.y = -dy;
	
	float alpha = 1.+dot(dx,dy)*intence;
	
	return vec3(vec2(c1),alpha);
}

float col(vec2 coord)
{
	float delta_theta = 2.0 * PI / float(angle);
	float col = 0.0;
	float theta = 0.0;
	for (int i = 0; i < steps; i++)
	{
		vec2 adjc = coord;
		theta = delta_theta*float(i);
		adjc.x += cos(theta)*time*speed + time * speed_x;
		adjc.y -= sin(theta)*time*speed - time * speed_y;
		col = col + cos( (adjc.x*cos(theta) - adjc.y*sin(theta))*frequency)*intensity;
	}
	return cos(col);
}