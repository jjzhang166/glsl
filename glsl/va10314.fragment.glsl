#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Camera 
{
	vec3 position;
	vec3 lookAt;
	vec3 rayDir;
	vec3 forward, up, left;
};
	
float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

void main( void ) {

	vec2 vPos = 2.0*gl_FragCoord.xy/resolution.xy-1.0;
	float ratio = resolution.x/resolution.y;
	vec3 bcol = vec3(0.1);
	
	

}