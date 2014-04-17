#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

float hash(vec2 v )
{
    return fract(sin(dot(v.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void )
{
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
		
	float h = hash(vec2(hash(gl_FragCoord.yx)-time, hash(gl_FragCoord.xy)+time));
	
	vec4 b = texture2D(backbuffer, uv);
	
	float b0, b1, b2, b3, c, c0, c1, c2, c3, c4, c5, o;
		
	vec2 p = 2./resolution.xy;
	float tau = 6.28;
	p = p * vec2(cos(tau*mouse.x),1.);
	
	const int s = 32;
	for(int i = 0; i < s; i++){
	 	b0 = tau*texture2D(backbuffer, uv + vec2(p.x, 0.)).a;
	 	b1 = tau*texture2D(backbuffer, uv + vec2(0., -p.y)).a;
	 	b2 = tau*texture2D(backbuffer, uv + vec2(-p.x, p.y)).a;
	 	b3 = tau*texture2D(backbuffer, uv + vec2( 0., 0.)).a;
	
	 	c0 = cos(b0)-cos(b1);
	 	c1 = cos(b2)-cos(b3);
		
		c2 = cos(b0)-cos(b3);
	 	c3 = cos(b2)-cos(b1);
		
		c4 = cos(c0)-cos(c5);
	 	c5 = cos(c3)-cos(c4);
					
		o = float(s);
		
	 	c += length(c4-c5);
		p += p/(o-2.*(.5-mouse.y)*o);
	}
	
	
	
	gl_FragColor = .95 * b + vec4(vec3(c), h) * .15;
}