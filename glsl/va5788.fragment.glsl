precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec3 Hue(float H)
{
	H *= 6.;
	return clamp(vec3(
		abs(H - 3.) - 1.,
		2. - abs(H - 2.),
		2. - abs(H - 4.)
	), 0., 1.);
}
vec3 HSVtoRGB(vec3 c)
{
    return ((Hue(c.x) - 1.) * c.y + 1.) * c.z;
}
// milesbrot - miles@resatiate.com
// based on visualization by http://glsl.heroku.com/e#5787.0
void main( void ) {
	vec2 p = surfacePosition;
	float speed = 0.25;
	vec3 color =  vec3(mouse.x/mouse.y,mouse.y,mouse.x/mouse.y);
	vec3 m = vec3(p.x, p.y, 0.);
	vec3 loc = vec3(
		sin(time/4.0*speed)/1.9-sin(time/2.0*speed)/3.8,
		cos(time/4.0*speed)/1.9-cos(time/2.0*speed)/3.8,
		0.
	);
	float depth;
	for(int i = 0; i < 100; i+=1){
		m = vec3(m.x*m.x-m.y*m.y, 2.0*m.x*m.y, m.x)+vec3(p.x, p.y, m.y);
		depth = float(i);
		if((m.x*m.x+m.y*m.y) >= 4.0) break;
	}
	if (p.y / p.x > 1.)
	{
		m = vec3(p / m.xy, loc.y / loc.x) * (p.y / p.x) * depth;
	}
	else
	{
		m = vec3(p / m.xy, loc.x / loc.y) * (p.x / p.y) * depth;
	}
	for(int i = 0; i < 100; i+=1){
		m = vec3(m.x*m.x-m.y*m.y, 2.0*m.x*m.y, m.x)+vec3(p.x, p.y, m.z);
		depth = float(i);
		if((m.x*m.x+m.y*m.y) >= 4.0) break;
	}
	m = clamp(m*0.05, 0.0, 1.0);
	//m = HSVtoRGB(m);
	gl_FragColor = vec4(m, 1.0 );
}