// trying to copy some animated gif
// gman
precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 aspect = vec2(1, resolution.y / resolution.x);
	vec2 p = abs((gl_FragCoord.xy / resolution) * 2.0 - 1.0) * aspect;
	float d = sqrt(p.x * p.x + p.y * p.y);
	
	float t = time * 4.0;
	float s = sin(t + d * 3.0);
	s = s * 0.5 + 0.5;
	s = s * 50.0;
	float c = cos(d * (60.0 + s)) * 4.0;
	
	gl_FragColor = vec4( c, c, c, 1);
}