#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.x -= clamp(cos(time * 0.4), 0.0, 1.0);
	uPos.y -= clamp(sin(0.5 * time/50.0) - .0, 0.5, 1.0);
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 10.0; ++i )
	{
		float t = time * (0.9);
	
		uPos.y += sin( uPos.x*(i+1.0) + t+i/5.0 ) * 0.1;
		float fTemp = abs(1.2 / (uPos.y - 0.1) / 250.0);
		vertColor += fTemp;
		color += vec3( (fTemp*(15.0-i)/20.0)*sin(i*mouse.y), (fTemp*i/10.0), pow(fTemp,0.99)*sin(i*mouse.x) );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;

}