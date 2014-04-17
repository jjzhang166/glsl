//precision problems?

//by mattdesl

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

uniform vec2 mouse;
uniform vec2 resolution;

// Tweaked from http://glsl.heroku.com/e#4982.0
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
    	f += 0.50000*noise( p ); p = p*2.02;
    	f += 0.25000*noise( p ); p = p*2.03;
    	f += 0.12500*noise( p ); p = p*2.01;
    	f += 0.06250*noise( p ); p = p*2.04;
    	f += 0.03125*noise( p );
    	return f/0.984375;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	float m = (sin(time)/2.0 + 0.5);
	position.x += m*0.15;
	position.y -= m*0.05;
	position.x*= resolution.x/resolution.y;
	vec2 n = vec2(position);
	
	n = vec2(n);

	float d = length(position);

	
	float a = fbm(n+(d+time*0.005)*10.0 - mouse);
		

	a = fbm(vec2(a*time*0.00075));

	
	vec3 col = vec3(a);
//	col *= 0.6;	
	col -= 0.57;
	col *= 10.0;
	col -= 0.2;
	col = clamp(col, 0.0, 1.0);
	col += smoothstep(0.059, 0.056, d);
	col += 0.2;	
	gl_FragColor = vec4( col, 1.0 );

}