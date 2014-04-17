/*
	===Simple Fractal Experiment===

   Move your mouse and see different fractals from julia set,
   if you don't move mouse, it will change anyway as time progess..

   Enjoy.. 

*/


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



float f( in vec2 pos )
{

    float m1 = cos( time ) * mouse.y;
    float m2 = sin( time ) * mouse.x;	
   
	
    vec2 zn = pos;
    vec2 c = vec2( m1, m2 ); 
    float index = 0.0;

    for( int i = 0; i < 256; i++ ){
        
        vec2 zn1 = vec2( zn.x * zn.x - zn.y * zn.y, 2.0 * zn.x * zn.y ) + c;

        if( length( zn1 ) >= 2.0 )
            break;

        
        zn = zn1;
         
        index += 1.0;   
    }

    

    return index / 256.0;
}

void main( void ) {

	vec2 position = -1.0 + 2.0 *  ( gl_FragCoord.xy / resolution.xy );
	
	position.x *= resolution.x / resolution.y;
	
	float col = 1.0 - f( position ) ; 
	
	float co =   1.0 - log2(.5*log2(col/0.5));

        vec3 color = vec3( .5+.5*cos(6.2831*co+0.5), .5+.5*cos(6.2831*co + 0.5), .5+.5*cos(6.2831*co +0.5) );
	
	gl_FragColor = vec4( color,  1.0 );

}