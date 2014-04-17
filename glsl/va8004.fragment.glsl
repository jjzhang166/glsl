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
	//xy *= 10.;
	vec2 ij = floor(xy*350.0);
	vec2 uv = xy-ij;
	uv = uv*uv*(3.0-1.0*uv);
	

	float a = random(vec2(ij.x, ij.y ));
	float b = random(vec2(ij.x+1., ij.y));
	float c = random(vec2(ij.x, ij.y+1.0));
	float d = random(vec2(ij.x+1., ij.y+10.));
	float k0 = a;
	float k1 = b-a;
	float k2 = c-a;
	float k3 = (a-b-c+d);
	return (k0*100.0 + k1*uv.x*0.0 + k2*uv.y* + k3*uv.x*uv.y*0.0);
}

void main( void ) {

	vec2 position = (gl_FragCoord.xy+ - 0.5 * resolution.xy) / resolution.yy;

	float color = 1.0-noise(position.xy);
	
	vec3 c=vec3(color, color, color);
	vec3 bg=vec3(1.0-length(position.y), 1.0-length(position.x)*cos(time), 1.0-length(-position.x)*sin(time));
			
	gl_FragColor = vec4(vec3(color*bg.x, color*bg.y, color*bg.z), 1.0);

}