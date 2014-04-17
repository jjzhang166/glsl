//needs a smoother zoom

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


float averageForRadius(vec2 co, float radius) {
    float average = float(0);
    
    float sampleSize = 1.0;

    int n = 0;
        float y2 = 0.0;
        float x2;
        float x3;
    for (int i = 0; i < 5; i++) {
        if (y2 > radius) break;
        
        x2 = sqrt(pow(radius, 2.0) - pow(y2, 2.0));
                x3 = (x2 - sampleSize) * -1.0;
        
        for (int k = 0; k < 5; k++) {
            if (x3 >= x2) break;
            
            vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y);
            average += texture2D(backbuffer, co + spoint).r;
            n++;
            
            if (y2 != 0.0) {
                vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y * -1.0);
                average += texture2D(backbuffer, co  + spoint).r;
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
    float activator = 0.0;
    float inhibitor = 0.0;
    
    if(length(mouse*resolution-gl_FragCoord.xy) < 20.)
    {
        //col = vec4(nrand3(vec2(time,-time)), 1.0);
        col=vec4(0.0);
        activator=0.0;
        inhibitor=0.0;
    } else {
        
        vec2 Delta = vec2(1.0)/resolution;
        vec2 uv = gl_FragCoord.xy / resolution;
    
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
        float zoomrate=1.5;
        float newx = gl_FragCoord.x + cos(angleradians)*zoomrate;
        float newy = gl_FragCoord.y + sin(angleradians)*zoomrate;
        //new point   
        uv = vec2(newx,newy)/resolution;
    
        
        //vec2 position = gl_FragCoord.xy / resolution.xy;
        vec2 position=uv;
        vec4 source = texture2D(backbuffer, position);
        float random = rand(vec2(position.x + time, position.y + time));
        vec4 colour = source + ((random * 2.0) - 1.0) * 0.1;

        activator = averageForRadius(position, 3.0);
        inhibitor = averageForRadius(position, 10.0);
        if (activator > inhibitor) {
        colour += 0.05;
        } else {
        colour -= 0.05;
        } 
        
        col=colour;
    }

    gl_FragColor = vec4(col.r,activator,inhibitor,1.0);
}
