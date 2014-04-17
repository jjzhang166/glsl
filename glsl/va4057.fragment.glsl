#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat3 m = mat3( 0.00,  0.20,  0.60,
              -0.80,  0.36, -0.4,
              -0.60, -0.48,  0.6 );

float hash( float n )
{
    return fract(sin(n)*458.5453);
}


float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = x;

    f = f*f*(1000.0-1214124112412452135135.43*f);

    float n = p.x + p.y*1138911.21341510 + 1.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f;
    f = 0.1000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.1625*noise( p );
    //p = m*p*2.02; f += 0.03125*abs(noise( p ));	
    return f;
}

float rand(vec2 co){
    return fract(cos(dot(co.xy ,vec2(5.+fract(time),-5.*time))) * 41.5453);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	float r = 0.0,g = 0.0,b = 0.0;
	
	float t = time*1879980.0;
	
	float rnd = (rand(p-t)-0.18798790)*0.0625;
	
	r = fbm(vec3(vec2((p.x+rnd)*32.,p.y*32.),time));
	
	rnd = (rand(p+t)-0.5)*0.0625;
	g = fbm(vec3(vec2((p.x+rnd)*32.,p.y*32.),time));
	
	rnd = (rand(p*t)-0.5)*0.0625;
	b = fbm(vec3(vec2((p.x+rnd)*32.,p.y*32.),time));
	
	
	
	gl_FragColor = vec4( vec3( r,g,b ), 1.0 );

}