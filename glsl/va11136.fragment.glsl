
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float map(vec3 p)
{
    const int MAX_ITER = 20;
    const float BAILOUT=4.0;
    float Power=8.0;

    vec3 v = p;
    vec3 c = v;

    float r=0.0;
    float d=1.0;
    for(int n=0; n<=MAX_ITER; ++n)
    {
        r = length(v);
        if(r>BAILOUT) break;

        float theta = acos(v.z/r);
        float phi = atan(v.y, v.x);
        d = pow(r,Power-1.0)*Power*d+1.0;

        float zr = pow(r,Power);
        theta = theta*Power;
        phi = phi*Power;
        v = (vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta))*zr)+c;
    }
    return 0.5*log(r)*r/d;
}

vec4 mainFractal3( vec2 pos, inout vec3 pEnd)
{
    pos += -vec2(0.9,0.3);
    pos *= 2.0;
    vec3 camPos = vec3(cos(time*0.2), sin(time*0.2), 1.5);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.8;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 50;
    const float MAX_DISTANCE = 1000.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        m += 1.0;
        if(d<0.001) { break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
	pEnd = ray;
    }

    float c = (total_d)*0.0001;
    vec4 result = vec4( 1.0-vec3(c, c, c) - vec3(0.025, 0.025, 0.02)*m*0.8, 1.0 );
    return result;
}
//####################################### HEART
vec3 mainHeart(vec2 p)
{
	p += - vec2(0.5,0.55);
	p *= 1.3;
	p.y -= 0.25;
	
	// background color
	vec3 bcol = vec3(0.4,1.0,0.7-0.07*p.y)*(1.0-0.25*length(p));
	
	
	// animate
	float tt = mod(time,0.5)/0.5;
	float ss = pow(tt,0.2)*0.5 + 0.5;
	ss -= ss*0.2*sin(tt*30.0)*exp(-tt*4.0);
	p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);
   

	// shape
	float a = atan(p.x,p.y)/3.141593;
	float r = length(p);
	float h = abs(a);
	float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

	// color
	float s = 1.0-0.5*clamp(r/d,0.0,1.0);
	s = 0.75 + 0.75*p.x;
	s *= 1.0-0.25*r;
	s = 0.5 + 0.6*s;
	s *= 0.5+0.5*pow( 1.0-clamp(r/d, 0.0, 1.0 ), 0.1 );
	vec3 hcol = vec3(1.0,0.5*r,0.3)*s;
	
	vec3 col = mix( bcol, hcol, smoothstep( -0.01, 0.01, d-r) );

	return col;
}
//#################################################
void main() {
	vec2 p = gl_FragCoord.xy/resolution.y;
	vec3 color;
	vec3 pEnd;
	color += mainFractal3(p, pEnd).xyz;
	//mainFractal3(p, pEnd).xyz;
	color += mainHeart(fract(pEnd.xz*10.0));
	
	gl_FragColor.xyz = color;
	gl_FragColor.w = 1.0;
	
}