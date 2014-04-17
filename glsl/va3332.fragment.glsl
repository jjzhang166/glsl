// by rotwang

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;


void main(void)
{
    vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;
	
	
    float x = abs(p.x);
    float y = abs(p.y)/8.0;
	
    float a = atan(x*x,y)/3.141593 ;
	
	float st = 0.125 + 0.25*sin(time);
	
    float r = mix( length(p)- st*0.5, length(p)* st, sin(time));
    float invr = 1.0-r;
	
  
    float absa = abs(a);

    float shade = smoothstep(r, r+0.1,absa);
    shade *= pow(1.0-r/absa,0.75);
	
	float g = 1.0-length(p);
    vec3 clr = vec3(shade+g,shade*0.9,shade*0.9-g);
	
	
	gl_FragColor = vec4(clr,1.0);
	
}