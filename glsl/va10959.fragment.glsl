#ifdef GL_ES
precision mediump float;
#endif

#define RunningFlag	0.0
#define BallPosX	1.0
#define BallPosY	2.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

void main( void )
{
	if( time  < 1.0 )
	{
		gl_FragColor = vec4(vec3(1.0, 0.0, 0.0), 0.0);
	}
	else if( time  < 2.0 )
	{
		gl_FragColor = vec4(vec3(1.0, 1.0, 0.0), 0.0);
	}
	else if( time  < 3.0 )
	{
		gl_FragColor = vec4(vec3(0.0, 1.0, 0.0), 0.0);
		if((gl_FragCoord.y - 0.5) < 1e-2)
		{
			if(gl_FragCoord.x == RunningFlag)
			{
			}
			else if((gl_FragCoord.x - BallPosX) < 1e-2)
			{
				gl_FragColor.a = 0.5;
				gl_FragColor.x = 1.0;
				gl_FragColor.y = 1.0;
				gl_FragColor.z = 1.0;
			}
			else if((gl_FragCoord.x - BallPosY) < 1e-2)
			{
				gl_FragColor.a = 0.9;
				gl_FragColor.x = 1.0;
				gl_FragColor.y = 1.0;
				gl_FragColor.z = 1.0;
			}
		}
		gl_FragColor.y = 0.0;
	}
	else
	{
		float data = 0.0;
		vec2 position = ( gl_FragCoord.xy / resolution.xy );
		float ballx = texture2D(backbuffer, vec2(BallPosX,0.0) / resolution.xy).a;
		float bally = texture2D(backbuffer, vec2(BallPosY,0.0) / resolution.xy).a;
		if(gl_FragCoord.x == BallPosY)
		{
			bally -= 0.01;
			if(bally < 0.2)
			{
				bally = 0.9;
			}
			data = bally;
		}
		if(gl_FragCoord.x == BallPosX)
		{
			data = ballx;
		}
		if(position.y > 0.2)
		{
			gl_FragColor = vec4(vec3(0.75), 0.0);
		}
		else
		{ //In Control box
			if( position.x < 0.35 )
			{
				gl_FragColor = vec4(vec3(0.15), 0.0);
			}
			else if( position.x < 0.45 )
			{
				gl_FragColor = vec4(vec3(0.20), 0.0);
			}
			else if( position.x > 0.65 )
			{
				gl_FragColor = vec4(vec3(0.15), 0.0);
			}
			else if( position.x > 0.55 )
			{
				gl_FragColor = vec4(vec3(0.20), 0.0);
			}
			else 
			{
				gl_FragColor = vec4(vec3(0.25), 0.0);
			}
		}
		if(length(position-vec2(ballx,bally)) < 0.01)
		{
			gl_FragColor.x = 1.0;
		}
		gl_FragColor.a = data;
	}
}