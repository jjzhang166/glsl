// by rotwang: some tests with smooth shapes and clipping for Krysler

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float speed = time *0.5;
float aspect = resolution.x / resolution.y;
vec2 unipos = ( gl_FragCoord.xy / resolution );
vec2 pos = vec2( (unipos.x*2.0-1.0)*aspect, unipos.y*2.0-1.0);


float Krysler_111(vec2 p)
{
	p*=4.0;
	float k =16.0;
	float x =  smoothstep(0.5,1.0, pow(sin(p.x*PI),1.0/k));
	float y =  smoothstep(0.5,1.0, pow(sin(p.y*PI),1.0/k));

	return x*y;
}

void main( void ) {

	float a = Krysler_111(pos)*0.5;
	float b = Krysler_111(pos + 0.01);
	
	vec3 clr_a = vec3(0.2, 0.66,0.9) * a;
	vec3 clr_b = vec3(1.0) * (1.0-b) +a;
	vec3 clr = mix(clr_a, clr_b, 0.5);
	gl_FragColor = vec4( clr, 1.0); 
				
}