#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Inspired by: http://glsl.heroku.com/e#9804.0

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float tod = time*0.5;
	if (mod(tod,6.28) > 1.57 && mod(tod,6.28) < 4.71) tod+=3.14; // sun shall not go backwards!!
	
	float r = 0.0, g = 0.0, b = 0.0;
	vec2 sunPos;
		
	sunPos.x = resolution.x*0.5+(sin(tod))*resolution.x*0.55;
	//sunPos.y = resolution.x-abs(resolution.x*0.5-sunPos.x);
	sunPos.y = resolution.y-(pow((sunPos.x-resolution.x*0.5),2.0)*1.0/(resolution.x*0.5));
	
	if (gl_FragCoord.y<pow(resolution.x-abs(gl_FragCoord.x-resolution.x*0.5),0.20)*resolution.y*0.1){
		g = 0.5;
	} else if (distance(sunPos,gl_FragCoord.xy) < 25.0){
		r = 0.8;
		g = 0.8;
	} else {
		b = 1.0-pow(abs(sin(time*0.5)),2.0);
	}

	gl_FragColor = vec4(r,g,b,1.0 );

}