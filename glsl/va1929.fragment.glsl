#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

	float i( vec2 p, float y, float z )
{
    return length( max( abs(p) - vec2(y) + vec2(z), 0.0 ) ) - z;
}

float h = sqrt( 0.75 );

float C(vec3 p)
{
	vec3 o= p;
	p.x= mod( p.x + step( 2.0 * h, mod( p.y, 4.0 * h ) ), 2.0 ) - 1.0;
	p.y= mod( p.y, 2.0 * h )- h;

	return  h - length( p.xy ) ;
}


void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy )*2. - 1.;
	

	float x = C(vec3(p*10., 1));
	if (x > 0.05) 
		discard;
	
	
	gl_FragColor = mix(vec4(0.3), vec4(1,0.5,0,0), smoothstep(0.,.05,x+0.05));

}