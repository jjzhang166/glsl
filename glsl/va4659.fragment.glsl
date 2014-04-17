#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float color = 0.1;
vec3 color_color = vec3(0.0);
vec2 position = vec2(0.0);

void put(float src_x, float src_y, float end_x, float end_y, vec3 color_s, float calc)
{
 if(position.x > src_x && position.x-src_x < end_x &&
    position.y > src_y && position.y-src_y < end_y)
 {
   color = 0.6;
   color_color = color_s * calc;
 }
}

void main( void ) {

	position = ( gl_FragCoord.xy / resolution.xy );
	// 0.5 = half of screen
	// 1.0 = end of screen

	vec2 temp = (resolution.x * gl_FragCoord.xy);
	
	
	put(0.5, 0.0, 0.5, 0.5, vec3(sin(time * 0.5), cos(time), cos(time)), sin(time*10.0) *1.0 );

	put(0.0, 0.0, 0.5, 0.5, vec3(sin(time), sin(time * 0.3), sin(time * 0.6)), sin(time*10.0) *1.0 );
          	
	
	put(0.0, 0.5, 1.0, 1.0, vec3(0.5, 0.5, 0.5), 1.0 );
	
	gl_FragColor = vec4( color_color.x * color, color_color.y * color, color_color.z * color, 1.0 );

}