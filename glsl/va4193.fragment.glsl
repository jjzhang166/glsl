#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = (gl_FragCoord.xy - mouse*400.0)/1.0 + vec2(-50,10);
	float  MODF  = 360.0;
	float DIVF = 64.0;
	float   n = 0.0;

	float x0 = p.x/DIVF - 1.5;
	float y0 = p.y/DIVF;
	float x  = x0;
	float y  = y0;
	float x2 = x*x;
	float y2 = y*y;

	for(int i=0;i<1080;i++){
		n=float(i);
		if(x2+y2 >= 4.0){
			break;
		}
		float xx = x2 - y2 + x0;
		y = 2.0*x*y + y0;
		x = xx;

		x2 = x*x;
		y2 = y*y;
	}

	// 色を出力
	float nn = mod(n,MODF);
	if(n/MODF < 1.0){
		gl_FragColor = vec4( nn/MODF, 0, 0, 0 );
	}else if(n/MODF < 2.0){
		gl_FragColor = vec4( 0, nn/MODF, 0, 0 );
	}else{
		gl_FragColor = vec4( 0, 0, nn/MODF, 0 );
	}

	return;
}