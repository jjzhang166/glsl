#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
 
float rings(vec2 p)
{
	//return sin(length(p)*60.0);
	return sin(length(p));
}

vec4 effect1()
{  
	vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
	return vec4(rings(pos));
}

vec4 effect2()
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse + time*0.3;
	float color = 0.0;
	
	color = sin(position.x * 20.0) * sin(position.y * 10.0) * cos(time * 0.4) ;
	
	return vec4( vec3(-sin(color) * 0.5, color * color, sin(color)), 1.0);
}

void main() {
	gl_FragColor = effect1();// + 0.5*effect2();
}
