#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D texture;

void main( void ) 
{

	vec2 position = ( gl_FragCoord.xy );
	vec4 color;
	
	float calculation =  -0.999+sin( (position.y - (mouse.y+20.415)*resolution.y)/200.0) - 0.999+cos((position.x - (mouse.x)*resolution.x)/200.0);
	color.rgb = vec3 (calculation)*(5000.0+5000.0*sin(time*5.0));
	//color.rgb += vec3 (-0.98+sin( (position.y - (mouse.y+19.92)*resolution.y)/200.0) - 0.98+cos((position.x - (mouse.x)*resolution.x)/200.0))*1000.0;
	//color.rgb += vec3(1,1,1);
	gl_FragColor = vec4(color.rgb,1);

}