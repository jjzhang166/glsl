// Osmo: JULIA SET with mouse and time based constant

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

int grid[10000];


void main( void ) {


	vec2 pos = ( gl_FragCoord.xy / resolution.xy )*4.0;
	pos.x-=2.0;
	//pos -= 1.0;
	
	vec2 mousePos = mouse;
	mousePos.x-=0.5;
	mousePos.y-=0.5;
	mousePos*=2.0;
	
	
	float color = 0.0;
	float dist=sqrt(pos.x*pos.x+pos.y*pos.y);
	color += cos(dist-time*16.0);
	
	float distortf = sin(time)*1.0;
	if( distortf<0.0 ) distortf=0.0;
	vec2 distort = vec2(1.0, 0.7)*distortf;
	
	float colorR = 0.0;
	float colorG = 0.6;
	float colorB = 0.0;
	vec2 c = pos;
	
	vec2 timeDistort;
	timeDistort.x = sin(time*0.7)*sin(time*0.2);
	timeDistort.y = cos(time*0.5)*sin(time*0.0333);
	//pos=distort;
	//pos.x=sin(time);
	//pos.y=cos(time);
	//pos=mousePos;
	c=mousePos+timeDistort;
	for( int iterations=0; iterations<200; iterations++ )
	{
		if( pos.x*pos.x+pos.y*pos.y >= 4.0 ) 
		{
			colorR = float( iterations )*0.2;
			colorR *= colorR;
			colorG = float( iterations )*0.5;

			break;
		}
		vec2 newpos = pos;
		newpos.x = pos.x*pos.x - pos.y*pos.y;
		newpos.y = pos.x*pos.y*2.0;
		pos=newpos+c;
	}
	//colorR = pos.x;
	//colorG = pos.y;
	
	gl_FragColor = vec4( colorR,colorG,colorB,1 );
	//gl_FragColor = vec4( vec3( color*(120.0-dist)/dist/22.0, color , 0), 1.0 );

}