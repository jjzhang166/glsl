#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {


	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec4 color = vec4(37.0/255.0, 119.0/255.0, 140.0/255.0, 1.0);
	if(position.y < 0.2 + (sin(2.0*position.x + time)+0.9)/4.0 /*&& position.y < (sin(2.0*position.x - (0.5*time))+3.5)/4.0*/){
		color.rgb = vec3(109.0/255.0, 182.0/255.0, 111.0/255.0);
	}
	if(gl_FragCoord.x > (resolution.x/2.0)){
		color.rgb = vec3(19.0/255.0, 18.0/255.0, 11.0/255.0);
	}

	gl_FragColor = color;
}