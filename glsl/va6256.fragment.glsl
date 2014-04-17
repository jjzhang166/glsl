#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// [0;1]
float nrand( vec2 co ){
    return fract(sin((co.x+co.y*1e3)*1e-3) * 1e5);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x *= resolution.x/resolution.y;

	float color = 0.0;
	float lcontr= 0.0;
	
	vec2 _lpos = vec2(0.5+sin(time*2.0)*0.2,0.5);
	
	lcontr = 1.0 / distance(_lpos,position)*0.1;

	gl_FragColor = lcontr * vec4(0.2,0.4,0.4,1.0);
	gl_FragColor += nrand(gl_FragCoord.xy+0.89*fract(time))/255.0; //bandyless \o/
}