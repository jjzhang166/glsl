#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//http://www.fractalforums.com/landscapeterrain-generation/simple-non-standard-approaches/
//Coded by MrOMGWTF
#define ang 0.601
mat2 rmx=mat2(cos(ang),sin(ang),-sin(ang),cos(ang));

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	vec2 originalPos = pos;
	float height = 0.0;
	float freq = 2.0;
	float amp = 0.3;
	float phase = time * 0.3;
	vec2 offset=vec2(2.5+phase*0.1,1.0+phase*0.07);
	for(int i = 0; i < 9; i++)
	{
		pos = pos * rmx * freq + offset;
		height += sin(pos.x+phase)*sin(pos.y+phase*1.33)*sin(length(pos)*2.33+phase)*amp;
		amp = pow(amp, 1.25);
	}
	gl_FragColor = vec4( vec3( height * 0.35, height, height * 0.2 ) , 1.0 );
	if(height < 0.0)
	{
		height = abs(height);
		gl_FragColor = vec4( vec3(0.0, height * 0.5, height), 1.0);
	}
	gl_FragColor *= pow(1.0 - length(originalPos * 0.5), 1.5);
	gl_FragColor *= 2.8;
	gl_FragColor = pow(gl_FragColor, vec4(1.0 / 2.2));
}