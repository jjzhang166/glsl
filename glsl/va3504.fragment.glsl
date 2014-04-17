//@ME 
//Stones
//TODO: colors, cover with moss, ...

// rotwang: @mod+ some color tests

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;

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

vec3 thing(vec2 pos) 
{
	float offset = 0.;
	float row = floor((pos.y)/1.0);
	if (mod(row, 2.0) < 1.0)
		offset = 0.5;
	
	vec2 p = pos;
	p.x += offset;
	float n1 = fbm(pos * 5.0);
	pos.x=fract(pos.x + offset +.5)-0.5;
	pos.y=fract(pos.y+.5)-0.5;
	pos = abs(pos);
	float r = length(pos );
   	float a = atan(pos.y, pos.x);
	float b = atan(pos.x, pos.y);
	float n2 = fbm(pos) * (a * b);
	float n3 = n1 * 0.15 / n2 * 0.75;
	float s = (min(pos.x,pos.y)-0.25) / length(pos) / sqrt(pos.x * pos.y) * 0.0125 - n3;
	vec3 color = vec3(mix(s, 1.-n1, 0.5));
	color = mix(color, fbm(p*0.024) * vec3(0.5487,.3,.24781), 0.35);
	color -= vec3(0.687,.743,.645781) * fbm(p * 25.) * 0.3;
	
	color = mix(color, vec3(1.0, 0.6,0.0), n2);
	float bc = b*pow(n3,0.25);
	color = mix(color, vec3(0.0, 1.0,0.25), 0.1*bc);
	return color;
}



void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 5.0;
	world.x *= resolution.x / resolution.y;
	vec3 dist = thing(world)+0.25;
	gl_FragColor = vec4( dist, 1.0 );
}