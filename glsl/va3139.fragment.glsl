#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x+sqrt(time/1.)*4.);
    vec2 f = fract(x+sqrt(time/1.)*4.);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.90000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
    
    float r = 1.0;
	
    vec3 col = vec3( 0.4, 0.8, 1.0 );
    
    float f = fbm( 5.0*p);	
    col = mix ( col, vec3(0.2,0.8,0.8), f);
	
    float a = fbm( 10.0*p);

    f = smoothstep( 0.0, 1.0, fbm( vec2(3.0*r, 10.0*a) ) );
    col = mix( col, vec3(0.0), f);
	
	 a = fbm(2.0*p);

    f = smoothstep( 0.0, 3.0, fbm( vec2(3.0*r, 10.0*a) ) );
    col = mix( col, vec3(0.5), f);
    gl_FragColor = vec4(col,1.0);
}