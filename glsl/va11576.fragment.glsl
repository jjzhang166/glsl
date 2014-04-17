#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - 0.5 - (.03 * sin(time));
	pos.x *= resolution.x / resolution.y ;
	pos.x += .1 * sin(time);
	float len = length(pos * 0.5);
        float c = .01;
	if (len < .3) { c = .9;} 
        c -= smoothstep(0.,1.,len * 2.);
	c *= .8;
	gl_FragColor = vec4(-c, c, c, 1.0);

}