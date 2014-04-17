#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random(vec2 ab) 
{
	float f = (cos(dot(ab ,vec2(21.9898,78.233))) * 43758.5453);
	return fract(f);
}

float noise(in vec2 xy) 
{
	vec2 ij = floor(xy);
	vec2 uv = xy-ij;
	uv = uv*uv*(3.0-2.0*uv);
	

	float a = random(vec2(ij.x, ij.y ));
	float b = random(vec2(ij.x+1., ij.y));
	float c = random(vec2(ij.x, ij.y+1.));
	float d = random(vec2(ij.x+1., ij.y+1.));
	float k0 = a;
	float k1 = b-a;
	float k2 = c-a;
	float k3 = a-b-c+d;
	return (k0 + k1*uv.x + k2*uv.y + k3*uv.x*uv.y);
}

void main( void ) {
	float star = pow(noise(gl_FragCoord.xy), 40.0) * 20.0;
	float r1 = noise(gl_FragCoord.xy*noise(vec2(sin(time*0.01))));
	
	float radius = length(gl_FragCoord.xy - resolution.xy/2.0);
	vec3 color = vec3(10.0/radius,30.0/radius*tan(0.2),30.0/radius*sin(-time*0.5));
	gl_FragColor = vec4(star*r1,star*r1,star*r1,1.0)+vec4(color*10.0, 1.0);
}