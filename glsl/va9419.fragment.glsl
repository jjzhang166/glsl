
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float backglow;
uniform float fogIntensity;
uniform float fogR;
uniform float fogG;
uniform float fogB;
uniform float tracingsR;
uniform float tracingsG;
uniform float tracingsB;
uniform float towerR;
uniform float towerG;
uniform float towerB;

uniform float towerZTwist;
uniform float towerXTwist;

uniform float focus;
uniform float camZ;

// _knaut showing he don't know how to program
	
float sdBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float sdBox( vec2 p, vec2 b )
{
  vec2 d = abs(p) - b;
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}


float sdCross( in vec3 p, in vec2 b )
{
    float da = sdBox(p.xy,b);
    float db = sdBox(p.yz,b);
    float dc = sdBox(p.zx,b);
    return min(da,min(db,dc));
}



mat3 rot;

float map(vec3 p)
{
	float towerZTwist = .4;
	float towerXTwist = .4;
    vec3 orig = p;
    float s = mod(length(p.xz), 1.0) <= 3.0 ? 1.0 : -1.0;
    float sr1 = sin(radians(ceil((p.y+0.1)/0.2*s) * towerZTwist));
    float cr1 = cos(radians(ceil((p.y+0.1)/0.2*s) * towerXTwist));
    rot = mat3(
      cr1, 0, sr1,
       0, 1,  0,
     -sr1, 0, cr1 );

    float d3 = p.z - 0.3;
    p = rot * p;
    p = mod(p.xyz, vec3(3.0)) - vec3(1.5);
    float s1 = length(p.xz)-0.7;

    vec3 p2 = mod(p, vec3(0.2)) - vec3(0.1);
    float d1 = sdBox(p2,vec3(0.075));

    return max(max(s1,d1), d3);
}

vec3 genNormal(vec3 p)
{
    const float d = 0.01;
    return normalize( vec3(
        map(p+vec3(  d,0.0,0.0))-map(p+vec3( -d,0.0,0.0)),
        map(p+vec3(0.0,  d,0.0))-map(p+vec3(0.0, -d,0.0)),
        map(p+vec3(0.0,0.0,  d))-map(p+vec3(0.0,0.0, -d)) ));
}

void main()
{
	float towerR = .4;
	float towerG = .1;
	float towerB = .9;
	
	float tracingsR = .72;
	float tracingsG = .1;
	float tracingsB = .1;
	
	float speed = 0.4;
	
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(0.0,0.0,camZ);
    camPos.y += time*speed;
    vec3 camDir = vec3(0.0,0.0,-1.0);
    vec3 camUp  = vec3(0.0, 01.0, 0.0);
    vec3 camSide = cross(camDir, camUp);
	
    float focus = 1.0;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);	    
    vec3 ray = camPos;
    int march = 0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 64;
    for(int mi=0; mi<MAX_MARCH; ++mi) {
	march = mi;
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        if(d<0.001) {break; }
    }

    float glow = 0.0;
    {
        const float s = 0.0075;
        vec3 p = ray;
        vec3 n1 = genNormal(ray);
        vec3 n2 = genNormal(ray+vec3(s, 0.0, 0.0));
        vec3 n3 = genNormal(ray+vec3(0.0, s, 0.0));
        glow = max(1.0-abs(dot(camDir, n1)-0.5), 0.0)*0.5;
        if(dot(n1, n2)<0.8 || dot(n1, n3)<0.8) {
            glow += backglow;
        }
    }
    {
	vec3 p = rot * ray;
        float grid1 = max(0.0, max((mod((p.x+p.y+p.z*2.0)-time*3.0, 5.0)-4.0)*1.5, 0.0) );
        float grid2 = max(0.0, max((mod((p.x+p.y*2.0+p.z)-time*2.0, 7.0)-6.0)*1.2, 0.0) );
        vec3 gp1 = abs(mod(p, vec3(0.24)));
        vec3 gp2 = abs(mod(ray, vec3(0.36)));
        if(gp1.x<0.23 && gp1.y<0.23) {
            grid1 = 0.0;
        }
        if(gp2.x<0.35 && gp2.y<0.35) {
            grid2 = 0.0;
        }
        glow += grid1+grid2;
    }

    float fog = min(1.0, (1. / float(MAX_MARCH)) * float(march));
    vec3  fog2 = fogIntensity * vec3(fogR, fogG, fogB) * total_d;
    glow *= min(1.0, 4.0-(4.0 / float(MAX_MARCH-1)) * float(march));
    gl_FragColor = vec4(vec3(towerR+glow*tracingsR, towerG+glow*tracingsG, towerB+glow*tracingsB)*fog + fog2, 1.0);
}

	