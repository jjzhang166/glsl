
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Tweaked by T21 : 3d noise

#if 1
float rand(vec3 n, float res)
{
  n = floor(n*res+.5);
  return fract(sin((n.x+n.y*1e2+n.z*1e4)*1e-4)*1e5);
}
#else
float rand(vec3 uv, float res)
{
	const vec3 s = vec3(1e0, 1e2, 1e4);
	
	uv *= res;
	
	vec3 uv0 = floor(mod(uv, res))*s;
	vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
	
	vec3 f = fract(uv);
	f = f*f*(3.0-2.0*f);

	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
		      uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

	vec4 r = fract(sin(v*1e-3)*1e5);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	r = fract(sin((v + uv1.z - uv0.z)*1e-3)*1e5);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	return mix(r0, r1, f.z);
}
#endif

float map( vec3 p )
{
    p = mod(p,vec3(1.0, 1.0, 1.0))-0.5*vec3(1.0, 1.0, 1.0);
    return length(p.xy)-.1;
}

void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.3), sin(time*0.3), 1.5);
    vec3 camTarget = vec3(cos(time), sin(time), -sin(time) * .2);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(cos(time / 2.), sin(cos(time)), 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 3.0 * sin(time) + 3.*(-cos(time));

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 100;
    const float MAX_DISTANCE = 5.0;
    float c = 1.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        if(abs(d)<0.001) { break; }
        if(total_d>MAX_DISTANCE) { c = 0.; total_d=MAX_DISTANCE; break; }
    }
    float fog = 5.0;
    vec4 result = vec4( vec3(c*.4 , c*.6, c) * (fog - total_d) / fog, 1.0 );

    ray.z -= 5.+time*.5;
    float r = rand(ray, 33.);
    gl_FragColor = result*(step(r,.3)+r*.2+.1);
}
