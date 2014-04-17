// @scratchisthebes
// I'm a noob to GLSL, here's my first creation "all by myself"
// I call it CMYCircles
// Enjoi

// @rotwang: @mod* aspect for real circles, enjoy... :-)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float dist(vec2 a, vec2 b) {

	float d = length(b-a);
	if(d < 0.4) {
		return d;
	} else {
		return d+0.3; //glow
	}

}


float cosScr(float m, float o) { //returns a cosine between 1...0
	return (cos((+o-time)*cos(m))+1.0)/2.0;
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy ;
position.x *= resolution.x / resolution.y;
	float r=dist(position,vec2(cosScr(1.0,1.6),cosScr(0.6,0.2)));
	float g=dist(position,vec2(cosScr(1.3,0.8),cosScr(0.7,0.7)));
	float b=dist(position,vec2(cosScr(0.6,0.3),cosScr(0.2,0.5)));
	
	gl_FragColor = vec4( r,g,b, 1.0 );
	
	// dna transferred by animal bite from http://glsl.heroku.com/e#2976.5
	//
	vec2 vPos=vec2(position.x,position.y);
        float d = distance(vPos, vec2(.0,.0));
	float l = ( 1.0 - length( vPos * .2 ) );
	gl_FragColor.rgb *= smoothstep(2.75, .01, d)*2.5-sin(position.x);//vignette and blare out -gt
	gl_FragColor.rg += mod( gl_FragCoord.y, .1 );
	gl_FragColor.b += mod( gl_FragCoord.y, .31 + position.y);	//lines after vignetting -gt
	
	//

}