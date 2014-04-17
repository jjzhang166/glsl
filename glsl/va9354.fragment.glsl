// fuck that shit.

// black to white transition

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, smooth);
}

void main( void ) {

	float delta = mod(time, 3.0)-1.5;

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	float flash = sin(delta*1.0)*1.4-0.7;
	
	float d = rect(pos - vec2(0.0,0.0), vec2(0.50,0.25), 1.0);
	vec3 clr = vec3(0.99,0.6,0.2) *1.95*d + (0.925*flash)+(sin(delta)*1.0+1.0);

	clr.b *= mod(gl_FragCoord.y, 2.0)*5.0;
	gl_FragColor = vec4( clr , 1.0 );

}