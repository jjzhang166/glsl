#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141;

void main(void) 
{	
	vec2 position = ( gl_FragCoord.xy - resolution.xy * 0.5 ) / length(resolution.xy) * 400.0;
	vec3 color;

	if(length(position.xy-vec2(-104.8,72.0)) < 12.0) 
	{		
		color = vec3(1.0, 0.82, 0.14)*sin(1.3+(length(position.xy-vec2(-104.0,72.0))/8.0));
		gl_FragColor = vec4(color.xyz, 1.0);
	}
		
	else if(position.x < -100.0 && position.x > -110.0&& position.y > -100.0 && position.y <65.0)
	{

		float pos = position.y * (86.0/53.0);
		
		color = vec3(1.0, 0.8, 0.6)-0.7*sin(position.x*0.10)-0.7*sin(0.70+position.x*0.5);
		gl_FragColor = vec4(color.xyz, 1.0);
	}
	else
	{
		position.x += sin(position.y * 0.1 - time*5.0) * 2.0 + sin(position.x * 0.2 - time*6.0);
		position.y += sin(position.x * 0.1 - time*5.0) * 2.0 + 1.5*sin(position.y * 0.2 - time*2.0);
		float pos = position.y * (86.0/53.0);
		
		if(length(position.xy-vec2(0.8,0.0)) < 37.0) color = vec3(1.0, 0.0, 0.0);
		//if(length(position.xy - vec2(0.8,0.0)) < 10) color = vec3(1.0, 0.0, 0.0);
		else if(abs(position.x) < 105.0 && position.y > -60.0 && position.y <60.0) color = vec3(1.0, 1.0, 1.0);
		//else if(abs(position.x) < 105.0 && position.y < 0.0 && position.y> -60.0) color = vec3(1.0, 0.0, 0.0);
			
		gl_FragColor = vec4(color * (-cos(position.x * 0.03 - time*1.2) * 0.3 + 0.7), 1.);
	}
}