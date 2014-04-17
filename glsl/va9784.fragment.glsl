#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D texSamp;

void main( void ) {
	float height = sin(gl_FragCoord.x*(resolution.x))*cos(time*5.0)*5.0           +resolution.y*0.25;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	
	float color1 = 0.0, color2 = 0.0, color3 = 0.0;
	if ( gl_FragCoord.y < height){ 
		//color1 = resolution.y-gl_FragCoord.y/height;
		//color2 = gl_FragCoord.x/resolution.x;
		color2 = texture2D(texSamp,gl_FragCoord.xy).b;
		color3 = gl_FragCoord.y/height*2.0;
	}

	gl_FragColor = vec4( color1,color2,color3,1.0);

}