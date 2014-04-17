#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// rotation function taken from http://glsl.heroku.com/e#9795.1 
// out of sheer laziness on my part
vec2 rotate(vec2 pos, float angle, vec2 center) {	
  mat2 rot = mat2(cos(angle), -sin(angle),
		  sin(angle),  cos(angle));
  return rot*(pos-center) + center;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	float color = 0.0,color1=0.0, color2=0.0,color4=0.0;
	
	for (float f = 0.0; f < 10.0; f += 0.5){
		float height = sin(gl_FragCoord.x*0.1)*5.0+resolution.y*0.5;
		float test = 10.0-abs(rotate(gl_FragCoord.xy,time*0.25+f*2.0,resolution*0.5).y-height);
	
		
		if (test > 0.0){
			color = test/50.0;
		}
		
		if (f/2.0-floor(f/2.0) == 0.0){
			color1 += color;
		} else if (f-floor(f) == 0.5) {
			color2 += color;
		} else {
			color4 += color;
		}
	}

	gl_FragColor = vec4( color1,color2,color4, 1.0 );

}