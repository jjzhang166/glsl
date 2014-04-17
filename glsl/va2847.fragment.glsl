#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int maxdepth = 50;

vec3 random(vec3 coordinate)
{
	coordinate = floor(coordinate);
	float x = time;
	vec3 s1 = sin(x * 3.3422 + coordinate.xxx * vec3(24.324234, 563.324234, 657.324234)) * 543.3423;
	vec3 s2 = sin(x * 1.1893 + coordinate.yyy * vec3(567.324234, 435.324234, 432.324234)) * 654.5423;
	vec3 s3 = sin(x * 2.6554 + coordinate.zzz * vec3(543.213112, 123.432342, 465.23234)) * 878.3221;
	return fract(2142.4 + s1 + s2 + s3);
}

int depth(vec2 coordinate)
{
	coordinate /= resolution.xy;
	coordinate -= vec2(0.5,0.5);
	coordinate.x *= resolution.x/resolution.y;
	
//	coordinate += vec2(0.3*sin(time + 324.3),0.3*cos(time*1.5 + 23.4543));
	
	float d = 40.0 + 5.0*sin(time);
	
	if (length(coordinate) < 0.09 - d*0.001)
	{
		return int(d);
//		return 40;
	}
	else return maxdepth;
}


void main( void ) {
/*
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

//	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
*/
	
	int hitdepth = 0;
	int hitoffset = 0;
	for (int offset = 0; offset <= maxdepth; ++offset)
	{
		if (depth(gl_FragCoord.xy + vec2(float(offset),0)) == offset)
		{
			hitdepth = offset;
			hitoffset = offset;
			break;
		}
		if (depth(gl_FragCoord.xy + vec2(float(-offset),0)) == offset)
		{
			hitdepth = offset;
			hitoffset = -offset;
			break;
		}
	}
	
	
	float r = random(vec3(gl_FragCoord.x+float(hitoffset),gl_FragCoord.y,0.0)).x;
#if 0
	if (hitdepth == maxdepth)
		r = 1.0 - float(hitdepth)/float(maxdepth);
#endif
	vec3 r3 = vec3(r,r,r);

	gl_FragColor = vec4(r3,1.0);

}