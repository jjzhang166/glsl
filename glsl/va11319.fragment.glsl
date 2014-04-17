#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb; //backbuffer
varying vec2 surfacePosition;


void main( void ) {
	vec2 pt = gl_FragCoord.xy/resolution.xy;
	vec2 p = pt;//surfacePosition + 0.5;
	vec3 color;
	float border = 0.5;
	if (p.x > border)
		color.r += 1.;
	if (p.y > border)
		color.g += 1.;
	
	if (p.x<border && p.y<border)
		color = vec3(0);
		
	
	if (p.x>border && p.y>border) {
		vec2 p2;
		//p2 = vec2(cos(p.x),sin(p.y));
		p2 = (p-0.50)*2.;
		if (p2.x>=0.&&p2.y>=0.&&p2.x<=1.&&p2.y<=1.)
			color = texture2D(bb, p2).xyz;
	}
	
	gl_FragColor.xyz = color;

}