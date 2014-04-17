#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy * exp( -(     (mouse.x-0.0)*(mouse.x-0.0)/(resolution.x*resolution.x) + (mouse.y-0.0)*(mouse.y-0.0)/(resolution.y*resolution.y)      )    );     //( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float xcolor =  position.x/resolution.x;
	float ycolor = position.y/resolution.y;
	float xycolor = xcolor*ycolor;
		
	
	//color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	//color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	//color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	//color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4(  xcolor, ycolor , xycolor, 1.0) ;  //sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}