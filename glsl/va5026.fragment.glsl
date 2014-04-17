#ifdef GL_ES
precision mediump float;
#endif

// TRBL was here
// http://trbl.at
// http://wzl.vg
// hi@wzl.vg

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rnd = .001840;

void main( void ) {

	vec2 fc = gl_FragCoord.xy;
	vec2 q = ( gl_FragCoord.xy / resolution.xy );
	vec2 p = -1.0 + 2.0 * q;
	p.x *= resolution.x / resolution.y;
		
	float t = mod(time * 0.3, 3.14);
	//t = 1.0;
	float z = pow(sin(t),7.0);
	vec2 sun = p;
	sun.x += ((t) - 1.57) * 1.57;
	sun.y -= (sin(t)*0.5 - 0.5) ;

	
	float r = sqrt(dot(sun,sun));
	float a = atan(sun.y, sun.x);
	
	vec3 col = vec3(0.6, 0.8, 0.9) * 1.0 - z;
	
	if(r < 1.3)
	{
		float f = 0.0;
		f = 1.0 - smoothstep(0.7, 1.0, r * 0.8);
		f *= 0.2;
		col = mix(col, vec3(1.0-f), (1.3- r ));
		f += 1.0 - smoothstep(0.95, 1.0, r * 1.0);
		col = mix(col, vec3(f), (1.3 - r ));
	}
	r = sqrt(dot(p,p));
	a = atan(p.y, p.x);
	
	if(r < 1.0)
	{
		vec3 b = vec3(0.6, 0.8, 0.9);
		float f = smoothstep(0.95, 1.0, r);
		//col = mix(col, vec3(f*0.2), 1.0-f);
		col = mix(col, b * (1.0 - z), 1.0 - f);
	}
	
	
	
		
	gl_FragColor = vec4( col, 1.0 );

}