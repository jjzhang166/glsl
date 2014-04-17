#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
float stime = 0.0;
uniform vec2 mouse;
uniform vec2 resolution;
float xtime = 0.0;

vec3 cal_color(vec2 pos)
{
	vec3 color = vec3(0.0,0.0,0.0);
	vec2 c = pos;
	vec2 z = pos;
	for(float i = 0.0; i < 100.0 ; i += 1.0)
	{
		z = vec2(z.x*z.x -z.y*z.y, 2.0*z.x*z.y) + c;
		if (dot(z, z) > 4.0)
		{
			color = vec3(0.0,0.0,i/100.0);
			break;
		}
	}
	return color;
}


void main( void ) {
	xtime = exp(mod(time,50.0)/5.0);
	vec2 position = ( gl_FragCoord.xy / resolution.xy )/xtime-vec2(1.0326-mouse.x/10.0,.3868-mouse.y/10.0);
	gl_FragColor = vec4( cal_color(position), 1.0 );

}