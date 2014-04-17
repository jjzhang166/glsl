#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// this is some WEIRD non-fractal scheisse!
// i'm sorry but now it is
void main( void ) 
{
	float time2 = time;
        time2 += 100.0;
	vec2 i,p = abs(( gl_FragCoord.xy / resolution.xy  * 2.0) - 1.0);
	
	vec2 pos = abs(( gl_FragCoord.xy / resolution.xy  * 2.0) - 1.0);
	
	
	
	float m = atan(sin(pos.x+time2) * (sin(pos.y+time2)));
	float k = dot(vec2(sin(pos.x+time2),sin(pos.y+time2)), pos);
	float y = atan(cos(time2) + 0.5) * sin(pos.y*10.0+time2*2.0);
	
	float z = atan(cos(time2) + 0.5) * sin(pos.x*10.0+time2*2.0) * (pos.x*time2) + (pos.y*time2 + 0.5);
	
	
	for(float i = 1.0; i < 4.0; i++)
	{
		m = atan(sin(k+time2) * (sin(y+time2))) * i;
	 	k = dot(vec2(sin(z*0.25+time2),sin(m*y+time2)), vec2(m, y));
	 	y = atan(cos(m) + 0.5) * sin(pos.y*10.0+time2*2.0);
	
	 	z = atan(cos(y) + 0.5) * sin(pos.x*10.0+time2*2.0) * (m*0.5*time2) + (pos.y*time2 + 0.5);
		m += pos.y;
	}
	
	gl_FragColor = vec4(z*m*k,m*y*z,m*k,m*k*z);
}