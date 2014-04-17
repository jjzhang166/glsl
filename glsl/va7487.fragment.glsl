#ifdef GL_ES
precision lowp float;
precision lowp vec2;
precision highp vec3;
precision lowp vec4;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{
	//if(mod(gl_FragCoord.x,2.0)<1.0)//tv line
	//	discard;
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//uPos.x -= 1.0;
	uPos.y -= 0.7;
	vec3 sint;
	float t;
	float fTemp;
	vec3 color = vec3(0.0);
	float vertColor = 1.0;
	for( float i = 0.0; i < 10.0; ++i )
	{
		t = time * (0.9);
		sint = vec3(sin(t/2.0));
		uPos.x += cos( uPos.y*i ) * .4;
		uPos.y += sin( uPos.x*i + t+i/2.0 ) * 0.2;
		fTemp = abs(1.0 / uPos.y / 100.0);
		vertColor += fTemp;
		color += vec3( fTemp*(5.0-i)/10.0, fTemp*i/10.0, pow(fTemp,1.5)*2.5 );
	}
	
	vec4 color_final = vec4(cos(color+.7)*.8+(color*.2)+(color*sint*.5), 1.0);
	gl_FragColor = color_final;

}