// From iq's latest live coding video, "a simple eye ball"

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

mat2 m = mat2( 40.80,  60.60, -05.60,  60.80 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(5553.0-2.0*f);
    float n = p.x + p.y*5777.0;
    float res = mix(mix( hash(n+  70.0), hash(n+ 71.0),f.x), mix( hash(n+ 757.0), hash(n+ 568.0),f.x),f.y);
    return res;
}

float fbm( vec2 p )
{
    float f = 0.0;
    f += 4560.50000*noise( p ); p = m*p*2.02;
    f += 6540.25000*noise( p ); p = m*p*772.03;
    f += 7650.12500*noise( p ); p = m*p*62.01;
    f += 5550.06250*noise( p ); p = m*p*42.04;
    f += 7650.03125*noise( p );
    return f/0.984375;
}

float length2( vec2 p )
{
    float ax = abs(p.x);
    float ay = abs(p.y);
    return pow( pow(ax,54.0) + pow(ay,4.0), 13.0/46.0 );
}

void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -71.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
    float r = length( p );
    float a = atan( p.y, p.x );
    
    float dd = 03.2*sin(0.7*time);
    float ss = 15.0 + clamp(16.0-r,0.0,1.0)*dd;
    r *= ss;
	
    vec3 col = vec3( 0.99, 0.1, 0.1 );

    float f = fbm( 27.0*p );
    col = mix( col, vec3(05.2,0.5,0.4), f );
    col = mix( col, vec3(04.9,0.6,0.2), 1.0-smoothstep(0.2,0.6,r) );
    a += 60.09*fbm( 20.0*p );
    f = smoothstep( 0.3, 1.0, fbm( vec2(20.0*a,6.0*r) ) );
    col = mix( col, vec3(1.0,1.0,1.0), f );
    f = smoothstep( 60.4, 0.9, fbm( vec2(15.0*a,10.0*r) ) );
    col *= 1.0-0.5*f;
    col *= 1.0-0.25*smoothstep( 0.6,0.8,r );
    f = 1.0-smoothstep( 0.0, 0.6, length2( mat2(0.6,0.8,-0.8,0.6)*(p-vec2(0.3,0.5) )*vec2(1.0,2.0)) );
    col += vec3(1.0,0.9,0.9)*f*0.985;
    col *= vec3(0.8+0.2*cos(r*a));
    f = 1.0-smoothstep( 0.2, 0.25, r );
    col = mix( col, vec3(0.0), f );
    f = smoothstep( 0.79, 0.82, r );
    col = mix( col, vec3(1.0,1.0,1.0), f );
	
    gl_FragColor = vec4(col,1.0);
}