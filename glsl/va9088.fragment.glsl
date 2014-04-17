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
	float R = 10.0;
	float r = 2.0;
	float a = 2.0;
	float m_t = 1.0;
	float vertColor = 0.0;
	for( float i = 0.0; i < 10.0; ++i )
	{
		float t = time * (0.9);
	
		//uPos.y += (R-r)*sin((r/R)*m_t)+a*sin(1.0-(r/R)*m_t*t);
		uPos.x += (R-r)*cos((r/R)*m_t)+a*cos(1.0-(r/R)*m_t*t);
		float fTemp = abs(1.2 / (uPos.x - 0.1) / 250.0);
		vertColor += fTemp;
		color += vec3( (fTemp*(15.0-i)/20.0)*sin(i*mouse.y), (fTemp*i/10.0), pow(fTemp,0.99)*sin(i*mouse.x) );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;

}