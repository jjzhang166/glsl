// From iq's latest live coding video, "a simple eye ball"

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

mat2 m = mat2( 0.80,  0.60, -0.60,  1.00 );

float hash( float n )
{
    return fract(sin(n)*758.5453);
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
    float r = length( p );
    float a = atan( p.y, p.x );
    float dd = 0.2*sin(0.3*time);
    float ss = 0.7 + clamp(1.0-r,0.0,1.0)*dd;
  float static_r = r;
    r *= ss;
    vec3 col = vec3( 0.0, 0.3, 0.4 );
    float f = fbm( 2.0*p );
    col = mix( col, vec3(0.7,0.76,0.83), f );
    col = mix( col, vec3(0.9,0.6,0.4), 1.0-smoothstep(0.2,0.65,r*1.5) );
    a += 0.09*fbm( 10.0*p );
    f = smoothstep( 0.3, 1.0, fbm( vec2(20.0*a,9.0*r) ) );
    col = mix( col, vec3(1.0,1.0,1.0), f );
    f = smoothstep( 0.4, 0.9, fbm( vec2(23.0*a,9.0*r) ) );
    col *= 1.0-0.5*f;
    col *= 1.0-0.25*smoothstep( 0.6,0.8,r );

    
    col *= vec3(0.8+0.2*cos(r*a));
    f = 1.0-smoothstep( 0.21, 0.24, r );
    col = mix( col, vec3(0.0), f );
    f = smoothstep( 0.45, 0.85, static_r*0.95);
    col = mix( col, vec3(0.005,0.01,0.01), f );
    f = smoothstep( 0.79, 0.82, static_r );
    col = mix( col, vec3(0.99,0.93,0.90), f );
	f = 1.0-smoothstep( 0.01, 0.5, length2( mat2(0.6,0.8,-0.8,0.6)*(p-vec2(0.3,0.45) )*vec2(1.0,2.0)) );
    	col += vec3(1.0,0.9,0.9)*f*0.985;
	f = 1.0-smoothstep( 0.05, 1.5, length2( mat2(-0.5,0.0,-0.0,-0.8)*(p-vec2(0.0,-0.45) )*vec2(1.0,2.0)) );
	col += vec3(1.0,1.0,1.0)*f*0.35;
	f = 1.0-smoothstep( 0.05, 1.5, length2( mat2(-0.5,0.0,-0.0,-0.8)*(p-vec2(0.2,+0.65) )*vec2(1.0,2.0)) );
	col += vec3(1.0,1.0,1.0)*f*0.15;
	f = smoothstep( 0.3, 0.2, fbm( vec2(70.0*a,4.0*r) ) );    
	col -= vec3(0.3,0.9,0.9)*1.0*f*0.4*(1.0-smoothstep(1.8,0.6,static_r));
	f = smoothstep( 0.3, 0.2, fbm( vec2(100.0*a,3.0*r) ) );    
	col -= vec3(0.3,0.9,0.9)*0.6*f*(1.0-smoothstep(1.8,0.6,static_r));
	f = smoothstep( 0.3, 0.2, fbm( vec2(20.0*a,7.5*r) ) );    
	col -= vec3(0.3,0.9,0.9)*0.5*f*(1.0-smoothstep(1.8,0.6,static_r));
	f = smoothstep( 0.30, 1.6, static_r );
    	col = mix( col, vec3(0.04,0.0,0.0), f );
	f = smoothstep( 1.5, 1.55, static_r );
    	col = mix( col, vec3(0.0,0.0,0.0), f );
	
	//col -= 10.0*vec3(1.0)*float((sin(0.85*p.x+1.55)+p.y-0.25)<0.0);
	//col -= 10.0*vec3(1.0)*float((-sin(0.95*p.x+1.55)+p.y+0.26)>0.0);
    gl_FragColor = vec4(col,1.0);
}