#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy )-vec2(0.5,0.5);
	pos *= 4.;
	float s = sin(pos.x * mouse.x * 100.) * mouse.y * 2.;
	vec3 color = vec3(sin(time), sin(time*2.), sin(time*4.)); //timebased colorshift
		//color += sin( pos.x * cos( time / 15.0 ) * 80.0 ) + cos( pos.y * cos( time / 15.0 ) * 10.0 ); //predefined color
		//color += sin( pos.y * sin( time / 10.0 ) * 40.0 ) + cos( pos.x * sin( time / 25.0 ) * 40.0 );
		//color += sin( pos.x * sin( time / 5.0 ) * 10.0 ) + sin( pos.y * sin( time / 35.0 ) * 80.0 );
		//color *= sin( time / 10.0 ) * 0.5;
	//float t=sin(time)+1.01; //timebased thickness
	float t=0.15;
	if(sin(pos.y) - t > s || sin(pos.y) + t < s){ //thickness of sin
		color = vec3(1., 1., 1.); //backgroundcolor
	}

	gl_FragColor = vec4(color , 1.0);
	
}