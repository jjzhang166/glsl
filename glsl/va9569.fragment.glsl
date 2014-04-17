#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//suPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	vec4 old = texture2D(tex, uPos) * 0.65;
	
	uPos.x -= 0.5;
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.0; i < 20.0; ++i )
	{
		float t = time * (0.3);
	
		uPos.y += sin( uPos.x*(i) + t+i/5.0 ) * 0.05;
		uPos.y = uPos.y/0.9;
		float fTemp = abs(1.0 / uPos.y / 1000.0);
		vertColor += fTemp;
		color += vec3( fTemp*(20.0-i)/10.0, fTemp*i/20.0, pow(fTemp,0.99)*1.5 );
	}
	
	vec4 color_final = vec4(color, 1.0);
	
	color_final += old;
	
	gl_FragColor = color_final;

}