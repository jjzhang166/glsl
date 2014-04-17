precision mediump float;

varying vec2 surfacePosition;
uniform float time;
uniform vec2 resolution;

float hash( float n )
{
    return fract( sin(n)* 43758.5453123 );
}

float noise1( float x )
{
    float p = floor(x);
    float f = fract(x);

    f = f*f*(3.0-2.0*f);

    return mix( hash(p+0.0), hash(p+1.0), f );
}

float fbm( float p )
{
    float f = 0.0;

    f += 0.5000*noise1( p ); p = p*2.02;
    f += 0.2500*noise1( p ); p = p*2.03;
    f += 0.1250*noise1( p ); p = p*2.01;
    f += 0.0625*noise1( p );

    return f/0.9375;
}

// war of the ants, i vote for the black ones
float random(float p) {
  return fract(sin(fract(tan(p)))*12345.);
}

float noise(vec2 p) {
  return random(mod(asin(-2.0+time)/(p.x*p.x)+p.y, fract(acos(-1.0+time)/(p.y*p.y)+p.x)));
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	float c = dot( vec3( fbm( uv.y * 5.134 + time * 2.013 ),
			             fbm( uv.y * 15.002 + time * 3.591 ),
						 fbm( uv.y * 25.922 + time * 4.277 ) ),
		   vec3( .85, .35, .17 ) );

	

	float scanline = sin(uv.y*800.0)*0.1;
	c -= scanline;
	
  	c*=noise(gl_FragCoord.xy*time/300.0+304.0);
	
	gl_FragColor = vec4( c, c, c, 1.);
}