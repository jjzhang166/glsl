#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec4 color = vec4(vec3(sin(position.x) * cos(position.y)), 1.0);

	if(position.x > sin(position.y) + sin(sin(time) * position.x * cos(position.x) *  cos(time * 2.) * sin(cos ( time / .5) * position.y) )){
		color.rgb = vec3(tan(sin(time) * position.x));
	}
	

	gl_FragColor = color;

  }