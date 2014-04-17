// by tigrou
// Obnoxious blurry effects by MidKnight|Centigonal
// T

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;


float f(vec3 o)
{
    float a=(sin(o.x)+o.y*.25)*.35;
    o=vec3(cos(a)*o.x-sin(a)*o.y,sin(a)*o.x+cos(a)*o.y,o.z);
    return dot(cos(o)*cos(o),vec3(1))-1.2;
}

//
// modified by iq:
//   removed the break inside the marching loop (GLSL compatibility)
//   replaced 10 step binary search by a linear interpolation
//
vec3 s(vec3 o,vec3 d)
{
    float t=0.0;
    float dt = 0.4;
    float nh = 0.0;
    float lh = 0.0;
    for(int i=0;i<25;i++)
    {
        nh = f(o+d*t);
        if(nh>0.) { lh=nh; t+=dt; }
    }

    if( nh>0. ) return vec3(.93,.94,.85);

    t = t - dt*nh/(nh-lh);

    vec3 e=vec3(.1,0.0,0.0);
    vec3 p=o+d*t;

    vec3 n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*.4)))*.01);

    return sin(vec3(texture2D(backbuffer, (-n.yz+0.2))).zxy + vec3(0.,0.3,sin(p.y*n.z)* 0.4) +
vec3( mix( ((max(-dot(n,vec3(.577)),0.) + 0.125*max(-dot(n,vec3(-.707,-.707,0)),0.)))*(mod (length(p.xy)*20.,2.)<1.0?vec3(.71,.85,.25):vec3(.79,.93,.4)),vec3(.93,sin(n.g*2.0)*0.5+0.5,.85), vec3(pow(t/9.,5.)) ) * 0.2));
}


void main()
{
    vec2 position = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	float th = time * 0.5;
	mat3 m = mat3(	1.0, 0.0, 0.0,
			0.0, cos(th), sin(th),
			0.0, -sin(th), cos(th) );
	float thd = 0.25 * sin(time*0.0125) + 0.5;
	m *= mat3(	cos(th*thd), -sin(th*thd), 0.0,
			sin(th*thd), cos(th*thd), 0.0,
			0.0, 0.0, 1.0 );
    vec4 colour = vec4(s(vec3(sin(time*1.5)*.5,sin(time)*.5,time), normalize(m*vec3(p.xy*(sin(time*2.0)*.25+1.0),1.0))),1.0);

    vec2 d = 1.0 / resolution.xy;
    float stime = sin(time*1.5+.4);
    vec4 finalNewPos = (
        texture2D(backbuffer, position+d*vec2(1,-1)) +
	texture2D(backbuffer, position+d*vec2(-1, -1)) +
	texture2D(backbuffer, position+d*vec2(-1, 1)) +
	texture2D(backbuffer, position+d*vec2(1, 1))
    ) / 4.0;

    vec4 colorVec = vec4((.1*(stime))+0.75,(0.4*stime)+0.4,0.,1);

    gl_FragColor = mix( mix( colour, texture2D(backbuffer, position )* colorVec, (0.2*(1.0-stime))+0.3),  finalNewPos , 0.87 ) ;

  // gl_FragColor = colour;
}
