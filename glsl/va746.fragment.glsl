// Coloured dots, by FreeFull
// I don't even know GLSL


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

  	float red = sin(pos.x*sin(time*0.1)*100.0 + cos(time+pos.y)) * cos(pos.y*30.0*pos.x);
  	float green = sin(pos.x*sin(time*0.12)*100.2 + cos(time+pos.y)) * cos(pos.y*29.0*pos.x);
  	float blue = sin(pos.x*sin(time*0.12)*100.3 - cos(time+pos.y-0.4)) * cos(pos.y*22.0*pos.x);
  	if(red < 0.0) red = -red;
  	if(green < 0.0) green = -green;
  	if(blue < 0.0) blue = -blue;
  
	gl_FragColor = vec4( red, green, blue, 1.0 );

}