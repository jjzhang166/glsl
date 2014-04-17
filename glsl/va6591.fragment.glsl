precision mediump float;

const mediump float maxItr = 100.0;
uniform vec2 mouse;
uniform vec2 resolution;
 
void main ()
{
	vec2 position = ( gl_FragCoord.xy ) / (resolution);
    	vec2 c = vec2((position.x*3.0)-2.0, (position.y *2.0)-1.0);
    	vec2 z = c;

    float result;
    for( float i = 0.0; i < maxItr; i += 1.0)
    {
        z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
        
        result= dot( z, z);
        
        if( result > 4.0)
        {
            gl_FragColor = vec4(sin(i/maxItr)*8.0,i/(cos(maxItr)*50.0),i/maxItr, 1.0);
            break;
        }
    }
}