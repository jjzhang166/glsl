#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 q = gl_FragCoord.xy / resolution;
	vec2 p = -1.0 + 2.0 * q;
	p.x *= resolution.x / resolution.y;

    
	// camera
	vec3 ro = vec3(3.0);
	vec3 camLookAt = vec3(0.0);
   	vec3 ww = normalize(camLookAt - ro);
	vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
	vec3 vv = normalize(cross(ww,uu));
	vec3 rayDir = normalize( p.x * uu + p.y * vv + 1.5 * ww );
	
	

    gl_FragColor = vec4(p, 0.0, 1.0);

}