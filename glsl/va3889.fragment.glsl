// synqera flex experiment phaze one
// for new employments tests
//(c) don kaban 2012

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2  resolution;


void main() 
{
	vec2 position = (gl_FragCoord.xy/resolution.y);
	position -= vec2((resolution.x/resolution.y)/2.0, 0.5);
	
	float phaze 	= sin(time);
	float lenght 	= sqrt(position.x * position.x + position.y * position.y + 0.2);
	float angle  	= atan(position.x,position.y) - phaze * smoothstep(phaze,1.0, lenght) * 5.0 ;
	float bright  	= smoothstep(0.0,1.0, lenght) * (sin(angle * 8.0));	
	
	vec3  col1 = vec3(1.0,0.0,0.0) * phaze;  
	vec3  col2 = vec3(0.0,1.0,0.0) * 1.0-phaze;
	vec3  col3 = vec3(0.0,0.0,1.0) * 1.0-phaze;
	
	
	gl_FragColor = vec4(col1 * bright + col2 * bright + col3 * bright,1.0);
}

