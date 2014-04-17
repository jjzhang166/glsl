#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{

	vec2 position = ( gl_FragCoord.xy );
	vec4 color;
	float res_scale = resolution.x / resolution.y;
	float x_dist = distance(position.x/resolution.x, mouse.x);
	float y_dist = distance(position.y/resolution.y, mouse.y);
	
	if(x_dist*res_scale<0.05+0.025*sin(time*10.0) && y_dist<0.05+0.025*sin(time*10.0))
	{
		color.rgb = vec3(1.0);
	}
	else
	{
		color.rgb = vec3(0.0);
	}		

	gl_FragColor = vec4(color.rgb,1);
}