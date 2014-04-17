
#ifdef GL_ES
precision mediump float;
#endif

// T21: Can anyone fix the fringe around the cylinders ???
// m: well, not really. it still flickers a bit when camera moves near.
// Nice! THX (I get it) , the last of the fringes was mainly caused by the shading.
// You loose the cap color but this can be added in a more stablew way.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec3 n)
{
  n = floor(n);
  return fract(sin((n.x+n.y*1e2+n.z*1e4)*1e-4)*1e5);
}

float map( vec3 p )
{
	float d = rand(floor(p))*.2;
	float da = rand(floor(p+vec3(0.,0.,1.)))*.2;
	float db = rand(floor(p-vec3(0.,0.,1.)))*.2;
	p = mod(p,vec3(1.0))-0.5;
	vec2 q = vec2(length(p.xy), p.z); 
	vec2 a = vec2(min(da, q.x), .5);
	vec2 b = vec2(min(db, q.x), -.5);
	//return min(q.x-d, min(length(a-q), length(b-q)));
	return min(q.x-d, min(length(a-q), length(b-q)));
}

void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.3), sin(time*0.3), 3.5);
    vec3 camTarget = vec3(0.0, 0.0, .0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.8;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.32;
    float d = 0.0, total_d = 0.;
    const int MAX_MARCH = 100;
    const float MAX_DISTANCE = 100.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray-vec3(0.,0.,time/2.));
        total_d += d;
        ray += rayDir * d;
        m += 1.0;
        if(abs(d)<0.01) { break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
    }

    float c = (total_d)*0.0001;
    vec4 result = vec4( 1.0-vec3(c, c, c) - vec3(0.025, 0.025, 0.02)*m*0.8, 1.0 );
    gl_FragColor = result*rand(ray-vec3(0.,0.,time/2. +.01));;
}
