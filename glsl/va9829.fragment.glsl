#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 p = gl_FragCoord.xy;
	float color = 0.0;
	float rectsize = 100.0;
	
	float xdist = mod(p.x,rectsize);
	float ydist = mod(p.y,rectsize);
	float mindist = rectsize*abs(sin(time*1.2));
	
	if(xdist < mindist){
		xdist = 0.0;
	}else{
		xdist = 1.0;
	}
	if(ydist < mindist){
		ydist = 0.0;
	}else{
		ydist = 1.0;
	}
	vec4 actualColor = vec4(0.5+0.5*sin(time),0.4,0.2,1.0);
	
	
	float tot = xdist*ydist;
	//gl_FragColor = vec4(xdist*ydist,0.2,0.2,1);
	actualColor.r *= tot;
	actualColor.g *= tot;
	actualColor.b *= tot;
	gl_FragColor = actualColor;
	
}