/*
								Old good Game of Life.
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); 
}

vec2 rand2( vec2 seed ) {
	float t = sin(seed.x+seed.y*1e3);
	return vec2(fract(t*1e4), fract(t*1e6));
}

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 t = gl_FragCoord.xy / resolution.xy;
	
	vec4 myColor = texture2D( bb, t );
	
	bool firstTime = !bool ( myColor.a );
	
	vec2 gridStep = 1.0  / resolution.xy;
	
	vec4 n0 = texture2D(bb, vec2(t.x , t.y ));
        vec4 n1 = texture2D(bb, vec2(t.x - gridStep.x, t.y - gridStep.y));
        vec4 n2 = texture2D(bb, vec2(t.x, t.y - gridStep.y));
        vec4 n3 = texture2D(bb, vec2(t.x + gridStep.x, t.y - gridStep.y));
        vec4 n4 = texture2D(bb, vec2(t.x - gridStep.x, t.y));
        vec4 n5 = texture2D(bb, vec2(t.x + gridStep.x, t.y));
        vec4 n6 = texture2D(bb, vec2(t.x - gridStep.x, t.y + gridStep.y));
        vec4 n7 = texture2D(bb, vec2(t.x, t.y + gridStep.y));
        vec4 n8 = texture2D(bb, vec2(t.x + gridStep.x, t.y + gridStep.y));
	
        vec4 sum = n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8;
 
        vec4 color = vec4(0.0, 0.0, 0.0, 1.0);  

        if ( n0.r > 0.0 ) // alive
        {
		
            if ( (sum.r >= 2.0) && (sum.r <= 3.0))
            {
                color = vec4(1.0, 0.0, 1.0, 1.0);
            }

        }else // dead
        {
            if ( sum.r == 3.0)
            {
                color = vec4(1.0, 1.0, 1.0, 1.0);
            }
        }
	
	

	
	gl_FragColor = ( firstTime )? vec4( step( 0.5, rand2( t )), 0.0, 1.0 ) : color;//vec4( step( 0.5, rand2( t )), 0.0, 1.1 );
	
	
	//gl_FragColor.a = 0.0; //  <----------    uncomment/comment this to reset
	
        
}