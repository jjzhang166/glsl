#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 position;


float addLight (vec2 pos, float size, vec3 c)
{
	float tmp = 0.0;
	
	float dist = distance(position, pos);
	
	float clmp=clamp(sin(time*2.0)*0.5,0.08,0.3);
	
	tmp += (size / dist)  * clmp;
	tmp = pow(tmp,clamp(sin(time) * 2.0, 2.0, 4.0));
	
	return  tmp;
}



void main( void ) {
	position = ( gl_FragCoord.xy / resolution.xy )*4.0;

	float dest_color = 0.0;
	
	//dest_color += addLight(vec2(0.5+sin(time*1.2)*0.5,0.5), 0.5, vec3(1.0, 0.0, 0.0));
//	dest_color += addLight(vec2(0.2,0.7+cos(time)*0.2), 0.3, vec3(0.0, 1.0, 0.0));

	for(int i = 0; i < 8; i ++)
	{
		float _a = float(i);
		dest_color += addLight(vec2(_a * 0.3, cos(sin(time*_a)*2.0)), 0.5,vec3(0.0));
	}
	
	gl_FragColor = vec4(dest_color*0.8*cos(length(dest_color)),dest_color*0.5,dest_color*sin(time),1.0);

}