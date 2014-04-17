precision mediump float;

const mediump float maxItr = 10.0;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;
 
void main () {

vec2 position = ( gl_FragCoord.xy ) / resolution;
vec2 c = vec2(((mouse.x) *4.0)-2.0, ((mouse.y) *4.0)-2.0);
vec2 z = vec2(((position.x) *4.0)-2.0, ((position.y) *4.0)-2.0);

    float d;
    for( float i = 0.0; i < maxItr; i += 1.0)
    {
        z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
        
        d = dot( z, z);
        
        if( d > 4.0)
        {
            gl_FragColor = vec4( i/maxItr,i/maxItr,i/maxItr, 1.0);
            break;
        }
    }
}