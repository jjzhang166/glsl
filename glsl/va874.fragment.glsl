
// by @eddbiddulph

#ifdef GL_ES
precision highp float;
#endif

#define EPS         vec3(0.001, 0.0, 0.0)
#define CELL_SIZE   vec2(0.03, 0.03)
#define STROKE_SIZE vec2(0.03, 0.001)
#define STROKE_RAD  0.01
#define MOT_RAD     0.02

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float circle(vec2 o, float r, vec2 p)
{
	return distance(p, o) - r;
}

float box(vec2 o, vec2 s, vec2 p)
{
	return length(max(vec2(0.0), abs(p - o) - s));
}

float wineGlassProfile(vec2 p)
{
	p.y = -p.y - 1.7;

	vec2 a = vec2(0.45, 0.67), b = vec2(0.0, 0.2);
	float g = 0.4, h = (a.x - b.x) - g;
	vec2 c = vec2(h, -0.9), d = vec2(0.2, -1.15), c2 = vec2(0.0, c.y);
	float i = (d.x - c2.x) - h, j = 0.72, k = (c2.y - d.y) - i;
	float l = 0.6, m = 0.8, f = a.y - b.y - g;

	float dist;

	// base of body
	dist = max(max(max(circle(vec2(d.x, (d.y - j) + k), j, p), -circle(vec2(d.x, (d.y - j) + k), j - k, p)), 0.0 - p.x), d.y - j + k - p.y);

	// body
	dist = min(dist, -0.05 + box(vec2(d.x + j - k * 0.5, (d.y - j) + k - l * 0.5 ), vec2(k * 0.5 - 0.05, l * 0.5), p));

	return dist;
}

// signed distance function for wine-glass model. revolution of profile
// is around z-axis. the base of the glass is at a higher z than the rim.
float wineGlass(vec3 p)
{
	return wineGlassProfile(vec2(length(p.xy), p.z));
}

vec3 rotateY(vec3 v, float a)
{
	return vec3(cos(a) * v.x - sin(a) * v.z, v.y, sin(a) * v.x + cos(a) * v.z);
}

vec3 rotateX(vec3 v, float a)
{
	return vec3(v.x, cos(a) * v.y - sin(a) * v.z, sin(a) * v.y + cos(a) * v.z);
}

float sceneDist(vec3 p)
{
    return wineGlass(p);
}

vec3 sceneNorm(vec3 p)
{
    float dist = sceneDist(p);
    return normalize(vec3(sceneDist(p + EPS.xyz) - dist, sceneDist(p + EPS.zxy) - dist, sceneDist(p + EPS.yzx) - dist));
}

vec3 sceneColour(vec3 p, vec3 eye)
{
    vec3 n = sceneNorm(p), lpos = vec3(5.0, 5.0, 5.0);
    vec3 ldir = normalize(lpos - p);
    
    vec3 diff = vec3(1.0, 0.6, 0.2), spec = vec3(1.0);
    vec3 r = reflect(normalize(p - eye), n);
    
    return  diff * max(0.0, 0.5 + dot(ldir, n) * 0.5) + spec * pow(max(0.0, dot(r, ldir)), 10.0);
}


vec3 texture(vec2 p)
{
	vec3 rd = vec3(0.0, 0.0, 1.0);
	vec3 ro = vec3(0.0, 0.0, -3.0);

	rd.xy = p;

	float angle_x = (mouse.y) * 6.0, angle_y = (mouse.x - 0.5) * 6.0;

	ro = rotateX(rotateY(ro, angle_y), angle_x);
	rd = rotateX(rotateY(rd, angle_y), angle_x);

	rd = normalize(rd);

	vec3 eye = ro;

    int hit_id = 0;
    
    for(int i = 0; i < 30; ++i)
    {
        float dist = sceneDist(ro);

        if(dist < 0.02)
        {
            hit_id = 1;
            break;
        }

        ro += rd * dist;

        if(distance(ro, eye) > 5.0)
            break;
    }

    return (hit_id == 1) ? sceneColour(ro, eye) : vec3(0.0);
}


vec2 textureGrad(vec2 p)
{
    float c = length(texture(p));
    return vec2(length(texture(p + EPS.xy)) - c, length(texture(p + EPS.yx)) - c);
}

// d dmust be normalized
float strokeMask(vec2 o, vec2 d, vec2 p)
{
    vec2 uv = vec2( dot(p - o, d), dot(p - o, vec2(-d.y, d.x)) );
    return step(length(max(vec2(0.0), abs(uv) - STROKE_SIZE)) - STROKE_RAD, 0.0);
}

void main( void ) {

    vec2 p = vec2(gl_FragCoord.xy / resolution.xy - 0.5) * vec2(resolution.x / resolution.y, 1.0);

    const float sl = STROKE_SIZE.x + STROKE_SIZE.y + STROKE_RAD + MOT_RAD;
    
    float time2 = time * 2.0;
    
    gl_FragColor.a = 1.0;
    gl_FragColor.rgb = texture(p);

    for(float v = -sl; v < +sl; v += CELL_SIZE.y)
        for(float u = -sl; u < +sl; u += CELL_SIZE.x)
        {
            vec2 tt = p + vec2(u, v);
            vec2 tc = mod(tt, CELL_SIZE);
            
            tt = (tt - tc) + CELL_SIZE * 0.5;
            
            vec2 mot_ofs = vec2(cos(tt.y * 300.0 + time2), sin(tt.x * 300.0 + time2)) * MOT_RAD;
            
            vec2 d = textureGrad(tt + mot_ofs).yx * vec2(-1.0, 1.0);
            
            // skip degenerate gradients
            if(dot(d, d) == 0.0)
                continue;
            
            gl_FragColor.rgb = mix(gl_FragColor.rgb, texture(tt + mot_ofs),
                                    strokeMask(CELL_SIZE * 0.5 + vec2(u, v) + mot_ofs, normalize(d), tc));
        }
}


