#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// Tartan Colors for the @trafopop LED-Jackets by @hintz 2013-09-23
// http://www.trafopop.com

#define M_PI acos(0.0)*2.0

void main(void)
{	
	vec2 position = gl_FragCoord.xy / resolution.x - 0.5;
	
	if (mod(gl_FragCoord.x,2.0)>0.5)
	{
		position.y = 1.0 - position.y; 
	}
	if (mod(gl_FragCoord.y,2.0)>0.5)
	{
		position.x = 1.0 - position.x; 
	}
	
	float s = 0.01 * (0.7 + 0.2 * sin(time * 0.0827));
  	float r = 2.0 * M_PI * sin(time * 0.0742);

  	float sinr = sin(r*1.001);
  	float cosr = cos(r);

	float t = time * 0.000002;
  	vec2 center1 = vec2(cos(t), cos(t*0.535));
  	
    	float x0 = s * position.x;
    	float y0 = s * position.y;
    	float x = (x0*cosr - y0*sinr);
    	float y = (x0*sinr + y0*cosr);

    	float size = 1000.0;
    	float d = distance(vec2(x,y), center1)*size;
    	vec2 color = vec2(cos(d+t),sin(d));
  
    	vec2 ncolor = normalize(color);

    	float red = ncolor.x*ncolor.x;
    	float green = ncolor.x*ncolor.y;
    	float blue = ncolor.x-ncolor.y;
	  
	gl_FragColor = vec4(mod(red,1.0), mod(green,1.0), mod(blue,1.0), 1.0);
	// gl_FragColor = vec4(red, green, blue, 1.0);
}