#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main()
{
	vec2 xy = (gl_FragCoord.xy / resolution.xy);		
	float z = length(xy-vec2(0.5, 0.5));
	
	xy *= vec2(sin(491. * time),cos(607. * time));
	z *= sin(509. * time);
	
	vec4 r = vec4(xy, z, 0.0);
	
	r = normalize(r);
	
	r *= 0.2;
	
	gl_FragColor = r;
	
	//sphinx
}
