#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float frac(float x) { return mod(x,1.0); }
float noise(vec2 x,float t) { return frac(sin(dot(x,vec2(1.38984*sin(t),1.13233*cos(t))))*653758.5453); }

bool isEqual( float x, float y, float epsilon )
{  
	if( abs( y - x ) <= epsilon )
	{
		return true;
	}
	return false;
}

void main( void ) {

	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec3 outColor = vec3(0.);
	float PI = 3.1415;	
	float EPSILON = .003;
	float scale = .01;
	float k = 4.;	
	float x = 0.45;
	float y = 0.5;
	
	for( int i = 0; i < 10; i++ )
	{
		float ii = float(i);
		float randomValue = (k * noise( gl_FragCoord.xy, time ));//floor(k * noise( gl_FragCoord.xy, time ));// floor or ceil of this greatly limits the number of branches
		float vx = cos(randomValue * 2. *PI / k );
		float vy = sin(randomValue * 2. *PI / k );
			
		x = x + (vx - x) * scale; 
		y = y + (vy - y) * scale; 
		if( isEqual(x, gl_FragCoord.x/resolution.x, EPSILON) && isEqual(y, gl_FragCoord.y/resolution.y, EPSILON) )
		{
			outColor.x = 1.;
			outColor.y = 1.;
			outColor.z = 1.;
		}
	}

	float x2 = 0.55;
	float y2 = 0.5;
	for( int i = 0; i < 10; i++ )
	{
		float ii = float(i);
		float randomValue = (k * noise( gl_FragCoord.xy, time ));//floor(k * noise( gl_FragCoord.xy, time ));// floor or ceil of this greatly limits the number of branches
		float vx = cos(randomValue * 2. *PI / k );
		float vy = sin(randomValue * 2. *PI / k );
			
		x2 = x2 - (vx - x2) * scale; 
		y2 = y2 + (vy - y2) * scale; 
		if( isEqual(x2, gl_FragCoord.x/resolution.x, EPSILON) && isEqual(y2, gl_FragCoord.y/resolution.y, EPSILON) )
		{
			outColor.x = 1.;
			outColor.y = 1.;
			outColor.z = 1.;
		}
		
	}	
	
	gl_FragColor = vec4( outColor, 1.0 );

}