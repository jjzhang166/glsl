#ifdef GL_ES
precision mediump float;
#endif

// Wandering fractals
// by Bluish Snout

uniform float time;
uniform vec2 resolution;
 
float scale = 3.0;
const int iter = 100;
float coord = 0.0;
const int numOfFractals = 4;
 
void fractal(float phase)
{
    vec2 z, c, pp;
    int ic;
	
    pp = (gl_FragCoord.xy/resolution.x)*2.0-vec2(1.2,resolution.y/resolution.x);
    c.x = (pp.x * scale + cos(time-phase) * sin(time-phase) * 3.0) * (1.0 + 0.09 * cos((time-phase) * 10.0));
    c.y = (pp.y * scale + sin(time-phase)) * (1.0 + 0.09 * sin((time-phase) * 20.0 + 1.0 * sin(time-phase)));
    

    ic = 0;
    z = c;
    
    for(int i=0; i<iter; i++) 
    {
    	ic = i;
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (z.y * z.x + z.x * z.y) + c.y;
 
	if((x * x + y * y) > 4.0) break;
        z.x = x;
        z.y = y;
    }
 
    if (ic == iter - 1)
    {
  	coord += abs(sin((time-phase)*500.0)*0.3);
    }
    else if ((ic < iter - 1) && (ic > 1))
    {
      	coord += float(ic) / float(iter) * abs(sin((time-phase)*5.0)*0.5 + 0.7) * (1.0 + float(ic) * 0.1);
    }
    else
    {
       	coord = 0.0;
    }
    
    return; 
}
 
void main(void) 
{
    for (int c0 = 0; c0 < numOfFractals; c0++)
    {
        fractal(float(c0));
        gl_FragColor += vec4(coord*0.1*(float(c0)*float(c0)*1.0)*abs(sin(time*0.0001)), coord*0.4*abs(sin(time*0.0001)), coord*0.5*abs(sin(time*0.0001)), 1.0);
	gl_FragColor += vec4(coord * abs((float(c0) - 1.0) * (float(c0) - 2.0)), 
			     coord * abs((float(c0) - 2.0) * (float(c0))), 
			     coord * abs((float(c0) - 3.0) * (float(c0)) * (float(c0) - 1.0)), 
			     1.0);
    }
}
