precision mediump float;

const mediump float maxItr = 40.0;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition; // use this for pan and zoom!!
void main ()
{
	vec2 position = surfacePosition+0.5;
    	vec2 c = vec2((position.x*4.0)-3.0, (position.y *3.0)-1.5);
    	vec2 z = c;

    float d;
    for( float i = 0.0; i < maxItr; i += 1.0)
    {
        z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
        
        d = dot( z, z);
        
        if( d > 4.0)
        {
            gl_FragColor = vec4(sin(i/maxItr)*8.0,i/maxItr,i/maxItr, 1.0);
            break;
        }
    }
}