/* @title 	Cloud Demo 
   @version 	v0.1
   @author 	Mark Sleith
   @website 	www.cngames.co.uk/portfolio
   @date 	13/08/2012
*/


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    	return res;
}

float fbm( vec2 p )
{
    	float f = 0.0;
    	f += 0.50000*noise( p ); p = m*p*2.02;
    	f += 0.25000*noise( p ); p = m*p*2.03;
    	f += 0.12500*noise( p ); p = m*p*2.01;
    	f += 0.06250*noise( p ); p = m*p*2.04;
    	f += 0.03125*noise( p );
    	return f/0.984375;
}

void main( void ) {
	// Set up domain
	vec2 q = ( gl_FragCoord.xy / resolution.xy );
	vec2 p = -1.0 + 2.0 * q;
	
	// Fix aspect ratio
	p.x *= resolution.x / resolution.y;
        p.x += sin(time) ;   
        p.y += cos(time) ;   
	float f = fbm( 10. * (2. + sin(time)) * p ); // now crudely coloured and animated, just testing... @danbri
	
	
	

	gl_FragColor = vec4( cos(p.x) * f, f*  sin(p.x), f * sin(p.y), f);

}
