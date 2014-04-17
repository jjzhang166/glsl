// by Karolius

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const vec3 c0 = vec3(1.20,0.60,1.00);
const vec3 c1 = vec3(0.0,0.60,0.20);

float hash(float x)
{
	return fract(sin(x) * 43758.5453);
}

vec2 hash2(vec2 v)
{
	return vec2(hash(v.x), hash(v.y));	
}

// combine with tv effect of http://glsl.heroku.com/e#9472.1
vec4 tv(vec4 col, vec2 pos)
{	
	float speed = 0.0;
	
	// vibrating rgb-separated scanlines
	col.r += sin(( pos.y + 0.001 + sin(time * 64.0) * 0.00012 ) * resolution.y * 2.0 + time * speed);
	col.g += sin(( pos.y + 0.003 - sin(time * 70.0) * 0.00015 ) * resolution.y * 2.0 + time * speed);
	col.b += sin(( pos.y + 0.006 + sin(time * 90.0) * 0.00017 ) * resolution.y * 2.0 + time * speed);
	col += 1.0;
	col *= 0.5;
	
	//col = max(vec4(0.1), col);
	
	// grain
	float grain = hash( ( pos.x + hash(pos.y) ) * time ) * 0.15;
	col += grain;
		
	// flickering
	//float flicker = hash(time * 64.0) * 0.05;
	//col += flicker;
	
	// vignette
	vec2 t = 2.0 * ( pos - vec2( 0.5 ) );
	
	t *= t;
	
	float d = 1.0 - clamp( length( t ), 0.0, 1.0 );
	
	col *= d;
	
	return col;
}

float sdCapsule(vec3 p, vec3 a, vec3 b, float r)
{
    vec3 ab = b - a;
    float t = dot(p - a, ab) / dot(ab, ab);
    t = clamp(t, 0.0, 1.0);
    return length((a + t * ab) - p) - r;
}

float flare(float e, float i, float s) { return exp(1.-(e*i))*s; }

void main( void ) 
{
    vec2 unipos = (gl_FragCoord.xy / resolution);
    vec2 pos = unipos*2.0-1.0;
    pos.x *= resolution.x / resolution.y;

    vec2 t = mix(vec2(0.5),vec2(1.0),vec2(sin(time),cos(time)));

    float d0  = sdCapsule(vec3(pos.xy,0.),vec3(-.8,-.3,.0), vec3(-.8,.3,.0),.2);
    vec3 clr1 = c0 * flare(d0,6.3,.8) + flare(d0,3.3*(1.-t.x),0.08); 

    float d1  = sdCapsule(vec3(pos.xy,0.),vec3(-.8,mix(-.3,.3,t.x*.84),0.0), vec3(0.8,mix(0.20,-0.3,t.y),0.0), 0.12); 
    vec3 clr2 = mix(c0,c1,unipos.x)  * (flare(d1,7.3,.8) + flare(d1,4.3*t.x,0.09)) * .75; 

    float d2  = sdCapsule(vec3(pos.xy,0.),vec3(0.8,-0.3,0.0), vec3(0.8,0.3,0.0),.2);
    vec3 clr3 = c1 * flare(d2,6.3,0.8) + flare(d2,3.7,0.08);  

    vec4 col = vec4(clr1+clr2+clr3,5.);
    col = tv(col, unipos);
	
    gl_FragColor = col;
}