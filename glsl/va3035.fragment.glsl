// From iq's latest live coding video, "a simple eye ball"

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
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

float waternoise( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.85;
}

float cloudnoise( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.975;
}

float length2( vec2 p )
{
    float ax = abs(p.x);
    float ay = abs(p.y);
    return pow( pow(ax,4.0) + pow(ay,4.0), 1.0/4.0 );
}

void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
    
    float horiz = 1.0 - smoothstep(0.0, 0.01, p.y);
    float cloudHoriz = pow(smoothstep(0.0,1.0,p.y), 0.5);
    //float water = 1.0 - waternoise(vec2(p.x  * 3.0 + time * 0.2, time + p.y  * (100.0 + ((p.y + 1.0) * 90.0)))) * 0.5 ;
    float water = 1.0 - waternoise(vec2(p.x  * (1.0 + (1.0 + p.y) * 8.0) + time * 0.2, time + p.y  * (100.0 + ((p.y + 1.0) * 90.0)))) * 0.5 ;
    vec3 waterColor = vec3(0.0, 0.0, 0.6);
    vec3 skyColor = vec3(0.6,0.6,1.0);
    float highlight = smoothstep(0.82, 1.0, water) + smoothstep(0.0, 1.0, water) ;
	highlight *= 0.5;
    vec3 cloudColor = vec3(1.0, 1.0, 1.0);
	gl_FragColor = vec4(mix(waterColor * water + vec3(1.0,1.0,1.0) * highlight, skyColor, 1.0 - horiz) + cloudColor * cloudnoise(vec2(p.x,p.y + time * 0.01)* (cloudHoriz *1.0)) * cloudHoriz * 0.5,1.0);
}