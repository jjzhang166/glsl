#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
  	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,1.0);
	position -= vec2(1.4, 1.6);
  
  	float l = length(position);
  
  	float wave2 = sin(l * cos(l)*500. + time*1.5);
  
  	gl_FragColor = vec4(wave2*.5, wave2*.4, wave2*.7, 0.);

}