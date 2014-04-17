#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy+vec2(time*80.,time*160.)+vec2(sin(gl_FragCoord.x*.05)*5.,cos(gl_FragCoord.y*.07)*2.5); // resolution.xy );
	float color = .7*sin(time*2.)+1.;
	if(int( position.y-15.*float(int(position.y/15.))) > 6) color=0.7;
	if(int( position.x-15.*float(int(position.x/15.))) > 6) color=0.2;
	gl_FragColor = vec4( color, (1.+cos(time)*.6)*color,(1.+cos(time))*color, 1.0 );
}