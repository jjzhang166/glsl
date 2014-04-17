#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float m_start_p = 0.06;
float m_end_p = 2.40;

float m_dif = 2.34;
void main( void ) 
{
	vec3 col = vec3(0.1,0.1,0.1);
	
	
    	gl_FragColor = vec4(col, 1.0);

}