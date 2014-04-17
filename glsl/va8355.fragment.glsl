#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec4 color = vec4(0.0/255.0, 151.0/255.0, 232.0/255.0, 1.0);
	if(position.y > (sin(2.0*position.x + time)+0.5)/7.0 && position.y < (sin(2.0*position.x - (0.5*time))+3.5)/4.0){
		color.rgb = vec3(1.0, 1.0, 1.0);
	}
	

	gl_FragColor = color;

  }