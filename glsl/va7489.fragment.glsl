#ifdef GL_ES
precision mediump float;
#endif
// spiralcity started by Snoep Games.

// playing and naming _knaut

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float rC;
uniform float gC;
uniform float bC;

uniform float patternRes;
uniform float patternGrowth;

uniform float patternOffsetX;
uniform float pattern2Y;
uniform float patternHeight;

void main( void ) {
	
	float patternRes = 120.0;
	float patternGrowth = 0.80;
	float patternOffsetX = -05.0;
	float patternOffsetY = 65.0;
	
	float patternHeight = 0.7580; // 0 - 2 are interesting
	float innerColor = 0.8;
	
	vec2 position = ( patternRes *gl_FragCoord.xy - resolution) / resolution.xx;
	float t=time/300.0;
	float color = 1.0;
	
	float rC = .2;
	float gC = .6;
	float bC = .0;
	
	float x = position.x + patternOffsetX;
	float y = position.y + patternOffsetY;
	
	float pattern2Y = 1.9;

	float var = 1.0;
	
	
	for(int n=0; n<=5; ++n)
	{
		var=var*( patternHeight );
		float p=x;
		
		x=x+sin(y+time);
		y=y+cos(p-time)/var;
		if(atan(y*var,x/1.03) < atan( x , y / patternGrowth ))
		{
			color=+0.5;	// color
		}
		
		if( atan( y / pattern2Y , x )>atan(x,y))
		{
			color= innerColor ; 	//outer color
		}
	}
	
	gl_FragColor.rgba = vec4( rC , gC , color, 0.5);

}