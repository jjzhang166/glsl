

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define THICKNESS 0.01


float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

float drawGraph(vec2 pos, float env) {
	if ((pos.y < env + THICKNESS) && (pos.y > env - THICKNESS)) {
		return 1.0;	
	}
	return 0.0;
}

void main( void ) {
	vec3 color = vec3(0.0);
	float PI = 3.1415926535897932384626433; 
	
	vec2 position = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	//position = position * vec2(2.0) - vec2(1.0); 	

	color = vec3(drawGraph(position, sin(time*1.3)*(sin(position.x*time*10.001+time*2.)))); 
	
	

	vec2 uv=.5*(1.+position);
	
	vec3 color2 = vec3(texture2D(backbuffer,uv));
	//color2.x*=sin(time);
	color +=.94*color2;
	
	
	
	gl_FragColor = vec4(color,1.0);
	
	
}