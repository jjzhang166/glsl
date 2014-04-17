#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {//it compiles on the fly

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float points [50];

	
	float color = 0.0;
	color += pow(atan(position.y,position.x),position.y*position.x);
	color *= sin(color*time);
	
	//color *= cos(color*time);
	color *= (cos(color*(time)));

	float cache = color;
	
	float pf = (sin(color))-cos(color);
	color += pow(pf,0.5);
	
	float buf = color;
	
	color = cache+buf;
	
	float x = 0.5;
	
	color *= sin(x*position.x);
	color *= cos(0.5*position.y);

	gl_FragColor = vec4( color * 0.5, color, color*cos(time), 1.0 );

}