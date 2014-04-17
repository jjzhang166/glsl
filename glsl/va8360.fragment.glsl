#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy-0.5)  ;

	float color =0.;
	float Mx = 22.;
	for ( float i	=22. ; i >8.; i-- ){
		color	*=	0.8;
		color	=	pow(color,1.1);
		float a = p.y + sin(p.x*(1.+i*0.5)+time*2.+sin(time*(0.001 + i*0.0001))*5.0+ time)*0.005*i-0.05*sin(time+i*0.2);
		color	+=	max(0.0,pow(1.0-abs(a),500.)+pow(1.0-abs(a),20.)*0.4);
	}
	
	gl_FragColor = vec4( vec3( color, 0.0 + mouse.x, 0.0 + mouse.y ), 1.0 );

}