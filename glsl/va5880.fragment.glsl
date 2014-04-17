/*
								3 - channel life
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); 
}

vec3 rand3( vec2 seed ) {
	float t = sin(seed.x+seed.y*1e3);
	return vec3(fract(t*1e4), fract(t*1e6), fract(t*1e5));
}

float calcVal( float me, float sum)
{
        if ( me > 0.0 ) // alive
        {
            if ( sum >= 2.0 && sum <= 3.0)
            {
                return 1.0;
            }
        }else // dead
        {
            if ( sum == 3.0)
            {
                return 1.0;
            }
        }
	return 0.0;
}

void main( void ) 
{
	vec2 t = gl_FragCoord.xy / resolution.xy;	
	vec4 myColor = texture2D( backbuffer, t );
	bool firstTime = !bool ( myColor.a );
	vec2 gridStep = 1.0 / resolution.xy;
	
	vec4 n0 = texture2D(backbuffer, vec2(t.x , t.y ));
        vec4 n1 = texture2D(backbuffer, vec2(t.x - gridStep.x, t.y - gridStep.y));
        vec4 n2 = texture2D(backbuffer, vec2(t.x, t.y - gridStep.y));
        vec4 n3 = texture2D(backbuffer, vec2(t.x + gridStep.x, t.y - gridStep.y));
        vec4 n4 = texture2D(backbuffer, vec2(t.x - gridStep.x, t.y));
        vec4 n5 = texture2D(backbuffer, vec2(t.x + gridStep.x, t.y));
        vec4 n6 = texture2D(backbuffer, vec2(t.x - gridStep.x, t.y + gridStep.y));
        vec4 n7 = texture2D(backbuffer, vec2(t.x, t.y + gridStep.y));
        vec4 n8 = texture2D(backbuffer, vec2(t.x + gridStep.x, t.y + gridStep.y));
	
        vec4 sum = n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8;
 
        vec4 color = vec4( calcVal( n0.r, sum.r ), calcVal( n0.g, sum.g ), calcVal( n0.b, sum.b ), 1.0);  
	
	
	gl_FragColor = ( firstTime )? vec4( step( 0.5, rand3( t )), 1.0 ) : color;
	
	//gl_FragColor.a = 0.0; //  <----------    uncomment/comment this to reset
}