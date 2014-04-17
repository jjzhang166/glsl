#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main(void)
{
	vec2 p = gl_FragCoord.xy;
	float nx = sin(p.x * 2.0) + sin(p.x * 1.0) + sin(p.x * 0.5);
	float ny = sin(p.y * 2.0) + sin(p.y * 1.0) + sin(p.y * 0.5);
	float nz = 1.0;
	vec3 n = vec3(nx,ny,nz);
	
	float height = 100.0 * (sin(time * 3.0) + 1.0);
	vec2 dif2 = (gl_FragCoord.xy - (mouse * resolution));
	vec3 diff = vec3(dif2.x, dif2.y, height);
	float lighting = max(0.0, dot(n, normalize(diff)));
	
	float dist = distance(diff, vec3(0.0,0.0,0.0));
	
	float brightness = 1000.0 / max(0.01, dist * dist);
	brightness *= lighting;
	
	gl_FragColor.r = brightness;
	gl_FragColor.g = brightness * 4.0;
	gl_FragColor.b = brightness * 16.0;
}