#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {  
  	vec2 t = gl_FragCoord.xy / resolution;
    	float c = 1.0 - distance(vec2(2.5, 2.5), t);
    	c = c * c;
  	float d = distance(vec2(2.5, 2.5), mouse) * 10.0;
    	c = sin(3.141592 * c * time * d + time);
    	gl_FragColor = vec4(tan(c + sin(time)), cos(c + tan(time)), sin(c + cos(time)), 1);
}