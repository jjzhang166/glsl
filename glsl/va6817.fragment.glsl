precision mediump float;

const mediump float maxItr = 500.0;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition; // use this for pan and zoom!!



void main ()
{
	vec2 position = surfacePosition+0.5;
    	//vec2 c = vec2((position.x*4.0)-3.0, (position.y *3.0)-1.5);
	vec2 c = surfacePosition;
    	vec2 z = c;

    float d;
    float mu;
    float abs;
    float log_2 = log(2.0);
    int index;
    float leftEdge = -2.45;
    float topEdge = 2.625 / -2.0;
    for( float i = 0.0; i < maxItr; i += 1.0)
    {
        z = vec2(z.x*z.x - z.y*z.y, z.x*z.y + z.x*z.y) + c;
        
        d = dot( z, z);
        
        if( d > 2.0)
        {
		//z = vec2(z.x*z.x - z.y*z.y, z.x*z.y + z.x*z.y) + c;
		//z = vec2(z.x*z.x - z.y*z.y, z.x*z.y + z.x*z.y) + c;
		abs = z.x*z.x+z.y*z.y;
		mu = i + 2.0 - log(abs) / log_2;
		if (mu < 0.0) { index = 0; } else { index = int(mu / maxItr * 767.0); }
		if (index >= 767) { index = 765; }
	    if (index >= 512) {
		gl_FragColor = vec4(float(index - 512), float(255 - (index - 255)), 0.0, 1.0);
	    } else if (index >= 256) {
		gl_FragColor = vec4(0.0, float(index - 256), float(255 - (index - 255)), 1.0);    
	    } else {
		gl_FragColor = vec4(0.0, 0.0, float(index), 1.0);    
	    }

            break;
        }
    }
	
}