//@ME 
//Stones
//TODO: colors, cover with moss, ...

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

float thing(vec2 pos) 
{
	vec2 p = pos;
	vec2 offset = vec2(0.0, 1.0);
	float rowX = floor((pos.y)/1.0);
	if (mod(rowX, 2.0) < 1.0)
		offset.x = 0.5 + fbm(p*0.3);
	
	float rowY = floor((pos.y)/1.0);
	if (mod(rowY, 2.0) < 1.0) {
		offset.y = 2.0;
		offset.x = 0.75 * fbm(p*0.5);
		rowX = floor((pos.y)/0.5);
		if (mod(rowX, 2.0) < 1.0)
			offset.x += 0.25 + fbm(p*0.3);
	}
	
	p.x += offset.x;
	float n1 = fbm(pos * 5.0);
	pos.x=fract(pos.x + offset.x * fbm(p*0.9) +.5)-0.5;
	pos.y=fract(pos.y * offset.y +.5)-0.5;
	pos = abs(pos);
   	float a = atan(pos.y, pos.x);
	float b = atan(pos.x, pos.y);
	float n2 = fbm(pos) * (a*b);
	float n3 = n1 * 0.15 / n2 * .75;
	float s = min(pos.x,pos.y) - n3;
	return mix(s, 1.-n1, 0.5);
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 5.0;
	world.x *= resolution.x / resolution.y;
	world.x += time;
	float dist = thing(world)+0.5;
	
	vec2 pos = -1.0 + 2.0*gl_FragCoord.xy / resolution.xy;
	float energy = 0.01;
	   
	for (float i=0.0; i<16.0; i+=1.0) {
		vec2 starPos = vec2( 0.5*sin(i + time), 0.5*cos(i*i + time) );
		energy += pow( cos( distance ( pos, starPos ) ), 128.0 );
	}
	   
	//dist *= energy;
	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}