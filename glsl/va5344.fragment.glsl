#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
float time1 = time*0.0;
float time2 = time*0.0;
uniform vec2 mouse;
uniform vec2 resolution;

#define MUL_X 8.0
#define MUL_Y 10.0
#define PI 3.14159265359
#define TWO_PI PI * 2.0

vec3 getNormal(vec2 position)
{
	return vec3(cos ( MUL_X * PI * position.x + time1 ), sin (MUL_X * PI * position.y + time1 ), cos(MUL_Y * PI*position.x + time) * sin (MUL_X * PI*position.y + time ));
}

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 normal = getNormal(position);
	
	vec3 lightVec = normalize(vec3(1.0, 1.0, 1.0));
	
	float nDotl = dot(normal, lightVec);
	
	gl_FragColor = vec4( vec3(nDotl, nDotl, nDotl), 1.0);
}