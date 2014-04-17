#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Just some random particles, learning this stuff :-P

float xPos(float i)
{
	return sin(time*1.3 + i/0.9) * 100.;
}

float yPos(float i)
{
	return cos(time*1.5 + i/0.7) * 90.;
}

float c(float dist, float size)
{
	return dist < size ? 1. - dist / size : 0.0;
}
void main( void ) {

	vec2 pos = gl_FragCoord.xy;
	vec3 color = vec3(0.,0.,0.);
	vec2 center = resolution / 2.;
	
	for(float i = 0.; i < 20.; i++)
	{
		vec2 point = vec2(center.x + xPos(i), center.y + yPos(i));
		float dist = distance(pos, point);
		float pSize = 3. + (2. * cos(i)) + (sin(time + (i * 2.)) * 2.);
		color = color + vec3(c(dist, pSize), c(dist, pSize), c(dist, pSize));
	}
	
	float cDist = distance(pos, center);
	float centerSize = 200.;
	color = color + (vec3(c(cDist, centerSize) / 2.5, c(cDist, centerSize) / 1.2, c(cDist, centerSize)) / 1.5);
	
	gl_FragColor = vec4(color, 1.0);
}