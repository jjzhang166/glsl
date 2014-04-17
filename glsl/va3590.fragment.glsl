#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
void main( void ) {

  vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	
	
  float red = 0.0;
  float green = 0.0;
  float blue = 0.0;;

	  for(int i=0; i<8; i++)
	  {
		  float tt = time / float(1+i);
		float tx = sin(tt * position.x+0.5); 
		float ty = cos(tt * position.y);
  	red += tx;
  	green += ty*0.66;
  	blue += tx*0.33;;
	  
	  
	  }
	
	red /= 8.0;
	green /= 8.0;
	blue /= 8.0;
	
	
  vec3 rgb = vec3(red, green, blue);
  vec4 color = vec4(rgb, 1);
  gl_FragColor = color;
  
}