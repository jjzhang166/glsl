#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(1.98,8.233))) * 4358.553);
}

void main( void )
{
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 uPos = pos;
	uPos.y -= 1.01;
	
	vec3 color = vec3(0.0);
	float vertColor = 20.0;
	const float k = 2.8;
	for( float i = 1.5; i < k; ++i )
	{
		float t = time * (1.0);
	
		uPos.y += sin( uPos.x*exp(i) - t) * 1.324;
		float fTemp = abs(14.0/(30.0*k) / uPos.y);
		vertColor += fTemp;
		color += vec3( fTemp*(i*.23), fTemp*i/k, pow(fTemp,1.3)*.2 );
	}
	
	vec4 color_final = vec4(color, 2.0);
	gl_FragColor = color_final;
	float ft = fract(time);
	gl_FragColor.rgb += vec3( rand( pos +  312.+ ft ), 
				  rand( pos +  149.+ ft ),
				  rand( pos + 111.+ ft ) ) / 32.0;
}

