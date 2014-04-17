// From iq's latest live coding video, "a simple eye ball"
// Eyeball "soup" added by JvB. Would add more but GF is pissed at me.

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

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.05*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.225*noise( p );
    return f/0.984375;
}

float length2( vec2 p )
{
    float ax = abs(p.x);
    float ay = abs(p.y);
    return pow( pow(ax,4.0) + pow(ay,4.0), 1.0/4.0 );
}

vec3 tex(vec2 p)
{
    float r = length( p );
    float a = atan( p.y, p.x );
    float dd = 0.2*sin(0.7*time);
    float ss = 1.0 + clamp(1.0-r,0.0,1.0)*dd;
    r *= ss;
    vec3 col = vec3( 0.0, 0.3, 0.4 );
    float f = fbm( 5.0*p );
    col = mix( col, vec3(0.2,0.5,0.4), f );
    col = mix( col, vec3(0.9,0.6,0.2), 1.0-smoothstep(0.2,0.6,r) );
    a += 0.05*fbm( 20.0*p );
    f = smoothstep( 0.3, 1.0, fbm( vec2(20.0*a,6.0*r) ) );
    col = mix( col, vec3(1.0,1.0,1.0), f );
    f = smoothstep( 0.4, 0.9, fbm( vec2(15.0*a,10.0*r) ) );
    col *= 1.0-0.5*f;
    col *= 1.0-0.25*smoothstep( 0.6,0.8,r );
    f = 1.0-smoothstep( 0.0, 0.6, length2( mat2(0.6,0.8,-0.8,0.6)*(p-vec2(0.3,0.5) )*vec2(1.0,2.0)) );
    col += vec3(1.0,0.9,0.9)*f*0.985;
    col *= vec3(0.8+0.2*cos(r*a));
    f = 1.0-smoothstep( 0.2, 0.25, r );
    col = mix( col, vec3(0.0), f );
    f = smoothstep( 0.79, 0.82, r );
    col = mix( col, vec3(1.0,1.0,1.0), f );
    return col;
}
float scene(in vec3 p)
{
	p.x = mod(p.x+1.0, 2.0) - 1.0;
	p.y = mod(p.y+1.0, 2.0) - 1.0; 
	return length(p) - 1.0; 
}
vec3 get_normal(in vec3 p)
{
	vec3 eps = vec3(0.001, 0, 0); 
	float nx = scene(p + eps.xyy) - scene(p - eps.xyy); 
	float ny = scene(p + eps.yxy) - scene(p - eps.yxy); 
	float nz = scene(p + eps.yyx) - scene(p - eps.yyx); 
	return normalize(vec3(nx,ny,nz)); 
}

vec3 rotatey(in vec3 p, float ang)
{
	return vec3(p.x*cos(ang)-p.z*sin(ang), p.y, p.x*sin(ang)+p.z*cos(ang)); 
}
vec3 rotatex(in vec3 p, float ang)
{
	return vec3(p.x, p.y*cos(ang)-p.z*sin(ang), p.y*sin(ang)+p.z*cos(ang)); 
}
vec3 rotatez(in vec3 p, float ang)
{
	return vec3(p.x*cos(ang)-p.y*sin(ang),p.x*sin(ang)+p.y*cos(ang),p.z); 
}
void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
	
    vec3 col = vec3(0.1);
    
	vec3 ro = vec3(0,0,4.0);
	vec3 rd = normalize(vec3(p.x,p.y,-1.0));
	
	rd = rotatex(rd,0.75); 
	vec3 pos = ro; 
	float dist = 0.0; 
	float d; 
	for (int i = 0; i < 64; i++) {
		d = scene(pos);
		pos += rd*d;
		dist += d;
	}
	if (dist < 10.0 && abs(d) < 0.1) {
		float ox = float(int(pos.x*0.5+0.5)); 
		float oy = float(int(pos.y*0.5+0.5)); 
		pos.x = mod(pos.x+1.0, 2.0) - 1.0;
		pos.y = mod(pos.y+1.0, 2.0) - 1.0;
		
		vec3 n = get_normal(pos);
		vec3 l = normalize(vec3(1,1,1)); 
		float diff = clamp(dot(n, l), 0.0, 1.0);
		pos = rotatey(pos, ox*1.0+time*0.3); 
		pos = rotatex(pos, oy*2.0+time*0.4); 
		pos = rotatez(pos, ox*3.0+time*0.2); 
		col = diff*tex(pos.xy*2.0); 
	}
    gl_FragColor = vec4(col,1.0);
}