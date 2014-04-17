//SB: hearts4Sonia
//higly unoptimized. bis

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;



float f1(vec2 offset, float sc)
{
    vec2 pos = gl_FragCoord.xy + offset;
    vec2 p=(pos/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
    p.y -= .2;
   // p *= 1.01*(2.0 + sin(time));
	p *= 2.0;
if (sc > 1.0)
{
	p *= (sc )*1.01*(2.0 + sin(time));
	p.y -= .33;
}
else
{
	p.y -= .2;
	p *= 2.0;
}
    // animate
    float tt = mod(time,2.0)/2.0;
    float ss = pow(tt,.2)*0.5 + 0.5;
    ss -= ss*0.2*sin(tt*6.2831*5.0)*exp(-tt*6.0);
    p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);

    
    float a = atan(p.x,p.y)/3.141593;
    float r = length(p);

    // shape
    float h = abs(a);
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

    // color
    float f = step(r,d) * pow(1.0-r/d,0.25);
    
    return f;
}


float f2(vec2 offset, float sc)
{
    vec2 pos = gl_FragCoord.xy + offset;
	
	
    vec2 p=(pos/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	
    p *= 10.0 * sc;

		
    float angle = sc* time + 0.1*p.x*p.y;
    float scale = 1.0 + 0.25*sin(angle);
    float sina = scale*sin(angle);
    float cosa = scale*cos(angle);
	
    vec2 prot = vec2(1.0);
    prot.x = p.x*cosa - p.y*sina;
    prot.y = p.y*cosa + p.x*sina;

    p = prot;
	
    // animate
    float tt = mod(time,2.0)/2.0;
    float ss = pow(tt,.2)*0.5 + 0.5;
    ss -= ss*0.2*sin(tt*6.2831*5.0)*exp(-tt*6.0);
    p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);

    
    float a = atan(p.x,p.y)/3.141593;
    float r = length(p);

    // shape
    float h = abs(a);
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

    // color
    float f = step(r,d) * pow(1.0-r/d,0.25);
    
    return f;
}


void main(void)
{
    float r = f1(vec2(10.0,10.0) , 1.0);
    float g;
    float b;

	
r*= 0.8;

g = f1(vec2(10.0,10.0),2.0);
	r*= 1.0*(1.0+ 0.85*sin(time));
    gl_FragColor = vec4(r,g,0.0,1.0);
}
