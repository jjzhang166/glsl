#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 p = vec3(position, 0.1);
    	float c = cos(2.0*p.y);
    	float s = sin(29.0*p.y);
    	mat2  m = mat2(c,-s,s,c);
    	vec3  q = vec3(m*p.xy,p.z);
    	float pp = sdTorus(q, mouse);
	
	
	gl_FragColor = vec4( vec3( pp ), 1.0 );

}