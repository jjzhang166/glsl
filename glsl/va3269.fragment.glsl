#ifdef GL_ES
precision mediump float;
#endif

uniform float time;



void main( void ) 
{
	vec2 p = 5.0 * gl_FragCoord.xy;
    	float a = atan(0.1, 0.1) + 1.0 * sin(sqrt(dot(p, p)) * time);
	gl_FragColor = vec4(vec3(8,8,0) * 0.5 + 5.5 * cos(100.0 * a), .1);
}