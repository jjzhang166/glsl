#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float Pi = 3.14159265;

void main( void ) 
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	// direction of the progress
	//bool bLeftToRight = true;
	// verlauflength = 0 <-> 1
	float verlaufLength = 1.0;
	//verlaufLength = 0.1;
	// time for a full fill of the bar in seconds
	float fulltime = 5.0;
	
	float anstiegx = 2.0;
	float anstiegy = 4.0;
	
	float fNorm = sqrt(anstiegx*anstiegx + anstiegy*anstiegy);
	if(fNorm>0.0)
	{
		anstiegx /= fNorm;
		anstiegy /= fNorm;
	}
	
	vec2 verlauf = (uv) / verlaufLength;	
	
	// calc modulo of time to fulltime
	float modTime = mod(time, fulltime);
	
	float timefactor = modTime / fulltime;
	//if(!bLeftToRight)
	//	timefactor = 1.0 - timefactor;
	vec3 colorLeft = vec3(1, 0 , 0);
	vec3 colorRight = vec3(0, 0 , 1);
	
	float fullBar = 1.0 + 1.0/verlaufLength;
		
//timefactor = 0.5;
	float t = 0.0;
	
	if(anstiegx>0.0)
		t = verlauf.x*anstiegx + anstiegx - timefactor           * fullBar * anstiegx;
	else
		t = verlauf.x*anstiegx 		  - ( 1.0 - timefactor ) * fullBar * anstiegx;

	if(anstiegy>0.0)
		t += verlauf.y*anstiegy + anstiegy - timefactor 	* fullBar * anstiegy;
	else
		t += verlauf.y*anstiegy 	   - (1.0 - timefactor) * fullBar * anstiegy;

	
	//if(uv.y < 0.6 && uv.y > 0.4 && sqrt(anstiegx*anstiegx + anstiegy*anstiegy)==1.0)
	if(t < 1.0 && t > 0.0)
	gl_FragColor = vec4( mix(colorLeft, colorRight, t), 1.0);
}