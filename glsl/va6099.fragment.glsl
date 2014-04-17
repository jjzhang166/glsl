
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Tweaked by T21 : 3d noise


//Reminds me of old school nearest neighbor sampling 

float rand(vec3 n)
{
  n = floor(n*50.);
  return fract(sin((n.x+n.y*1e2+n.z*1e4)*1e-4)* 1e6);
}

float map( vec3 p )
{
  p = mod(p,vec3(1.0, 1.0, 1.0))-0.5*vec3(1.0, 1.0, 1.0);
	p.z *= p.y;
  vec2 h = vec2(0.1, 0.1);
  vec3 q = abs(p);
  return max(q.z-h.y,max(q.x*0.866025+p.y*0.5,-p.y)-h.x*0.5);
}

void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.3), sin(time*0.3), 1.5);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 0.5;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 100;
    const float MAX_DISTANCE = 1000.0;
    float c = 0.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        if(d<0.001) { c = 1.0; break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
    }
    float fog = 5.0;
    vec4 result = vec4( vec3(c * 0.4, c * 0.7, c *0.2) * (fog - total_d) / fog, 1.0 );

    gl_FragColor = result*rand(ray);
}
