#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float RandomNumberBetween0And1(vec2 pos){
	return fract(
		
		(
		+cos(pos.x)
		+sin(pos.y)
		+fract(pos.x/10.0)
		+fract(pos.y/10.0)
		-pow(pos.x,0.5)
		-pow(pos.y,0.5)
		)
		*10.0
		
	);
}

float Random(float minn,float maxn, vec2 pos){
	float GeneratedNumber = RandomNumberBetween0And1(pos);
	GeneratedNumber *= maxn;
	if (GeneratedNumber < minn){
		GeneratedNumber += minn;
	}
	return GeneratedNumber;
}
	

void main( void ) {
	vec2 PixelPos = gl_FragCoord.xy;
	float col = Random(0.1,1.0,PixelPos);
	gl_FragColor = vec4(col,col,col,1);

}