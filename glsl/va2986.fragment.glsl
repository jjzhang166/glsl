// @scratchisthebes
// I'm a noob to GLSL, here's my first creation "all by myself"
// I call it CMYCircles
// Enjoi

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float dist(vec2 a, vec2 b) {
	float xx = b.x-a.x;
	float yy = b.y-a.y;
	float d = sqrt((xx*xx)+(yy*yy));
	if(d < 0.4) {
		return d;
	} else {
		return d+0.3; //glow
	}
}

float cosScr(float m, float o) { //returns a cosine between 1...0
	return (cos((time+o)*m)+1.0)/2.0;
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy ;

	float r=dist(position,vec2(cosScr(1.0,1.6),cosScr(0.6,0.2)));
	float g=dist(position,vec2(cosScr(1.3,0.8),cosScr(0.7,0.7)));
	float b=dist(position,vec2(cosScr(0.6,0.3),cosScr(0.2,0.5)));
	
	gl_FragColor = vec4( r,g,b, 1.0 );

}