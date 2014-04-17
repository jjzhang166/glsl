// Message for author of http://glsl.heroku.com/e#9700.0

// Hi, thanks for hacking on my shader. I was having real trouble with the zoom coordinates until you came along
// I've had a go at smoothing the zoom, take a look at subPixel.
// I'm not sure what's causing the horizontal and vertical lines from the mouse position
// You can catch me at https://twitter.com/tdhooper

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 nrand3( vec2 co )
{
    vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
    vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
    vec3 c = mix(a, b, 0.5);
    return c;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 subPixel(sampler2D source, vec2 coords) {
	coords = coords * resolution.xy;
	
	float x = floor(coords.x - 0.5) + 0.5;
	float y = floor(coords.y - 0.5) + 0.5;
	
	vec4 pixel         = texture2D(source, vec2(x, y) / resolution.xy);
	vec4 pixelRight    = texture2D(source, vec2(x + 1.0, y) / resolution.xy);
	vec4 pixelTop      = texture2D(source, vec2(x, y + 1.0) / resolution.xy);
	vec4 pixelTopRight = texture2D(source, vec2(x + 1.0, y + 1.0) / resolution.xy);
	
	float xFraction = coords.x - x;
	float yFraction = coords.y - y;
	
	float pixelFull = (1.0 + xFraction) * (1.0 + yFraction);
	
	vec4 colour = pixel * (1.0 / pixelFull)
		    + pixelRight * (xFraction / pixelFull)
		    + pixelTop * (yFraction / pixelFull)
		    + pixelTopRight * ((yFraction * xFraction) / pixelFull);
	
	
	return colour;
}

float averageForRadius(vec2 co, float radius) {
    float average = float(0);
    
    float sampleSize = 1.0;

    int n = 0;
        float y2 = 0.0;
        float x2;
        float x3;
    for (int i = 0; i < 50; i++) {
        if (y2 > radius) break;
        
        x2 = sqrt(pow(radius, 2.0) - pow(y2, 2.0));
                x3 = (x2 - sampleSize) * -1.0;
        
        for (int k = 0; k < 50; k++) {
            if (x3 >= x2) break;
            
            vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y);
            average += subPixel(backbuffer, co + spoint).r;
            n++;
            
            if (y2 != 0.0) {
                vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y * -1.0);
                average += subPixel(backbuffer, co  + spoint).r;
                n++;
            }
            
            x3 += sampleSize;   
        }

        y2 += sampleSize;    
    }

        return average / float(n);
}

void main( void ) 
{
    vec4 col = vec4(0.0);
    
    if(length(mouse*resolution-gl_FragCoord.xy) < 20.)
    {
	
	if (rand(gl_FragCoord.xy / resolution) > 0.998) {
            col = vec4(1.0);
	}
    } else {
        
        //move uv towards center so it causes a zoom in effect
        //gl_fragcoord goes from 0,0 lower left to imagesizewidth,imagesizeheight at upper right
        //float deltax = gl_FragCoord.x-resolution.x/2.0;
        //float deltay = gl_FragCoord.y-resolution.y/2.0;
        float deltax = gl_FragCoord.x/resolution.x-mouse.x;
        float deltay = gl_FragCoord.y/resolution.y-mouse.y;
        //float angleradians = atan2(deltay,deltax) * 180.0/3.14159265;
        //float angleradians = atan(deltay,deltax) * 90.0;
        float angleradians = atan(deltay,deltax)+3.14159265;
        //now walk the vector/angle between current pixel and center of screen to get pixel to average around
        float zoomrate=1.0;
        float newx = gl_FragCoord.x + cos(angleradians)*zoomrate;
        float newy = gl_FragCoord.y + sin(angleradians)*zoomrate;
        //new point   
        vec2 positionPixel = vec2(newx,newy);
	vec2 position = positionPixel/resolution;
    
        vec4 colour = vec4(0.0);
	    
        float activator = averageForRadius(position, 3.0);
        float inhibitor = averageForRadius(position, 10.0);
            
	if (activator > inhibitor) {
            colour = vec4(1.0);
        }
	    
        col=colour;
    }

    //gl_FragColor = vec4(col.r,col.g,col.b,1.0);
}
