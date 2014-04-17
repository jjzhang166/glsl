#ifdef GL_ES
precision mediump float;
#endif

//for gamedev by MrOMGWTF

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
	float t = time * 0.2;
    	f += 0.50000*noise( p -t*2.0); p = m*p*2.02;
    	f += 0.25000*noise( p +t*2.0); p = m*p*2.03;
    	f += 0.12500*noise( p +t*2.0); p = m*p*2.01;
    	f += 0.06250*noise( p -t*2.0); p = m*p*2.04;
    	f += 0.03125*noise( p +t*2.0);
    	return f/0.984375;
}
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float color = 1.0;
	float n = fbm(position * 10.0 + vec2(0.0, 0.0));
	n = n < (0.35) ? 0.0 : 1.0;
	color *= n;
	float b = fbm(position * 10.0 + vec2(0.0, 0.0));
	float c = fbm(position * 10.0 + vec2(1.0, 0.0));

	vec3 pixel = vec3(color);
	pixel.r = b;
	pixel.g = c * sin(n + position.x) * cos(position.y);
	pixel.b = position.x;

	gl_FragColor = vec4(pixel, 1.0 );

}