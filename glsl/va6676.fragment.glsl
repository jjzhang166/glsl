#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



const float seed = 0.1;

const float max_red = 210.0 / 255.0;

float rand(vec2 co){
	// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
	co.x += seed;
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 434658.5453116487577816842168767168087910388737310);
}

float noise2f( in vec2 p )
{
	vec2 ip = vec2(floor(p));
	vec2 u = fract(p);
	// http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
	u = u*u*(3.0-2.0*u);
	//u = u*u*u*((6.0*u-15.0)*u+10.0);
	
	float res = mix(
		mix(rand(ip),  rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),   rand(ip+vec2(1.0,1.0)),u.x),
		u.y)
	;
	return res*res;
	//return 2.0* (res-0.5);
}

float fbm(vec2 c) {
	float f = 0.0;
	float w = 1.0;
	for (int i = 0; i < 8; i++) {
		f+= w*noise2f(c);
		c*=2.0;
		w*=0.5;
	}
	return f;
}

void main( void )
{
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 uPos = pos;
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	const float k = 9.;
	for( float i = 1.0; i < k; ++i )
	{
		float t = time * (11.0) +fbm(vec2( cos(time), sin(time)) );
	
		uPos.y += sin( uPos.x*exp(i) - t) * 0.015;
		float fTemp = abs(1.0/(50.0*k) / uPos.y);
		fTemp *= fbm(vec2( cos(time), sin(time)) );
		vertColor *= fTemp * 100. * fbm(vec2( cos(time), sin(time)) );
		color += vec3( fTemp*(i*0.03), fTemp*i/k, pow(fTemp,0.93)*1.2 );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;
	float ft = fract(time);
	gl_FragColor.rgb += vec3( 10.* fbm(vec2(rand( pos +  7.+ ft ),sin(time))), 
				  rand( pos +  9.+ ft ),
				  rand( pos + 11.+ ft ) ) / 32.0;
}
