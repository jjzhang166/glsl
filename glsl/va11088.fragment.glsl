#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float cx = -1.;
const float cy = -1.;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p.xy -= .5;
	p.xy *= log(p.xy*pow(time,.15));
	
	p.x=abs(p.x);
	p.y=abs(p.y);
	
	float m=(p.x*p.x+p.y*p.y);
	
	p.x=p.x/m+cx;
	p.y=p.y/m+cy;
	
	vec3 fcol = vec3(sin(p.x)*.6, cos(p.x)*.7, cos(p.x)*.5);
	
	gl_FragColor = vec4( fcol, 1.0 );

}