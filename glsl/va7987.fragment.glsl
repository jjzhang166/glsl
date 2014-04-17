#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random(vec2 ab) 
{
	float f = (cos(dot(ab ,vec2(212.28,78.233))) * 43758.5453);
	return fract(f);
}

float noise(in vec2 xy) 
{
	vec2 ij = floor(xy);
	vec2 uv = xy-ij;
	uv = uv*uv*(10.0-200.0*uv);
	

	float a = random(vec2(ij.x, ij.y ));
	float b = random(vec2(ij.x+1., ij.y));
	float c = random(vec2(ij.x, ij.y+1.));
	float d = random(vec2(ij.x+1., ij.y));
	float k0 = a;
	float k1 = b-a;
	float k2 = c-a;
	float k3 = a-b-c-d;
	return (k0 + k1*uv.x + k2*uv.y + k2*uv.y*uv.y);
}

void main( void ) {

	vec2 position = (gl_FragCoord.yy+ - 2.0 * resolution.xy) / resolution.yy;

	float color = pow(noise(gl_FragCoord.xy), 10.1) * 100.0;

	float r1 = noise(gl_FragCoord.xy*noise(vec2(tan(time*0.01))));
	float r2 = noise(gl_FragCoord.xy*noise(vec2(tan(time*0.001), tan(time*0.01))));
	float r3 = noise(gl_FragCoord.xy*noise(vec2(tan(time*0.00005), sin(time*0.05))));
		
	gl_FragColor = vec4(vec3(color*r2, color*r1*r2*r3, color*r3), 1.0);

}