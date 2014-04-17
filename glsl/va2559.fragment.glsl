#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
        vec2 position2 = (gl_FragCoord.xy);
	float color = 0.0;
        float color2 =0.0;
	color = position.x;
        //color += position.y;
        color2 = 3.*sin(time);
        
	
        
	
	

	gl_FragColor = vec4( vec3(  1. - (color *2. )-position.y-color2 ,abs(1.- abs((2.*color)-1. ))-position.y-color2 ,  color-.5-position.y-color2  ), 1.0 );
        
        
}