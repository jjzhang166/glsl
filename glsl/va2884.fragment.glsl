#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	position -= vec2(0.5,0.5);
	position *= 2.0;
//	position.y /= resolution.x/resolution.y;

	float d = 0.0;
	
	float t = time * 1.0;
	
	for (int num = 0; num < 10; ++num)
	{
	
		vec2 p = vec2(sin(t + float(num)*234.322)*0.5,cos(t*1.21 + float(num)*654.534)*0.5);
		
		p -= position;
		
		float l = length(p)*3.0;
		l = 1.0 - l;
		if (l < 0.0) l = 0.0;
		
		
		d += l;
	
	}	
	
	if (d > 1.5)
	{
		gl_FragColor = vec4(0.0,1.0,0.0,1.0);
	}
	else
	{
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	}
	
	
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
	

//	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
//	gl_FragColor = vec4(0.0,fract(position.y),0.0,1.0);

}