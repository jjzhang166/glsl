#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Random color mixing handy function with weight.

vec3 MixColor(vec3 col1, float weight1, vec3 col2, float weight2)
{
	float r = (col1.x*weight1+col2.x*weight2)/(weight1+weight2);
	float g = (col1.y*weight1+col2.y*weight2)/(weight1+weight2);
	float b = (col1.z*weight1+col2.z*weight2)/(weight1+weight2);
	return vec3(r,g,b);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 Color1 = vec3(mouse.x,mouse.y,0);
	vec3 Color2 = vec3(sin(mouse.x),cos(mouse.y),1);
	
	vec3 finalcolor = MixColor(Color1,mouse.y,Color2,mouse.x);
	gl_FragColor = vec4( finalcolor, 1.0);

}