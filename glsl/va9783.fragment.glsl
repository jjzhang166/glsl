#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Gradient Noise (http://en.wikipedia.org/wiki/Gradient_noise)
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// Noise implementation from https://www.shadertoy.com/view/XdXGW8
vec2 hash( vec2 p )
{
	p = vec2( dot(p,vec2(127.1,311.7)),
			  dot(p,vec2(269.5,183.3)) );

	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( hash( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
                     dot( hash( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( hash( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
                     dot( hash( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}


// simple demonstration of dividing the screen into stripes
const float STRIPE_COUNT = 10.0;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float stripeNumber = floor(position.x * STRIPE_COUNT);
	float stripePosition = fract(position.x * STRIPE_COUNT);

	float color = (noise(vec2(position.y * 20.0, stripeNumber)) + 1.0) / 2.0;	
	//float color = (noise(vec2(position.y * 20.0 + time * fract(stripeNumber * 1.3), stripeNumber)) + 1.0) / 2.0;
	if (stripePosition < 0.1)
		color += 0.2;
	

	gl_FragColor = vec4(vec3(color), 1.0);

}