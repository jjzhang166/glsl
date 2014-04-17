#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// c64 style repeated tile starfield

void Tiler(int x, int y) {
	if (y==3)
	{
		if (int(mod(float(x+int(time*32.0)+4),32.0))==7)
		{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
		
	}
	if (y==7)
	{
		if (int(mod(float(x+int(time*20.0)+15),32.0))==12)
		{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
		
	}
	if (y==19)
	{
		if (int(mod(float(x+int(time*12.0)+4),32.0))==5)
		{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
		
	}
	if (y==25)
	{
		if (int(mod(float(x+int(time*40.0)+19),32.0))==2)
		{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
		
	}
	if (y==30)
	{
		if (int(mod(float(x+int(time*34.0)+24),32.0))==19)
		{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
		
	}
}


void main( void ) {
	
	Tiler(int(mod(gl_FragCoord.x, 32.)), int(mod(gl_FragCoord.y,32.)));

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}