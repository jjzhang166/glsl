#ifdef GL_ES
precision mediump float;
#endif
//Ashok Gowtham M
//UnderWater Caustic lights
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//normalized sin
float sinn(float x)
{
	return sin(x)/2.+.55;
}



vec3 lazer(vec2 pos, vec3 clr, float mult)
{
	vec3 color;
	// calc w which is the width of the lazer
	float w = fract(time*0.5);
	
	// add a ball
	float d = distance(pos,vec2(-1.0+w*2.0,0.0));
	color += (clr * 0.25*w/d);
	return color;
}

void main( void ) 
{
	
	
	
	vec2 pos2 = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	//pos.x *= resolution.x / resolution.y;
	vec3 color = max(vec3(0.2), lazer(pos2, vec3(1, 0.8, 2.), 0.15));
	gl_FragColor = vec4(color * 0.5, 1.0);
}